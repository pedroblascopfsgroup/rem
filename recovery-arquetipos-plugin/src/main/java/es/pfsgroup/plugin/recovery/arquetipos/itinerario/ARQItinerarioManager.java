package es.pfsgroup.plugin.recovery.arquetipos.itinerario;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.itinerario.dao.ARQItinerarioDao;

@Service("ARQItinerarioManager")
public class ARQItinerarioManager {
	
	@Autowired
	private ARQItinerarioDao itinerarioDao;
	
	@BusinessOperation(PluginArquetiposBusinessOperations.ITINERARIO_MGR_LISTA_ITINERARIOS)
	public List<Itinerario> listaItinerario(){
		return itinerarioDao.getList();
	}
	
	@BusinessOperation(PluginArquetiposBusinessOperations.ITINERARIO_MGR_GET)
	public Itinerario getItinerario(Long id){
		return itinerarioDao.get(id);
	}

}
