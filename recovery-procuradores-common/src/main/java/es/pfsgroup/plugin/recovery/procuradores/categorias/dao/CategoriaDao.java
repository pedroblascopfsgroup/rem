package es.pfsgroup.plugin.recovery.procuradores.categorias.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriaDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;


/**
 * Dao de la clase {@link Categoria}
 * 
 * @author anahuac
 *
 */
public interface CategoriaDao extends AbstractDao<Categoria, Long>{

	/**
	 * Obtiene un listado de {@link Categoria}. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link Categoria} paginada.
	 */
	public Page getListaCategorias(CategoriaDto dto);
	
	
	/**
	 * Obtiene una {@link Categoria} por id.
	 * @param id Identificador de la {@link Categoria}.
	 * @return {@link Categoria}.
	 */
	public Categoria getCategoria(Long id);
	
	/**
	 * Obtiene el listado de todas las {@link Categoria} de una {@link Categorizacion}
	 * @param idCategorizacion id de la categorización.
	 * @return lista de {@link Categoria}.
	 */
	public List<Categoria> getListaCategoriasByCategorizacion(Long idCategorizacion);
}
