package es.pfsgroup.plugin.recovery.comites.asunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.comites.asunto.dao.CMTAsuntoDao;

@Repository("CMTAsuntoDao")
public class CMTAsuntoDaoImpl extends AbstractEntityDao<Asunto, Long> implements CMTAsuntoDao{

	@Override
	public List<Asunto> getAsuntosComite(Long id) {
		HQLBuilder hb = new HQLBuilder("from Asunto asu");
		hb.appendWhere("asu.auditoria.borrado=0");
		hb.appendWhere("asu.estadoAsunto!='06'");
		HQLBuilder.addFiltroIgualQue(hb, "asu.comite.id", id);
		return HibernateQueryUtils.list(this, hb);
	}

}
