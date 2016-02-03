package es.pfsgroup.plugin.recovery.plazosExterna;

public class PluginPlazosExternaBusinessOperations {
	
	public static final String PTE_MGR_GETTIPOSPROC="plugin.plazosExterna.plazoTareaExternaPlaza.listaTiposProcedimiento";

	public static final String PTE_MGR_GETTAREASPROCEDIMIENTO="plugin.plazosExterna.plazoTareaExternaPlaza.listaTiposTarea";

	public static final String PTE_MGR_LISTAJUZGADOS="plugin.plazosExterna.plazoTareaExternaPlaza.listaJuzgados";

	public static final String PTE_MGR_LISTAPLAZAS="plugin.plazosExterna.plazoTareaExternaPlaza.listaPlazas";

	public static final String PTE_MGR_BUSCAPLAZOS="plugin.plazosExterna.plazoTareaExternaPlaza.buscaPlazos";
	
	/**
	 * @param id del procedimiento
	 * @return lista de todas las tareas que pertenecen a ese procedimiento
	 */
	public static final String PTE_MGR_BUSCATAREAS="plugin.plazosExterna.plazoTareaExternaPlaza.buscaTareasProcedimiento";
	
	public static final String PTE_MGR_GUARDAPLAZO="plugin.plazosExterna.plazoTareaExternaPlaza.save";
	
	public static final String PTE_MGR_BORRAPLAZO="plugin.plazosExterna.plazoTareaExternaPlaza.delete";
	
	/**
	 * @param id del objeto PTEPLAZOTAREAPLAZA
	 * @return devuelve el objeto PTEPLAZOTAREAPLAZA cuyo
	 * id coincide con el que se le pasa como parámetro
	 */
	public static final String PTE_MGR_GETPLAZO="plugin.plazosExterna.plazoTareaExternaPlaza.getPlazo";
	
	/**
	 * @param codigo de la plaza
	 * @return devuelve una lista con todos los juzgados que hay en esa plaza
	 */
	public static final String PTE_MGR_BUSCAJUZGADOSPLAZA="plugin.plazosExterna.plazoTareaExternaPlaza.buscaJuzgadosPlaza";
	
	public static final String PTE_MGR_GETPROCEDIMIENTO="plugin.comites.comite.getProcedimientoPlazo";
	
	public static final String PTE_MGR_GETPLAZAPLAZO ="plugin.comites.comite.getPlazaPlazo";
	
	/**
	 * @param dto PTEDtoQuery
	 * @return lista de juzgados que cumplen los criterios de búsqueda del dto
	 * busca juzgados que pertenezcan a una plaza y además contengan la cadena introducida
	 */
	public static final String PTE_MGR_FINDJUZGDESCPLAZA="plugin.plazosExterna.plazoTareaExternaPlaza.findJuzgadoDescPlaza";

	public static final String PTE_MGR_BUSCATFI = "plugin.plazosExterna.plazoTareaExternaPlaza.buscaTareasTfi";
	
}
