package es.pfsgroup.plugin.rem.rest.dao.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.model.Broker;

@Repository("BrokerDaoImpl")
public class BrokerDaoImpl extends AbstractEntityDao<Broker, Long> implements BrokerDao {

	private final Log logger = LogFactory.getLog(getClass());

	@Transactional
	@Override
	public Broker getBrokerByIp(String ip) {
		Broker result = null;
		try {
			ip = ip.trim();
			HQLBuilder hb = new HQLBuilder("from Broker");
			HQLBuilder.addFiltroIgualQue(hb, "ip", ip);
			// HQLBuilder.addFiltroLikeSiNotNull(hb, "ip", ip);

			result = HibernateQueryUtils.uniqueResult(this, hb);
		} catch (Exception e) {
			logger.error("Error obteniendo el broker", e);
		}
		return result;
	}

}
