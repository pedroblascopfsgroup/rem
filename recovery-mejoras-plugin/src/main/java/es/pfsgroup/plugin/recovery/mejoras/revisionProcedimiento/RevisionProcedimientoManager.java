package es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.RevisionProcedimientoCoreDto;
import es.pfsgroup.plugin.recovery.mejoras.api.revisionProcedimientos.RevisionProcedimientoApi;
import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dao.RevisionProcedimientoDao;
import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dto.RevisionProcedimientoDto;
import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.model.RevisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.tareaProcedimiento.dao.MEJTareaProcedimientoDao;

@Component
public class RevisionProcedimientoManager implements RevisionProcedimientoApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private RevisionProcedimientoDao revisionDao;
	
	@Autowired
	private MEJTareaProcedimientoDao tareaProcedimientoDao;

	@Override
	@BusinessOperation(REVISION_PROCEDIMIENTO_GET_LIST_TIPO_ACTUACION)
	public List<DDTipoActuacion> getListTipoActuacion() {

		Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDTipoActuacion> listado = (ArrayList<DDTipoActuacion>) genericDao.getList(DDTipoActuacion.class, fBorrado);

		return listado;
	}

	@Override
	@BusinessOperation(REVISION_PROCEDIMIENTO_GET_LIST_TIPO_PROCEDIMIENTO)
	public List<TipoProcedimiento> getListTipoProcedimiento(Long idTipoAct) {

		if (idTipoAct != null) {
			Filter fIdTipoActuacion = genericDao.createFilter(FilterType.EQUALS, "tipoActuacion.id", idTipoAct);
			Filter fIdTipoActuacion2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			List<TipoProcedimiento> list = (ArrayList<TipoProcedimiento>) genericDao.getList(TipoProcedimiento.class, fIdTipoActuacion, fIdTipoActuacion2);

			return list;
		}
		return null;
	}

	@Override
	@BusinessOperation(REVISION_PROCEDIMIENTO_GET_LIST_TIPO_TAREA)
	public List<TareaProcedimiento> getListTipoTarea(Long idTipoPro) {
		if (idTipoPro != null) {
			return tareaProcedimientoDao.getListaTareaProcedimientos(idTipoPro);
		}
		return null;
	}

	@Override
	@BusinessOperation(REVISION_PROCEDIMIENTO_GET_INSTRUCCIONES)
	public String getInstrucciones(Long idTipoTar) {

		if (idTipoTar != null) {
			Filter fIdTarea = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", idTipoTar);
			Filter fType = genericDao.createFilter(FilterType.EQUALS, "type", "label");
			Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			GenericFormItem item = genericDao.get(GenericFormItem.class, fIdTarea, fType, fBorrado);

			return item.getLabel();
		}
		return null;
	}

	@Override
	@BusinessOperation(REVISION_PROCEDIMIENTO_SAVE_REVISION)
	@Transactional(readOnly = false)
	// public boolean saveRevision(Long idActuacion, Long idTipoProcedimiento,
	// Long idTarea, String instrucciones, Long idAsunto, Long idProcedimiento)
	// {
	public boolean saveRevision(RevisionProcedimientoCoreDto rp) {

		RevisionProcedimiento rev = new RevisionProcedimiento();
		Procedimiento prc = new Procedimiento();

		if (rp.getIdActuacion() != null && rp.getIdTipoProcedimiento() != null && rp.getIdTarea() != null && rp.getInstrucciones() != null && rp.getIdAsunto() != null
				&& rp.getIdProcedimiento() != null) {
			rev.setTacId(rp.getIdActuacion());
			rev.setTpoId(rp.getIdTipoProcedimiento());
			rev.setTarId(rp.getIdTarea());
			rev.setInstrucciones(rp.getInstrucciones());
			rev.setAsuId(rp.getIdAsunto());
			prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", rp.getIdProcedimiento()));
			
			rev.setProcedimiento(prc);

			// Primero guardamos el registro en la tabla revisiones
			genericDao.save(RevisionProcedimiento.class, rev);

			// Ahora cambiamos el estado del procedimiento a 'Pendiente
			// reorganizaci�n' y de sus prc derivados
			return actualizarProcedimientos(prc);

		}
		return false;

	}

	/**
	 * Metodo que actualiza el procedimiento a Pendiente reorganizaci�n y todos
	 * sus prc derivados
	 * 
	 * @param prc
	 * @author oscar
	 */
	private boolean actualizarProcedimientos(Procedimiento prc) {

		// Buscamos los procedimientos derivados
		try {
			List<ProcedimientoDerivado> derivados = prc.getProcedimientoDerivado();

			// Actualizamos el estado de todos los derivados y del proceso padre
			DDEstadoProcedimiento ep = genericDao.get(DDEstadoProcedimiento.class,
					genericDao.createFilter(FilterType.EQUALS, "id",8L));
			prc.setEstadoProcedimiento(ep);
			for (ProcedimientoDerivado d : derivados) {
				d.getProcedimiento().setEstadoProcedimiento(ep);
				genericDao.save(ProcedimientoDerivado.class, d);
				//Adem�s, tenemos que dar por finalizadas las tareas de cada procedimiento
				finalizarTareasAsociadas(d.getProcedimiento().getId());
			}

			//ahora el proceso padre
			prc.setEstadoProcedimiento(ep);
			finalizarTareasAsociadas(prc.getId());
			genericDao.save(Procedimiento.class, prc);
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
	}

	/**
	 * Busca y finaliza las tareas asociadas de un procedimiento
	 * @param id
	 */
	private void finalizarTareasAsociadas(Long id) {
		
		Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<TareaNotificacion> list = genericDao.getList(TareaNotificacion.class, fBorrado, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", id));
		for(TareaNotificacion n: list){
			n.setTareaFinalizada(true);
			n.setFechaFin(new Date());
			genericDao.save(TareaNotificacion.class, n);
			
		}		
	}
	
	

	@Override
	@BusinessOperation(REVISION_PROCEDIMIENTO_GET_LIST_PROCEDIMIENTOS)
	public List<RevisionProcedimientoDto> getListProcedimientosData(Long idAsunto) {

		if (idAsunto != null) {
			
			List<Procedimiento> list = revisionDao.getListaProcedimientosRevisar(idAsunto);
			
			List<RevisionProcedimientoDto> dtoList = new ArrayList<RevisionProcedimientoDto>();
			RevisionProcedimientoDto dto;

			for(Procedimiento p: list){
				dto = new RevisionProcedimientoDto();
				dto.setIdProcedimiento(p.getId());
				if(!Checks.esNulo(p.getTipoProcedimiento()) && !Checks.esNulo(p.getAsunto()))
					dto.setNombreAsunto(p.getTipoProcedimiento().getDescripcion()+" - "+ p.getAsunto().getNombre());
				dtoList.add(dto);
			}
			return dtoList;
		}
		
		return null;
	}

}
