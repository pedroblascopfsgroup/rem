package es.pfsgroup.plugin.recovery.arquetipos.estadoModelo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao.ARQDDEstadoModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.model.ARQDDEstadoModelo;


@Service("ARQDDEstadoModeloManager")
public class ARQDDEstadoModeloManager {
	
	@Autowired
	private ARQDDEstadoModeloDao estadoModeloDao;
	
	@BusinessOperation(PluginArquetiposBusinessOperations.ESTADOS_MGR_LIST)
	public List<ARQDDEstadoModelo> listaEstados(){
		return estadoModeloDao.getList();
	}
	
	@BusinessOperation(PluginArquetiposBusinessOperations.ESTADOS_MGR_GET)
	public ARQDDEstadoModelo getEstado(Long id){
		return estadoModeloDao.get(id);
	}
	
	

}
