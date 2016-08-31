package es.pfsgroup.plugin.rem.rest.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.rest.model.Broker;

public interface BrokerDao extends AbstractDao<Broker, Long>{
	
	/**
	 * Obtiene un operador dada su ip
	 * @param ip
	 * @return
	 */
	public Broker getBrokerByIp(String ip);
	
	

}
