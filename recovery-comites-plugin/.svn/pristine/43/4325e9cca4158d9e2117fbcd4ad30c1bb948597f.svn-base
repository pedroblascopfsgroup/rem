package es.pfsgroup.plugin.recovery.comites.itinerario;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.plugin.recovery.comites.PluginComitesBusinessOperations;
import es.pfsgroup.plugin.recovery.comites.itinerario.dao.CMTItinerarioDao;

@Service("CMTItinerarioManager")
public class CMTItinerarioManager {
	
	@Autowired
	CMTItinerarioDao itinerarioDao;
	
	@BusinessOperation(PluginComitesBusinessOperations.ITI_MGR_GETLIST)
	public List<Itinerario> getItinerarios(){
		return itinerarioDao.getList();
	}

}
