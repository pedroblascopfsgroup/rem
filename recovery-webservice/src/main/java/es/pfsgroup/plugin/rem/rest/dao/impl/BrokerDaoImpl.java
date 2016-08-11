package es.pfsgroup.plugin.rem.rest.dao.impl;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.model.Broker;

@Repository("BrokerDaoImpl")
public class BrokerDaoImpl  extends AbstractEntityDao<Broker, Long> implements BrokerDao{

	@Transactional
	@Override
	public Broker getBrokerByIp(String ip) {
		HQLBuilder hb = new HQLBuilder("from Broker");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "ip", ip);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

}
