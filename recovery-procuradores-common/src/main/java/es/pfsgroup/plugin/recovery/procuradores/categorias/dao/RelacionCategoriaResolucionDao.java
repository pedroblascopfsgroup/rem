package es.pfsgroup.plugin.recovery.procuradores.categorias.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriaResolucionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategoriaResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;


/**
 * Dao de la clase {@link RelacionCategoriaResolucion}
 * 
 * @author anahuac
 *
 */
public interface RelacionCategoriaResolucionDao extends AbstractDao<RelacionCategoriaResolucion, Long>{
	
	
	/**
	 * Obtiene  una {@link RelacionCategoriaResolucion}
	 * @param relCategoria {@link RelacionCategorias} a borrar 
	 * @return 
	 */
	public RelacionCategoriaResolucion getRelacionCategoriaResolucion(RelacionCategoriaResolucionDto dto);
	
	
	
	
}

