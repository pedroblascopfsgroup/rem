package es.pfsgroup.plugin.recovery.procuradores.categorias.api;

import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;

public interface CategorizacionApi {

	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_CATEGORIZACIONES = "plugin.procuradores.categorizaciones.getListaCategorizaciones";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_CATEGORIZACION_POR_ID = "plugin.procuradores.categorizaciones.getCategorizacionPorId";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_SET_CATEGORIZACION = "plugin.procuradores.categorizaciones.setCategorizacion";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_COMPROBAR_BORRADO_CATEGORIZACION = "plugin.procuradores.categorizaciones.comprobarBorradoCategorizacion";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_BORRAR_CATEGORIZACION = "plugin.procuradores.categorizaciones.borrarCategorizacion";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_DESPACHOS_EXTERNOS = "plugin.procuradores.categorizaciones.getListaDespachosExternos";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_DESPACHO_EXTERNO = "plugin.procuradores.categorizaciones.getDespachoExterno";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_PAGE_DESPACHO_EXTERNO ="plugin.procuradores.categorizaciones.getPageDespachoExterno";

	/**
	 * Obtiene un listado de categorizaciones. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link Categorizacion} paginada.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_CATEGORIZACIONES)
	public Page getListaCategorizaciones(CategorizacionDto dto);

	
	/**
	 * Obtiene una categorizacion por id.
	 * @param id identificador de la categorizacion.
	 * @return Categorizacion
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_CATEGORIZACION_POR_ID)
	public Categorizacion getCategorizacion(Long Id);

	
	
	
	/**
	 * Guarda los datos de la categorizacion
	 * @param dto
	 * @return
	 * @throws BusinessOperationException 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_SET_CATEGORIZACION)
	public Categorizacion setCategorizacion(CategorizacionDto dto) throws BusinessOperationException;
	
	
	
	
	/**
	 * Indica si se puede borrar una {@link Categorizacion}
	 * @param idcategorizacion identificador de la categorizacion
	 * @return true si se puede borrar, false si no.
	 * @throws BusinessOperationException 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_COMPROBAR_BORRADO_CATEGORIZACION)
	public Boolean comprobarBorradoCategorizacion(Long idcategorizacion) throws BusinessOperationException;
	
	
	
	/**
	 * Borra una {@link Categorizacion} y todas sus {@link Categorias} y {@link RelacionCategorias} por idcategorizacion.
	 * @param id identificador de la categorizacion
	 * @return
	 * @throws BusinessOperationException 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_BORRAR_CATEGORIZACION)
	public void borrarCategorizacion(Long id) throws BusinessOperationException;
	
	
	
	
	/**
	 * Obtiene un listado de {@link DespachoExterno}
	 * @param dto dto con los datos de filtado.
	 * @return lista de {@link DespachoExterno}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_DESPACHOS_EXTERNOS)
	public List<DespachoExterno>  getListaDespachosExternos(CategorizacionDto dto);
	
	
	
	/**
	 * Obtiene un {@link DespachoExterno} por id
	 * @param idDespExt identificador del despacho externo.
	 * @return {@link DespachoExterno}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_DESPACHO_EXTERNO)
	public DespachoExterno getDespachoExterno(Long idDespExt);

	
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_PAGE_DESPACHO_EXTERNO)
	public Page getPageDespachoExterno(CategorizacionDto dto, String nombre);

}
