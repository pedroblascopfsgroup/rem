package es.pfsgroup.recovery.bpmframework.procedimiento;

import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkProcedimientoApi;

@Service
@Transactional(readOnly = false)
public class RecoveryBPMfwkProcedimientoManager implements RecoveryBPMfwkProcedimientoApi {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(MSV_BO_OBTENER_TAREA_ACTIVA_MAS_RECIENTE)
	public Long obtenerTareaActivaMasReciente(Long idProcedimiento) {

		Long idTareaExterna = null;
		
		MEJProcedimiento procedimiento = (MEJProcedimiento) genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),
				genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento));
		
		if (!Checks.esNulo(procedimiento)) {
			if (procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO)
				|| (procedimiento.getDerivacionAceptada() 
					&& !procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO)
							&& !procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO))) {
				Set<TareaNotificacion> tareasProc = procedimiento.getTareas();

				Date ultimaFecha = new GregorianCalendar(1900,0,1).getTime();
				for (TareaNotificacion tar : tareasProc) {
					TareaExterna tarExterna = tar.getTareaExterna();
					if (!Checks.esNulo(tarExterna)) {
						if (tarExterna.getAuditoria() != null && !tarExterna.getAuditoria().isBorrado()
								//&& (!Checks.esNulo(tarExterna.getCancelada())) && (!tarExterna.getCancelada().booleanValue())
								//&& !Checks.esNulo(tarExterna.getDetenida()) && !tarExterna.getDetenida() 
								) {
							if (tarExterna.getTareaPadre() != null) {
								TareaNotificacion tarNotificacion = tarExterna.getTareaPadre();
								if (tarNotificacion.getTareaFinalizada() == null || !tarNotificacion.getTareaFinalizada()) {
									if (tarNotificacion.getFechaInicio().after(ultimaFecha)) {
										ultimaFecha = tarNotificacion.getFechaInicio();
										idTareaExterna = tarExterna.getId();
									}
								}
							}
						}
					}
				}
			}
		}
		
		return idTareaExterna;
		
	}

}
