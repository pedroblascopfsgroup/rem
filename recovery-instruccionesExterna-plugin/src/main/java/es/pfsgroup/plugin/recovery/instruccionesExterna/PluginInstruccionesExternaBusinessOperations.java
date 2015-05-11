package es.pfsgroup.plugin.recovery.instruccionesExterna;

public class PluginInstruccionesExternaBusinessOperations {
	
	/**
	 * @return lista de todos los objetos de tipo TipoProcedimiento que hay de alta enla base de datos
	 */
	public static final String INS_MGR_LISTAPROCEDIMIENTOS="plugin.instruccionesExterna.plazoTareaExternaPlaza.listaTiposProcedimiento";
	
	/**
	 * @return lista de todas los objetos de tipo TareaProcedimiento que existen en la base de datos
	 */
	public static final String INS_MGR_LISTATAREAS="plugin.instruccionesExterna.plazoTareaExternaPlaza.listaTiposTarea";
	
	/**
	 * @param dto de búsqueda de instrucciones por tareas y procedimientos
	 * @return devuelve una lista de objetos 
	 */
	public static final String INS_MGR_BUSCAINSTRUCCIONES="plugin.instruccionesExterna.plazoTareaExternaPlaza.buscaInstrucciones";

	/**
	 * @param id del objeto INSInstruccionesTareasExterna
	 * @return devuelve el objeto INSInstruccionesTareasExterna cuyo id coincide con el valor que se le 
	 *  pasa como parámetro
	 */
	public static final String INS_MGR_GETINSTRUCCIONES="plugin.instruccionesExterna.instruccionesTareaExterna.getInstrucciones";

	public static final String INS_MGR_SAVEINSTRUCCIONES="plugin.instruccionesExterna.instruccionesTareasExterna.save";
	
	public static final String INS_MGR_PUNTO_ENGANCHE_BUTTONS_LEFT="plugin.instruccionesExterna.web.buttons.left";
	
	public static final String INS_MGR_PUNTO_ENGANCHE_BUTTONS_RIGHT="plugin.instruccionesExterna.web.buttons.right";
}
