package es.pfsgroup.plugin.recovery.procuradores.categorias.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategoriaDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriaDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;


/**
 * Implementación del Dao de {@link Categoria}
 * @author anahuac
 *
 */
@Repository
public class CategoriaDaoImpl extends AbstractEntityDao<Categoria, Long> implements CategoriaDao {

	private static final String DEFAULT_SORT_COLUMN = "upper(orden)";
	private static final String DEFAULT_SORT_DIR = "ASC";
	@Resource
	private PaginationManager paginationManager;
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategoriaDao#getListaCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriasDto)
	 */
	@Override
	public Page getListaCategorias(CategoriaDto dto) {

		HQLBuilder hb = new HQLBuilder(" from Categoria cat ");		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cat.categorizacion.id", dto.getIdcategorizacion());
		this.getSortInfo(dto);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	/**
	 * traducimos a HQL los parámetros de búsqueda del dto.  
	 * @param dto
	 */
	private void getSortInfo(CategoriaDto dto) {

		if (!StringUtils.hasText(dto.getSort())){
			dto.setDir(DEFAULT_SORT_DIR);
		}
		
		if (!StringUtils.hasText(dto.getSort())){
			dto.setSort(DEFAULT_SORT_COLUMN);
		}else{
			if (dto.getSort().equals("orden")){
				dto.setSort("upper(orden)");
			}
			
		}
		
//		ORDER BY     TRANSLATE
//	     ( name
//	     , 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
//	     , '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
//	     );		

	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategoriaDao#getCategoria(java.lang.Long)
	 */
	@Override
	public Categoria getCategoria(Long id) {
		
		HQLBuilder hb = new HQLBuilder(" from Categoria cat ");		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cat.id", id);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategoriaDao#getListaCategoriasByCategorizacion(java.lang.Long)
	 */
	@Override
	public List<Categoria> getListaCategoriasByCategorizacion(Long idCategorizacion) {
		HQLBuilder hb = new HQLBuilder(" from Categoria cat ");		
		HQLBuilder.addFiltroIgualQue(hb, "cat.categorizacion.id", idCategorizacion);
		hb.orderBy("cat.orden", HQLBuilder.ORDER_ASC);		
		return HibernateQueryUtils.list(this,hb);
	}
	

}
