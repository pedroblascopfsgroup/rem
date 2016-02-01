package es.pfsgroup.plugin.recovery.itinerarios.ddTipoItinerario;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoItinerario.dao.ITIDDTipoItinerarioDao;

@Service("ITIDDTipoItinerarioManager")
public class ITIDDTipoItinerarioManager {
	
	@Autowired
	ITIDDTipoItinerarioDao tipoItinerarioDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.DDTIT_MGR_LISTA)
	public List<DDTipoItinerario> listaTiposItinerarios(){
		return tipoItinerarioDao.getList();
	}

}
