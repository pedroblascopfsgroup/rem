package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQArquetipo;

public interface ARQArqArquetipoDao extends AbstractDao<ARQArquetipo, Long> {
	
	public void deleteByMraId(Long mraId);

}
