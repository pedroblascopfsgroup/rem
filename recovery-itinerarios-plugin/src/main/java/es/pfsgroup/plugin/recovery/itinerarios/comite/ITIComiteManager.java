package es.pfsgroup.plugin.recovery.itinerarios.comite;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comite.model.Comite;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.comite.dao.ITIComiteDao;
import es.pfsgroup.plugin.recovery.itinerarios.itinerario.dao.ITIItinerarioDao;

@Service("ITIComiteManager")
public class ITIComiteManager {
	
	@Autowired
	ITIComiteDao comiteDao;
	
	@Autowired
	ITIItinerarioDao itinerarioDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.COM_MGR_GETCOMITES)
	public List<Comite> getComites(){
		return comiteDao.getList();
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.COM_MGR_LISTACOMITI)
	public List<Comite> getComitesItinerario(Long idItinerario){
		List<Comite> listaComites = comiteDao.getList();
		List<Comite> comitesItinerario = new ArrayList<Comite>();
		for (Comite c : listaComites){
			if (c.getItinerarios().contains(itinerarioDao.get(idItinerario))){
				comitesItinerario.add(c);
			}
		}
		return comitesItinerario;
		
		/*return comiteDao.findByItinerario(idItinerario);*/
	}

}
