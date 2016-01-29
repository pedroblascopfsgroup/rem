package es.pfsgroup.plugin.recovery.arquetipos.ddTipoSalto;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.ddTipoSalto.dao.ARQDDTipoSaltoDao;

@Service("ARQDDTipoSaltoManager")
public class ARQDDTipoSaltoManager {
	
	@Autowired
	private ARQDDTipoSaltoDao ddTipoSaltoDao;
	
	public ARQDDTipoSaltoManager(){
		
	}
	
	public ARQDDTipoSaltoManager(ARQDDTipoSaltoDao ddTipoSaltoDao){
		this.ddTipoSaltoDao = ddTipoSaltoDao;
	}
	
	@BusinessOperation(PluginArquetiposBusinessOperations.DDTSN_MGR_LISTA)
	public List<DDTipoSaltoNivel> listaTiposSalto(){
		return ddTipoSaltoDao.getList();
	}
	
	@BusinessOperation(PluginArquetiposBusinessOperations.DDTSN_MGR_GET)
	public DDTipoSaltoNivel get(Long id){
		return ddTipoSaltoDao.get(id);
	}

}
