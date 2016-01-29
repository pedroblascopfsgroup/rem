package es.pfsgroup.plugin.recovery.comites.zona;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.plugin.recovery.comites.PluginComitesBusinessOperations;
import es.pfsgroup.plugin.recovery.comites.zona.dao.CMTZonaDao;

@Service("CMTZonaManager")
public class CMTZonaManager {
	
	@Autowired
	CMTZonaDao zonaDao;
	
	@BusinessOperation(PluginComitesBusinessOperations.ZON_MGR_GETLIST)
	public List<DDZona> listaZonas(){
		return zonaDao.getList();
	}

}
