package es.pfsgroup.plugin.rem.visita.dao.impl;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Repository("VisitaDao")
public class VisitaDaoImpl extends AbstractEntityDao<Visita, Long> implements VisitaDao{
	
	
	@Override
	public Long getNextNumVisitaRem() {
		String sql = "SELECT S_VIS_NUM_VISITA.NEXTVAL FROM DUAL";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
	
	
	@Override
	public List<Visita> getListaVisitas(VisitaDto visitaDto) {
		
		HQLBuilder hql = new HQLBuilder("from Visita");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idVisitaWebcom", visitaDto.getIdVisitaWebcom());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "numVisitaRem", visitaDto.getIdVisitaRem());
		
		
		return HibernateQueryUtils.list(this, hql);
	}

}
