package es.pfsgroup.plugin.recovery.arquetipos.ddSiNo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.ddSiNo.dao.ARQDDSiNoDao;


@Service("ARQDDSiNoManager")
public class ARQDDSiNoManager {
	
	@Autowired
	private ARQDDSiNoDao ddSiNoDao;
	
	@BusinessOperation(PluginArquetiposBusinessOperations.DDSINO_MGR_LISTA)
	public List<DDSiNo> getList(){
		return ddSiNoDao.getList();
	}

}
