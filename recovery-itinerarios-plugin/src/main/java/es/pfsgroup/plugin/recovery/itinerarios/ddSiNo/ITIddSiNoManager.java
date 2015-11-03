package es.pfsgroup.plugin.recovery.itinerarios.ddSiNo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.ddSiNo.dao.ITIddSiNoDao;

@Service("ITIddSiNoManager")
public class ITIddSiNoManager {
	
	@Autowired
	ITIddSiNoDao ddSiNoDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.DSN_MGR_LISTA)
	public List<DDSiNo> getList(){
		return ddSiNoDao.getList();
	}

}
