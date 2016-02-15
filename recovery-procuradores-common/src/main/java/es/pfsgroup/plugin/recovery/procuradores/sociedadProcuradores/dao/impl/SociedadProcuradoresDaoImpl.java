package es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dao.SociedadProcuradoresDao;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dto.SociedadProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model.SociedadProcuradores;

@Repository("SociedadProcuradoresDao")
public class SociedadProcuradoresDaoImpl extends AbstractEntityDao<SociedadProcuradores, Long> implements SociedadProcuradoresDao{

	

	@Override
	public Page getListaSociedadesProcuradores(SociedadProcuradoresDto dto){
		
		HQLBuilder hb = new HQLBuilder(" from SociedadProcuradores socprocs ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "socprocs.nombre", dto.getNombre(), true);
		hb.orderBy("socprocs.nombre", HQLBuilder.ORDER_ASC);

		return HibernateQueryUtils.page(this, hb, dto);
		
	}
	
	public SociedadProcuradores getSociedadProcuradores(Long idSociedad){
		
		HQLBuilder hb = new HQLBuilder(" from SociedadProcuradores socprocs ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "socprocs.id", idSociedad, true);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}


	
}
