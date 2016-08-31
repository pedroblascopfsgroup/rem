package es.pfsgroup.plugin.rem.visita.dao.impl;


import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Repository("VisitaDao")
public class VisitaDaoImpl extends AbstractEntityDao<Visita, Long> implements VisitaDao{
	

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter) {
		// TODO Auto-generated method stub
		
		HQLBuilder hb = new HQLBuilder(" from Visita vis");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vis.numVisitaRem", dtoVisitasFilter.getNumVisita());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vis.activo.numActivo", dtoVisitasFilter.getNumActivo());
		
		hb.orderBy("vis.numVisitaRem", HQLBuilder.ORDER_ASC);
		
		Page pageVisitas = HibernateQueryUtils.page(this, hb, dtoVisitasFilter);
		
		List<Visita> visitas = (List<Visita>) pageVisitas.getResults();
		List<DtoVisitasFilter> visitasFiltradas= new ArrayList<DtoVisitasFilter>();
		
		for(Visita v: visitas){
			DtoVisitasFilter dtoFilter= new DtoVisitasFilter();
			
			dtoFilter.setNumActivo(v.getActivo().getNumActivo());
			dtoFilter.setNumVisita(v.getNumVisitaRem());
			dtoFilter.setNumActivoRem(v.getActivo().getNumActivoRem());
			dtoFilter.setFechaSolicitud(v.getFechaSolicitud());
			dtoFilter.setNombre(v.getCliente().getNombreCompleto());
			dtoFilter.setNumDocumento(v.getCliente().getDocumento());
			dtoFilter.setFechaVisita(v.getFechaVisita());
			
			dtoFilter.setIdActivo(v.getActivo().getId());
			
			visitasFiltradas.add(dtoFilter);
		
		}
		
		return new DtoPage(visitasFiltradas, pageVisitas.getTotalCount());
	}

	
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
