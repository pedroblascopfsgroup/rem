package es.pfsgroup.plugin.recovery.procuradores.procurador.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.RelacionProcuradorSociedadProcuradoresDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorSociedadProcuradores;

@Repository("RelacionProcuradorSociedadProcuradoresDao")
public class RelacionProcuradorSociedadProcuradoresDaoImpl extends AbstractEntityDao<RelacionProcuradorSociedadProcuradores, Long> implements RelacionProcuradorSociedadProcuradoresDao{
	

	@Override
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDelProcurador(Long idProcurador) {
		HQLBuilder hb = new HQLBuilder(" from RelacionProcuradorSociedadProcuradores rel ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rel.procurador.id", idProcurador, true);
		//HibernateQueryUtils.uniqueResult(this, hb);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDeLaSociedad(Long idSociedad, String nombreProcurador) {
		HQLBuilder hb = new HQLBuilder(" from RelacionProcuradorSociedadProcuradores rel ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rel.sociedad.id", idSociedad, true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rel.procurador.nombre", nombreProcurador, true);
		hb.orderBy("rel.procurador.nombre", HQLBuilder.ORDER_ASC);
		//HibernateQueryUtils.uniqueResult(this, hb);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public RelacionProcuradorSociedadProcuradores getRelacionProcuradorSociedadProcuradores(Long idProcurador, Long idSociedad) {
		HQLBuilder hb = new HQLBuilder(" from RelacionProcuradorSociedadProcuradores rel ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rel.sociedad.id", idSociedad, true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rel.procurador.id", idProcurador, true);
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	
}
