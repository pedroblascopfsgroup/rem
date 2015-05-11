package es.pfsgroup.procedimientos.subasta;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.procedimientos.PROGenericEnterActionHandler;

public class CesionRemateV4EnterActionHandler extends PROGenericEnterActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2432508306623792426L;

	@Autowired
	protected ApiProxyFactory proxyFactory;

	@Autowired
	protected GenericABMDao genericDao;

	@Autowired
	protected SubastaDao subastaDao;

	@Autowired
	private Executor executor;

	@Autowired
	private JBPMProcessManager jbpmUtil;

	/**
	 * Control de la transicion a la que ir despues de crearse la tarea.
	 * Creación o inicialización de la entidad subasta
	 * 
	 * @throws Exception
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {

		
		List<Bien> bienesEntidad = new ArrayList<Bien>();
		Boolean creoProcedimiento = false;
		// heredamos toda la funcionalidad de inicialización de una tarea
		//super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		if (executionContext.getNode().getName().contains("BPMTramiteCesionRemateV4")) {
			Procedimiento prc = getProcedimiento(executionContext);
			Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());
			//
			// Tenemos que crear un procedimiento cesión
			List<LoteSubasta> listado = sub.getLotesSubasta();
			if (!Checks.estaVacio(listado)) {
				for (LoteSubasta ls : listado) {
					List<Bien> bienes = ls.getBienes();
					if (!Checks.estaVacio(bienes)) {
						for (Bien b : bienes) {
							creoProcedimiento = (Boolean) executor.execute(AdjudicacionProcedimientoDelegateApi.BO_ADJUDICACION_ES_BIEN_CON_CESION_REMATE, b.getId());
							if (creoProcedimiento) {
								bienesEntidad.add(b);
							}
						}
					}
				}
			}
			if (!Checks.estaVacio(bienesEntidad)) {
				creaProcedimientoCesionRemate(prc, bienesEntidad);
			}
		}

	}

	private void creaProcedimientoCesionRemate(Procedimiento procPadre, List<Bien> bienesTerceros) {
		MEJProcedimiento procHijo = new MEJProcedimiento();

		procHijo.setAuditoria(Auditoria.getNewInstance());
		procHijo.setProcedimientoPadre(procPadre);
		procHijo.setPlazoRecuperacion(procPadre.getPlazoRecuperacion());
		procHijo.setSaldoRecuperacion(procPadre.getSaldoRecuperacion());
		procHijo.setPorcentajeRecuperacion(procPadre.getPorcentajeRecuperacion());
		procHijo.setJuzgado(procPadre.getJuzgado());
		procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
		procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
		procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
		procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
		procHijo.setAsunto(procPadre.getAsunto());
		procHijo.setExpedienteContratos(procPadre.getExpedienteContratos());
		procHijo.setDecidido(procPadre.getDecidido());
		procHijo.setFechaRecopilacion(procPadre.getFechaRecopilacion());

		// seteo el procedimiento como 'derivado'
		DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
				DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
		procHijo.setEstadoProcedimiento(estadoProcedimiento);

		// seteo el tipo de actuación
		DDTipoActuacion tipoActuacion = genericDao.get(DDTipoActuacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", procPadre.getTipoActuacion().getCodigo()));
		// DDTipoActuacion tipoActuacion = (DDTipoActuacion)
		// executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
		// DDTipoActuacion.class, procPadre.getTipoActuacion());
		procHijo.setTipoActuacion(tipoActuacion);

		// seteo el tipo de prodecimiento adjudicación
		TipoProcedimiento tipoProcedimiento = genericDao.get(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "P410"));
		procHijo.setTipoProcedimiento(tipoProcedimiento);

		// seteo el tipo de reclamación heredado del padre
		DDTipoReclamacion tipoReclamacion = genericDao.get(DDTipoReclamacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", procPadre.getTipoReclamacion().getCodigo()));
		// DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion)
		// executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
		// DDTipoReclamacion.class, procPadre.getTipoReclamacion());
		procHijo.setTipoReclamacion(tipoReclamacion);

		// Agrego las personas al procedimiento
		List<Persona> personas = new ArrayList<Persona>();
		for (Persona p : procPadre.getPersonasAfectadas()) {

			personas.add(genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", p.getId())));
		}
		procHijo.setPersonasAfectadas(personas);

		// Agrego el bien al procedimiento
		List<ProcedimientoBien> procedimientosBien = new ArrayList<ProcedimientoBien>();

		ProcedimientoBien procBienCopiado = null;
		ProcedimientoBien prcBien = null;
		for (Bien bien : bienesTerceros) {

			procBienCopiado = new ProcedimientoBien();
			prcBien = new ProcedimientoBien();

			prcBien = genericDao.get(ProcedimientoBien.class, genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId()),
					genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", procPadre.getId()));

			procBienCopiado.setSolvenciaGarantia(prcBien.getSolvenciaGarantia());
			procBienCopiado.setProcedimiento(procHijo);
			procBienCopiado.setBien(bien);

			procedimientosBien.add(procBienCopiado);
		}
		
		for (ProcedimientoBien procedimientoBien : procedimientosBien) {
			genericDao.save(ProcedimientoBien.class, procedimientoBien);
		}

		
		
		procHijo.setBienes(procedimientosBien);

		executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO, procHijo);

		// Lanzar los JBPM para cada procedimiento
		String nombreJBPM = procHijo.getTipoProcedimiento().getXmlJbpm();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, procHijo.getId());
		Long idBPM = jbpmUtil.crearNewProcess(nombreJBPM, param);

		procHijo.setProcessBPM(idBPM);
		executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO, procHijo);

		// FIXME
		crearNotificacionManualAdjudicacion(procPadre);

	}

	private void crearNotificacionManualAdjudicacion(Procedimiento prc) {
		EXTTareaNotificacion notificacion = new EXTTareaNotificacion();
		notificacion.setProcedimiento(prc);
		notificacion.setAsunto(prc.getAsunto());
		notificacion.setEstadoItinerario(genericDao.get(DDEstadoItinerario.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoItinerario.ESTADO_ASUNTO)));
		SubtipoTarea subtipoTarea = genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR));
		if (subtipoTarea == null) {
			throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR);
		}

		notificacion.setEspera(Boolean.FALSE);
		notificacion.setAlerta(Boolean.FALSE);

		notificacion.setTarea("Se inicia trámite de cesión de remate");
		notificacion.setDescripcionTarea("Se inicia trámite de cesión de remate");

		notificacion.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
		notificacion.setSubtipoTarea(subtipoTarea);
		DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, "5");
		notificacion.setTipoEntidad(tipoEntidad);
		Date ahora = new Date(System.currentTimeMillis());
		notificacion.setFechaInicio(ahora);
		notificacion.setFechaVenc(ahora);
		notificacion.setFechaVencReal(ahora);
		notificacion.setFechaFin(ahora);
		notificacion.setTareaFinalizada(true);
		notificacion.setEmisor(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getApellidoNombre());

		Auditoria audit = new Auditoria();
		audit.setUsuarioCrear(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getApellidoNombre());
		audit.setFechaCrear(ahora);
		audit.setFechaBorrar(ahora);
		audit.setUsuarioBorrar(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getApellidoNombre());
		audit.setBorrado(true);
		notificacion.setAuditoria(audit);

		notificacion = genericDao.save(EXTTareaNotificacion.class, notificacion);

		TareaExterna tex = new TareaExterna();
		tex.setAuditoria(audit);
		tex.setTareaPadre(notificacion);
		tex.setTareaProcedimiento(genericDao.get(TareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "P401_BPMTramiteCesionRemateV4")));
		tex.setDetenida(false);
		genericDao.save(TareaExterna.class, tex);

	}

}
