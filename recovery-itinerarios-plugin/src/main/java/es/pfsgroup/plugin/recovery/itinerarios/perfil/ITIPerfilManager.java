package es.pfsgroup.plugin.recovery.itinerarios.perfil;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.perfil.dao.ITIPerfilDao;

@Service("ITIPerfilManager")
public class ITIPerfilManager {
	
	@Autowired
	ITIPerfilDao perfilDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.PEF_MGR_GETPERFILES)
	public List<Perfil> getPerfiles(){
		return perfilDao.getList();
	}

}
