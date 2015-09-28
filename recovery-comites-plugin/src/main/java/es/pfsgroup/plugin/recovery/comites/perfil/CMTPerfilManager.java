package es.pfsgroup.plugin.recovery.comites.perfil;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.plugin.recovery.comites.PluginComitesBusinessOperations;
import es.pfsgroup.plugin.recovery.comites.perfil.dao.CMTPerfilDao;

@Service("CMTPerfilManager")
public class CMTPerfilManager {
	
	@Autowired
	CMTPerfilDao perfilDao;
	
	@BusinessOperation(PluginComitesBusinessOperations.PEF_MGR_GETLIST)
	public List<Perfil> listaPerfiles(){
		return perfilDao.getList();
	}

}
