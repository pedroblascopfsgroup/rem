package es.pfsgroup.plugin.recovery.procuradores.categorias.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;


/**
 * Dao de la clase {@link Categorizacion}
 * 
 * @author manuel
 *
 */
public interface CategorizacionDao extends AbstractDao<Categorizacion, Long>{

	/**
	 * Obtiene un listado de {@link Categorizacion}. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link Categorizacion} paginada.
	 */
	public Page getListaCategorizaciones(CategorizacionDto dto);
	
	
	/**
	 * Obtiene una {@link Categorizacion}.
	 * @param id Identificador de la categorizacion.
	 * @return lista de {@link Categorizacion}.
	 */
	public Categorizacion getCategorizacion(Long id);
}
