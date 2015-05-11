package es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.model.AASAnalisisAsunto;

public interface AASAnalisisAsuntoDao extends AbstractDao<AASAnalisisAsunto, Long>{

	public AASAnalisisAsunto createNewObject();

	public AASAnalisisAsunto findByAsunto(Long id);

}
