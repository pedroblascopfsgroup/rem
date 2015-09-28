package es.pfsgroup.plugin.recovery.comites.comiti.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.comites.comiti.dao.CMTComItiDao;
import es.pfsgroup.plugin.recovery.comites.comiti.model.CMTComIti;

@Repository("CMTComItiDao")
public class CMTComItiDaoImpl extends AbstractEntityDao<CMTComIti, Long> implements CMTComItiDao{

	@Override
	public CMTComIti find(Long idComite, Long idItinerario) {
		HQLBuilder hb = new HQLBuilder("from CMTComIti ci");
		hb.appendWhere("ci.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "ci.comite.id", idComite);
		HQLBuilder.addFiltroIgualQue(hb, "ci.itinerario.id", idItinerario);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public List<CMTComIti> getItinerariosComite(Long idComite) {
		HQLBuilder hb = new HQLBuilder("from CMTComIti ci");
		hb.appendWhere("ci.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "ci.comite.id", idComite);
		
		return HibernateQueryUtils.list(this, hb);
	}

}
