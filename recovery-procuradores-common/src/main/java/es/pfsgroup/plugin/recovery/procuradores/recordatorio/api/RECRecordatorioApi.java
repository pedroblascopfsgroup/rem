package es.pfsgroup.plugin.recovery.procuradores.recordatorio.api;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dto.RECRecordatorioDto;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.model.RECRecordatorio;


public interface RECRecordatorioApi {

	public static final String PLUGIN_PROCURADORES_GET_LISTA_RECORDATORIOS = "plugin.procuradores.recordatorio.getListaRecordatorios";
	public static final String PLUGIN_PROCURADORES_GET_LISTA_TAREAS_RECORDATORIOS = "plugin.procuradores.recordatorio.getListaTareasRecordatorios";
	public static final String PLUGIN_PROCURADORES_COUNT_LISTA_RECORDATORIOS = "plugin.procuradores.recordatorio.getCountRecordatorios";
	public static final String PLUGIN_PROCURADORES_COUNT_LISTA_TAREAS_RECORDATORIOS = "plugin.procuradores.recordatorio.getCountTareasRecordatorios";
	public static final String PLUGIN_PROCURADORES_GET_RECORDATORIO = "plugin.procuradores.recordatorio.getRecordatorio";
	public static final String PLUGIN_PROCURADORES_SAVE_RECORDATORIO = "plugin.procuradores.recordatorio.saveRecordatorio";
	public static final String PLUGIN_PROCURADORES_RESULEVE_RECORDATORIO = "plugin.procuradores.recordatorio.resolverRecordatorio";
	public static final String PLUGIN_PROCURADORES_RESULEVE_TAREA_RECORDATORIO = "plugin.procuradores.recordatorio.resolverTareaRecordatorio";
	

	
	/**
	 * Obtiene un listado de {@link RECRecordatorio}. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link RECRecordatorio} paginada.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_GET_LISTA_RECORDATORIOS)
	public Page getListaRecordatorios(RECRecordatorioDto dto);
	
	/**
	 * Obtiene un listado de {@link TareaNotificacion}. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link TareaNotificacion} paginada.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_GET_LISTA_TAREAS_RECORDATORIOS)
	public Page getListaTareasRecordatorios(RECRecordatorioDto dto);
	
	/**
	 * Obtiene un {@link RECRecordatorio}. 
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link RECRecordatorio} paginada.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_GET_RECORDATORIO)
	public RECRecordatorio getRecRecordatorio(Long idRecordatorio);
	
	
	/**
	 * Guarda un {@link RECRecordatorio}. 
	 * @param request.
	 * @return void.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_SAVE_RECORDATORIO)
	public Long saveRecRecordatorio(RECRecordatorioDto dto);

	/**
	 * Obtiene el número de {@link RECRecordatorio}. 
	 * @return Long.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_COUNT_LISTA_RECORDATORIOS)
	public Long getCountListadoRecordatorios();
	
	
	/**
	 * Obtiene el número de {@link EXTTareaNotificacion}. 
	 * @return Long.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_COUNT_LISTA_TAREAS_RECORDATORIOS)
	public Long getCountListadoTareasRecordatorios();
	
	
	/**
	 * Resulve el {@link RECRecordatorio}. 
	 * @param idRecordatorio.
	 * @return void.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_RESULEVE_RECORDATORIO)
	public void resolverRecordatorio(long idRecordatorio);
	
	
	/**
	 * Resulve el {@link RECRecordatorio}. 
	 * @param idTarea.
	 * @return void.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_RESULEVE_TAREA_RECORDATORIO)
	public void resolverTareaRecRecordatorio(long idTarea);
	
	
	
}
