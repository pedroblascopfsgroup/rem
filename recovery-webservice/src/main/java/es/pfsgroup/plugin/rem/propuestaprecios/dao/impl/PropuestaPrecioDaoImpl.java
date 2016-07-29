package es.pfsgroup.plugin.rem.propuestaprecios.dao.impl;

import java.math.BigDecimal;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;

@Repository("PropuestaPrecioDao")
public class PropuestaPrecioDaoImpl extends AbstractEntityDao<PropuestaPrecio, Long> implements PropuestaPrecioDao{


    @Override
	public Page getListPropuestasPrecio(DtoPropuestaFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from PropuestaPrecio prp");
	
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prp.cartera.codigo", dto.getEntidadPropietariaCodigo());
   		
		return HibernateQueryUtils.page(this, hb, dto);

	}
    
    @Override
    public Long getNextNumPropuestaPrecio(){
		String sql = "SELECT S_PRP_NUM_PROPUESTA.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
    }
	
}
