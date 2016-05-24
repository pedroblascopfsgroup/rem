package es.pfsgroup.plugin.recovery.procuradores.categorias.api;

import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriaDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.model.ConfiguracionDespachoExterno;
public interface CategoriaApi {

	public static final String PLUGIN_PROCURADORES_CATEGORIA_GET_LISTA_CATEGORIAS = "plugin.procuradores.categoria.getListaCategorias";
	public static final String PLUGIN_PROCURADORES_CATEGORIA_GET_LISTA_TOTAL_CATEGORIAS = "plugin.procuradores.categoria.getListaTotalCategorias";	
	public static final String PLUGIN_PROCURADORES_CATEGORIA_GET_CATEGORIA_POR_ID = "plugin.procuradores.categoria.getCategoriaPorId";
	public static final String PLUGIN_PROCURADORES_CATEGORIA_GET_CATEGORIA_BY_IDCATEGORIZACION = "plugin.procuradores.categoria.getCategoriasByIdcategorizacion";
	public static final String PLUGIN_PROCURADORES_CATEGORIA_SET_CATEGORIA = "plugin.procuradores.categoria.setCategoria";
	public static final String PLUGIN_PROCURADORES_CATEGORIA_COMPROBAR_BORRADO_CATEGORIA = "plugin.procuradores.categoria.comprobarBorradoCategoria";
	public static final String PLUGIN_PROCURADORES_CATEGORIA_BORRAR_CATEGORIA = "plugin.procuradores.categoria.borrarCategoria";	
	
	/**
	 * Obtiene un listado de {@link Categoria}. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link Categoria} paginada.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_GET_LISTA_CATEGORIAS)
	public Page getListaCategorias(CategoriaDto dto);

	/**
	 * Obtiene un listado de las {@link Categoria} del usuario logado, según la configuración del despacho {@link ConfiguracionDespachoExterno}
	 * @param idUsuario id del usuario logado
	 * @return lista de {@link Categoria}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_GET_LISTA_TOTAL_CATEGORIAS)
	public List<Categoria> getListaTotalCategorias(Long idUsuario);

	
	/**
	 * Obtiene una {@link Categoria} por idcategoria.
	 * @param id identificador de la {@link Categoria}.
	 * @return {@link Categoria}
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_GET_CATEGORIA_POR_ID)
	public Categoria getCategoria(Long Id);

	
	
	/**
	 * Obtiene lista de {@link Categoria} por idcategorizacion.
	 * @param id identificador de la {@link Categoria}.
	 * @return lista de {@link Categoria}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_GET_CATEGORIA_BY_IDCATEGORIZACION)
	public List<Categoria> getCategoriasByIdcategorizacion(Long Idcategorizacion);
	
	/**
	 * Guarda los datos de la {@link Categoria}
	 * @param dto
	 * @return
	 * @throws BusinessOperationException 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_SET_CATEGORIA)
	public Categoria setCategoria(CategoriaDto dto) throws BusinessOperationException;
	
	

	/**
	 * Indica si tiene si se puede borrar una {@link Categoria}
	 * @param id identificador de la {@link Categoria}
	 * @return true si se puede borrar la categoria, false si no.
	 * @throws BusinessOperationException 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_COMPROBAR_BORRADO_CATEGORIA)
	public Boolean comprobarBorradoCategoria(Long idcategoria) throws BusinessOperationException;
	
	
	
	/**
	 * Borra una {@link Categoria} y todas sus {@link RelacionCategorias} por idcategoria 
	 * @param id identificador de la {@link Categoria}
	 * @return
	 * @throws BusinessOperationException 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_BORRAR_CATEGORIA)
	public void borrarCategoria(Long id) throws BusinessOperationException;

	
}
