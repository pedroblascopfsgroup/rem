package es.pfsgroup.plugin.recovery.procuradores.categorias.dao.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategorizacionDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;


/**
 * Implementación del Dao de {@link Categorizacion}
 * @author manuel
 *
 */
@Repository
public class CategorizacionDaoImpl extends AbstractEntityDao<Categorizacion, Long> implements CategorizacionDao {

	private static final String DEFAULT_SORT_COLUMN = "upper(nombre)";
	private static final String DEFAULT_SORT_DIR = "ASC";
	@Resource
	private PaginationManager paginationManager;
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategorizacionDao#getListaCategorizaciones(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto)
	 */
	@Override
	public Page getListaCategorizaciones(CategorizacionDto dto) {

		HQLBuilder hb = new HQLBuilder(" from Categorizacion ctg ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "ctg.nombre", dto.getNombre(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ctg.despachoExterno.id", dto.getIdDespExt());
		this.getSortInfo(dto);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	/**
	 * traducimos a HQL los parámetros de búsqueda del dto.  
	 * @param dto
	 */
	private void getSortInfo(CategorizacionDto dto) {

		if (!StringUtils.hasText(dto.getSort())){
			dto.setDir(DEFAULT_SORT_DIR);
		}
		
		if (!StringUtils.hasText(dto.getSort())){
			dto.setSort(DEFAULT_SORT_COLUMN);
		}else{
			if (dto.getSort().equals("nombre")){
				dto.setSort("upper(nombre)");
				
			}else if(dto.getSort().equals("despacho")){
				dto.setSort("upper(despachoExterno.despacho)");
			}
			
		}
		
//		ORDER BY     TRANSLATE
//	     ( name
//	     , 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
//	     , '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
//	     );		

	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategorizacionDao#getCategorizacion(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto)
	 */
	@Override
	public Categorizacion getCategorizacion(Long id) {
		
		HQLBuilder hb = new HQLBuilder(" from Categorizacion ctg ");		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ctg.id", id);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}
	

}
