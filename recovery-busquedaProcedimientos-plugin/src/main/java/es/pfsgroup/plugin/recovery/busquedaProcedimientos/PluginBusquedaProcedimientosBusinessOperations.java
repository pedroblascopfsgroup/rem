package es.pfsgroup.plugin.recovery.busquedaProcedimientos;

public class PluginBusquedaProcedimientosBusinessOperations {

	public static final String BPR_MGR_LISTATIPOSPROC = "plugin.busquedaProcedimientos.procedimiento.listaTiposProcedimiento";
	
	/**
	 * @return devuelve la lista de los posibles tipos de actuaci�n
	 */
	public static final String BPR_MGR_LISTATIPOSACTUAC ="plugin.busquedaProcedimientos.procedimiento.listaTiposActuacion";
	
	public static final String BPR_MGR_LISTAESTADOSPROC ="plugin.busquedaProcedimientos.procedimiento.listaEstadosProcedimiento";

	public static final String BPR_MGR_TIPOSRECLAMACION ="plugin.busquedaProcedimientos.procedimiento.listaTiposReclamacion";

	/**
	 * @param codigo de la plaza
	 * @return devuelve una lista con todos los juzgados que pertenecen a la plaza cuyo c�digo se le pasa como par�metro
	 */
	public static final String BPR_MGR_BUSCAJUZGADOSPLAZA ="plugin.busquedaProcedimientos.procedimiento.buscaJuzgadosPlaza";

	/**
	 * @param dto de b�squeda de procedimientos
	 * @return devuelve una lista paginada con todos los procedimientos que cumplen los criterios de b�squeda
	 */
	public static final String BPR_MGR_BUSCAPROCEDIMIENTOS="plugin.busquedaProcedimientos.procedimiento.buscaProcedimientos";
	
	public static final String BPR_MGR_BUSCAPROCEDIMIENTOS_EXCEL="plugin.busquedaProcedimientos.procedimiento.buscaProcedimientosParaExcel";
	
	/**
	 * @return devuelve una lista de todos los despachos dados de alta en la base de datos
	 */
	public static final String BPR_MGR_LISTADESPACHOS="plugin.busquedaProcedimientos.procedimiento.listaDespachos";
	
	/**
	 * @return devuelve la lista de GestoresDespacho que est�n en la tabla USD_USUARIOS_DESPACHOS
	 *  y que adem�s son gestores externos y el tipo de despacho es despacho externo
	 */
	public static final String BPR_MGR_LISTAGESTORESEXTERNOS ="plugin.busquedaProcedimientos.procedimiento.listaGestoresExternos";
	
	/**
	 * @return devuelve la lista de GestoresDespacho que est�n en la tabla USD_USUARIOS_DESPACHOS y adem�s son supervisores
	 */
	public static final String BPR_MGR_LISTASUPERVISORESASUNTO= "plugin.busquedaProcedimientos.procedimiento.listaSupervisoresAsunto";

	/**
	 * @return devuelve la lista de GestoresDespacho que est�n en la tabla USD_USUARIOS_DESPACHO
	 * y que adem�s son gestores externos y el tipo de despacho es un despacho procurador
	 */
	public static final String BPR_MGR_LISTAPROCURADORES="plugin.busquedaProcedimientos.procedimiento.listaProcuradores";
	
	/**
	 * @return devuelve la lista de los comit�s existentes
	 */
	public static final String BPR_MGR_LISTACOMITES="plugin.busquedaProcedimientos.procedimiento.listaComites";

	/**
	 * @return devuelve la lista de los posibles estados de un asunto
	 */
	public static final String BPR_MGR_LISTAESTADOSASUNTO="plugin.busquedaProcedimientos.procedimiento.listaDDEstadoAsunto";

	/**
	 * @param id del tipo de actuaci�n seleccionado
	 * @return devuelve una lista de tipos de procedimientos englobados en el tipo de actuaci�n
	 * cuyo id se le pasa como par�metro
	 */
	public static final String BPR_MGR_LISTAPROCPORACTUACION="plugin.busquedaProcedimientos.procedimiento.listaProcedimientoPorTipoActuacion";
	
	/**
	 * @return devuelve una lista con todos los despachos de tipo Externo que hay en la base de datos
	 */
	public static final String BPR_MGR_LISTA_DESP_EXTERNOS="plugin.busquedaProcedimientos.procedimiento.listaDespachosExternos";

	public static final String BPR_MGR_BUTTONS_LEFT = "plugin.busquedaProcedimientos.web.buttons.left";
	
	public static final String BPR_MGR_BUTTONS_RIGHT = "plugin.busquedaProcedimientos.web.buttons.right";
}
