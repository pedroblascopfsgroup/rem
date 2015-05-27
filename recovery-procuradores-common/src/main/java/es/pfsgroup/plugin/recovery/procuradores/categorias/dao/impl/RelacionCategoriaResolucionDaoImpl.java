package es.pfsgroup.plugin.recovery.procuradores.categorias.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.RelacionCategoriaResolucionDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriaResolucionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategoriaResolucion;

/**
 * Implementación del Dao de {@link RelacionCategoriaResolucion}
 * @author Carlos
 *
 */
@Repository("RelacionCategoriaResolucionDao")
public class RelacionCategoriaResolucionDaoImpl extends AbstractEntityDao<RelacionCategoriaResolucion, Long> implements RelacionCategoriaResolucionDao{

	@Override
	public RelacionCategoriaResolucion getRelacionCategoriaResolucion(
			RelacionCategoriaResolucionDto dto) {
		// TODO Auto-generated method stub
		HQLBuilder hb = new HQLBuilder(" from RelacionCategoriaResolucion relCatRes ");
		if(dto.getResolucion()!=null)HQLBuilder.addFiltroLikeSiNotNull(hb, "relCatRes.resolucion.id", dto.getResolucion().getId(), true);
		if(dto.getCategoria()!=null)HQLBuilder.addFiltroLikeSiNotNull(hb, "relCatRes.categoria.id", dto.getCategoria().getId(), true);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
		
	}

	

}
