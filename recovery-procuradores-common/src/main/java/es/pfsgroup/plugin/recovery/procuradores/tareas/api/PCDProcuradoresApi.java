package es.pfsgroup.plugin.recovery.procuradores.tareas.api;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.tareas.dto.PCDProcuradoresDto;

/**
 * Manager encargado de la gestión de las operaciones relacionadas con los Procuradores.
 * @author manuel
 *
 */
public interface PCDProcuradoresApi {
	
	public static final String PCD_COUNT_LISTADO_TAREAS_PENDIENTES = "es.pfsgroup.plugin.recovery.procuradores.tareas.api.getCountListadoTareasPendientes";
	public static final String PCD_GET_LISTADO_TAREAS_PENDIENTES = "es.pfsgroup.es.plugin.recovery.procuradores.tareas.api.getListadoTareasPendientesValidar";
	public static final String PCD_BUSCAR_TAREAS_PENDIENTES = "es.pfsgroup.es.plugin.recovery.procuradores.tareas.api.buscarTareasPendientesDelegator";
	public static final String PCD_GET_LISTADO_TAREAS_PENDIENTES_PAUSADAS = "es.pfsgroup.es.plugin.recovery.procuradores.tareas.api.getListadoTareasPendientesValidarPausadas";
	
	/**
	 * Devuelve las tareas pendientes de vaildar
	 * @param idUsuario (Long) id. del usuario.
	 * @return
	 */
	@BusinessOperationDefinition(PCD_COUNT_LISTADO_TAREAS_PENDIENTES)
	public Long getCountListadoTareasPendientes(Long idUsuario);
	
	
	@BusinessOperationDefinition(PCD_GET_LISTADO_TAREAS_PENDIENTES)
	public Page getListadoTareasPendientesValidar(PCDProcuradoresDto dto);
	
	
	@BusinessOperationDefinition(PCD_BUSCAR_TAREAS_PENDIENTES)
	public Page buscarTareasPendientesDelegator(DtoBuscarTareaNotificacion dto, String comboEstado, Long comboCtgResol);
	
	@BusinessOperationDefinition(PCD_GET_LISTADO_TAREAS_PENDIENTES_PAUSADAS)
	public Page getListadoTareasPendientesValidarPausadas(PCDProcuradoresDto dto);
	
}