package es.pfsgroup.plugin.recovery.procuradores.categorias.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;


/**
 * Dao de la clase {@link RelacionCategorias}
 * 
 * @author anahuac
 *
 */
public interface RelacionCategoriasDao extends AbstractDao<RelacionCategorias, Long>{

	/**
	 * Obtiene un listado de {@link RelacionCategorias}.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link RelacionCategorias}.
	 */
	public List<RelacionCategorias> getListaRelacionCategorias(RelacionCategoriasDto dto);

	
	
	/**
	 * Borra una {@link RelacionCategorias}
	 * @param relCategoria {@link RelacionCategorias} a borrar 
	 * @return 
	 */
	public void deleteRelacionCategorias(RelacionCategorias relCategoria);
	
	
	
}

