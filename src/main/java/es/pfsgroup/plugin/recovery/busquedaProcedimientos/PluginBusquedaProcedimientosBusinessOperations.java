package es.pfsgroup.plugin.recovery.busquedaProcedimientos;

public class PluginBusquedaProcedimientosBusinessOperations {

	public static final String BPR_MGR_LISTATIPOSPROC = "plugin.busquedaProcedimientos.procedimiento.listaTiposProcedimiento";
	
	/**
	 * @return devuelve la lista de los posibles tipos de actuación
	 */
	public static final String BPR_MGR_LISTATIPOSACTUAC ="plugin.busquedaProcedimientos.procedimiento.listaTiposActuacion";
	
	public static final String BPR_MGR_LISTAESTADOSPROC ="plugin.busquedaProcedimientos.procedimiento.listaEstadosProcedimiento";

	public static final String BPR_MGR_TIPOSRECLAMACION ="plugin.busquedaProcedimientos.procedimiento.listaTiposReclamacion";

	/**
	 * @param codigo de la plaza
	 * @return devuelve una lista con todos los juzgados que pertenecen a la plaza cuyo código se le pasa como parámetro
	 */
	public static final String BPR_MGR_BUSCAJUZGADOSPLAZA ="plugin.busquedaProcedimientos.procedimiento.buscaJuzgadosPlaza";

	/**
	 * @param dto de búsqueda de procedimientos
	 * @return devuelve una lista paginada con todos los procedimientos que cumplen los criterios de búsqueda
	 */
	public static final String BPR_MGR_BUSCAPROCEDIMIENTOS="plugin.busquedaProcedimientos.procedimiento.buscaProcedimientos";
	
	public static final String BPR_MGR_BUSCAPROCEDIMIENTOS_EXCEL="plugin.busquedaProcedimientos.procedimiento.buscaProcedimientosParaExcel";
	
	/**
	 * @return devuelve una lista de todos los despachos dados de alta en la base de datos
	 */
	public static final String BPR_MGR_LISTADESPACHOS="plugin.busquedaProcedimientos.procedimiento.listaDespachos";
	
	/**
	 * @return devuelve la lista de GestoresDespacho que están en la tabla USD_USUARIOS_DESPACHOS
	 *  y que además son gestores externos y el tipo de despacho es despacho externo
	 */
	public static final String BPR_MGR_LISTAGESTORESEXTERNOS ="plugin.busquedaProcedimientos.procedimiento.listaGestoresExternos";
	
	/**
	 * @return devuelve la lista de GestoresDespacho que están en la tabla USD_USUARIOS_DESPACHOS y además son supervisores
	 */
	public static final String BPR_MGR_LISTASUPERVISORESASUNTO= "plugin.busquedaProcedimientos.procedimiento.listaSupervisoresAsunto";

	/**
	 * @return devuelve la lista de GestoresDespacho que están en la tabla USD_USUARIOS_DESPACHO
	 * y que además son gestores externos y el tipo de despacho es un despacho procurador
	 */
	public static final String BPR_MGR_LISTAPROCURADORES="plugin.busquedaProcedimientos.procedimiento.listaProcuradores";
	
	/**
	 * @return devuelve la lista de los comités existentes
	 */
	public static final String BPR_MGR_LISTACOMITES="plugin.busquedaProcedimientos.procedimiento.listaComites";

	/**
	 * @return devuelve la lista de los posibles estados de un asunto
	 */
	public static final String BPR_MGR_LISTAESTADOSASUNTO="plugin.busquedaProcedimientos.procedimiento.listaDDEstadoAsunto";

	/**
	 * @param id del tipo de actuación seleccionado
	 * @return devuelve una lista de tipos de procedimientos englobados en el tipo de actuación
	 * cuyo id se le pasa como parámetro
	 */
	public static final String BPR_MGR_LISTAPROCPORACTUACION="plugin.busquedaProcedimientos.procedimiento.listaProcedimientoPorTipoActuacion";
	
	/**
	 * @return devuelve una lista con todos los despachos de tipo Externo que hay en la base de datos
	 */
	public static final String BPR_MGR_LISTA_DESP_EXTERNOS="plugin.busquedaProcedimientos.procedimiento.listaDespachosExternos";

	public static final String BPR_MGR_BUTTONS_LEFT = "plugin.busquedaProcedimientos.web.buttons.left";
	
	public static final String BPR_MGR_BUTTONS_RIGHT = "plugin.busquedaProcedimientos.web.buttons.right";
}
