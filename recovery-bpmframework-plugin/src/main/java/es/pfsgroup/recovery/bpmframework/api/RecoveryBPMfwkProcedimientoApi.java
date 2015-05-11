package es.pfsgroup.recovery.bpmframework.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Manager encargado de realizar operaciones relacionadas con procedimiento
 * @author pedro
 *
 */
public interface RecoveryBPMfwkProcedimientoApi {
	
	public static final String MSV_BO_OBTENER_TAREA_ACTIVA_MAS_RECIENTE = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkProcedimientoApi.obtenerTareaActivaMasReciente";
	
	/**
	 * Devuelve el Id de la tarea externa más reciente del procedimiento
	 * @return Long id de la tarea externa
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_TAREA_ACTIVA_MAS_RECIENTE)
	public Long obtenerTareaActivaMasReciente(Long idProcedimiento);

}
