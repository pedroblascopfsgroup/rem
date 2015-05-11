package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api;

import java.util.Map;
import java.util.Set;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;

/**
 * Manager encargado de obtener las relaciones entre tipo de resolución y tipos de input
 * 
 * @author pedro
 * 
 */
public interface MSVResolucionInputApi {

	public static final String MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA = "es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.obtenerTiposResolucionesTarea";
	public static final String MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA_COUNT = "es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.obtenerTiposResolucionesTareaCount";
	public static final String MSV_BO_OBTENER_TIPOS_RESOLUCIONES_SIN_TAREA = "es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.obtenerTiposResolucionesSinTarea";
	public static final String MSV_BO_OBTENER_TIPOS_RESOLUCIONES_PRC = "es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.obtenerTiposResolucionesProcedimiento";
	public static final String MSV_BO_OBTENER_INPUT_DESDE_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.obtenerTipoInputParaResolucion";
	public static final String MSV_BO_OBTENER_TIPO_INPUT_DESDE_NODO = "es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.obtenerInputParaNodo";
	public static final String MSV_BO_OBTENER_RESOLUCION_DESDE_INPUT = "es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.obtenerTipoResolucionDeInput";
	
	/*El nodo que añadimos manualmente si el prc no tiene tareas activas*/
	public static final String MSV_NODO_SIN_TAREAS = "NONEXISTENT";
	
	/**
	 * A partir de un procedimiento devuelve la lista de tipos de resoluciones posibles
	 * 
	 * @return Set<MSVTipoResolucionDto>
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_PRC)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesProcedimiento(Long idProcedimiento);

	/**
	 * Devuelve todas las resoluciones posibles de los procedimientos sin tareas activas
	 * 
	 * @return Set<MSVTipoResolucionDto>
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_SIN_TAREA)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesSinTarea(Long idProcedimiento);

	/**
	 * A partir de una tarea devuelve la lista de tipos de resoluciones posibles
	 * 
	 * @return Set<MSVTipoResolucionDto>
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesTareas(Long idTarea);
	
	/**
	 * A partir de una tarea devuelve la lista de tipos de resoluciones posibles
	 * 
	 * @return Set<MSVTipoResolucionDto>
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA_COUNT)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesTareasCount(Long idTarea);

	/**
	 * A partir de un tipo de resolucion y un mapa de datos (además de un tipo de procedimiento), 
	 * devuelve el tipo adecuado según la configuración de input
	 * 
	 * @return String
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_INPUT_DESDE_RESOLUCION)
	public String obtenerTipoInputParaResolucion(Long idProc, String codigoTipoProc,
			String codigoTipoResolucion, Map<String, String> valores);

	/**
	 * A partir de un código de nodo y una relacion entre tipo proc e input comprueba que el nodo pertenezca a los nodos
	 * incluidos y no en los excluidos
	 * 
	 * @return boolean
	 */
	// TODO: posiblemente haya que moverlo a RecoveryBPMframework
	@BusinessOperationDefinition(MSV_BO_OBTENER_TIPO_INPUT_DESDE_NODO)
	public boolean obtenerInputParaNodo(String codigoNodo,
			RecoveryBPMfwkTipoProcInput tipoProcInput);

	/**
	 * A partir de un tipo de input y tipo de procedimiento se obtiene el tipo de resolución
	 * @param codigoTipoProc
	 * @param codigoTipoResolucion
	 * @param valores
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_RESOLUCION_DESDE_INPUT)
	public String obtenerTipoResolucionDeInput(String codigoTipoProc,
			String codigoTipoInput);

}
