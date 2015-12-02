package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;

@Service("subastaManagerOnline")
@Transactional(readOnly = false)
public class SubastaManagerOnline implements SubastaOnlineApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private NMBProjectContext projectContext;
	
	@Autowired
	private Executor executor;
	
	@BusinessOperation(BO_NMB_SUBASTA_BUSCAR_LOTES_GUARDAR_ESTADO)
	public void guardaEstadoLoteSubasta(Long[] idLotes, DDEstadoLoteSubasta estado, String codMotivoSuspSubasta, String observaciones) {
		List<Subasta> subastas = new ArrayList<Subasta>();
		for (Long id : idLotes) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
			LoteSubasta lote = genericDao.get(LoteSubasta.class, filtro);
			lote.setEstado(estado);
			lote.setFechaEstado(new Date());
			lote.getAuditoria().setFechaModificar(new Date());
			lote.getAuditoria().setUsuarioModificar(SecurityUtils.getCurrentUser().getUsername());
			if (!Checks.esNulo(observaciones)) {
				lote.setObservacionesComite(observaciones);
			}
			genericDao.save(LoteSubasta.class, lote);

			// Comprueba que esta subasta no ha sido tratada ya por este proceso.
			if (!subastas.contains(lote.getSubasta())) {
				// Actualiza la tarea de la subasta Validar propuestas (comentario + avanzaBPM)
				actualizaSubastaInstrucciones(lote, estado, codMotivoSuspSubasta, observaciones, idLotes);
				subastas.add(lote.getSubasta());
			}
		}
	}
	
	/**
	 * Decide la actualización del BPM, guardando la tarea y avanzando el BPM
	 * 
	 * @param subasta
	 * @param estado
	 * @param codMotivoSuspSubasta
	 * @param observaciones
	 * @param idLotes Lotes que se están actualizando el masa
	 */
	private void actualizaSubastaInstrucciones(LoteSubasta lote, DDEstadoLoteSubasta estado, String codMotivoSuspSubasta, String observaciones, Long[] idLotes) {

		if (projectContext==null) {
			return;
		}

		// Sólo vamos a coger la tarea ValidarPropuesta que esté pendiente.
		Subasta subasta = lote.getSubasta();
		
		// Busca la tarea ValidarPropuesta para saber si tiene que hacer algo con el BPM, en caso de no encontrar
		// esa tarea no actualiza el BPM y termina la ejecución de este método.
		List<TareaExterna> tareas = (List<TareaExterna>)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTO, subasta.getProcedimiento().getId());
		TareaExterna tareaValidarPropuesta = null;
		for (TareaExterna tarea : tareas) {
			boolean estamosEnTareaStop = projectContext.getTareasStopValidarLotesSubasta().contains(tarea.getTareaProcedimiento().getCodigo());
			if (estamosEnTareaStop && 
					(tarea.getTareaPadre().getTareaFinalizada()==null || !tarea.getTareaPadre().getTareaFinalizada())) {
				tareaValidarPropuesta = tarea;
				break;
			}
		}
		// No hemos encontrado la tarea validar propuesta, por tanto no hacemos nada más  (no actualizamos BPM).
		if (tareaValidarPropuesta==null) {
			return;
		}

		// Para los cambios a aprobado, hay que comprobar que todos los lotes estén aprobados para avanzar una subasta por el BPM.
		// si encuentra alguno que no esté aprobado no avanza el BPM
		if (DDEstadoLoteSubasta.APROBADA.equals(estado.getCodigo())) {
			// Si es una tarea de AProbada, comprueba que todos los lotes de esta subasta estén aprobados.
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "subasta.id", subasta.getId()); 
			List<LoteSubasta> lotes = genericDao.getList(LoteSubasta.class, filtro);
			boolean encontradoNoAprobado = false;
			for (LoteSubasta loteSub : lotes) {
				if (!Arrays.asList(idLotes).contains(loteSub.getId()) && 
						!DDEstadoLoteSubasta.APROBADA.equals(loteSub.getEstado())) {
					encontradoNoAprobado =true;
					break;
				}
			}
			if (encontradoNoAprobado) {
				return;
			}
		}

		// Guarda tarea y avanza BPM
		avanzaBPMSubasta(tareaValidarPropuesta, subasta, estado, codMotivoSuspSubasta, observaciones);
	}
	
	/**
	 * Guarda la tarea  avanza el BPM en Validar propuestas de instrucciones.
	 * 
	 * @param tareaValidarPropuesta
	 * @param subasta
	 * @param estado
	 * @param codMotivoSuspSubasta
	 * @param observaciones
	 */
	private void avanzaBPMSubasta(TareaExterna tareaValidarPropuesta, Subasta subasta, DDEstadoLoteSubasta estado, String codMotivoSuspSubasta, String observaciones) {
		
		if (projectContext==null) {
			return;
		}
		
		// Actualización del BPM y avanza el BPM
		// Establece los valores para la tarea según lo introducido
		GenericForm form = new GenericForm();
		//form.setView(tareaExterna.getTareaProcedimiento().getView());
		//form.setErrorValidacion(validacionPreviaDeLaTarea(tareaExterna));
		// cambiar el dao por un manager
		form.setTareaExterna(tareaValidarPropuesta);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tareaValidarPropuesta.getTareaProcedimiento().getId()); 
		List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);
		form.setItems(items);
				
		// Guarda la tarea Validar propuesta y Avanza el BPM
		DtoGenericForm dtoForm = new DtoGenericForm();
		dtoForm.setForm(form);
		String[] nombreItems = new String[dtoForm.getForm().getItems().size()];
		for (int i=0;i<nombreItems.length;i++) {
			nombreItems[i] = dtoForm.getForm().getItems().get(i).getNombre();
		}
		String[] valores = projectContext.valoresTareaValidarPropuestaDesdeCambioMasivoLotes(subasta, nombreItems, tareaValidarPropuesta, estado, codMotivoSuspSubasta, observaciones);
		dtoForm.setValues(valores);
		
		//asignaValoresALosItems(subasta, dtoForm, tareaValidarPropuesta, estado, codMotivoSuspSubasta, observaciones);
		executor.execute("genericFormManager.saveValues", dtoForm);
	}
	
}
