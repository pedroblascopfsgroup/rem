package es.pfsgroup.plugin.recovery.itinerarios.ddTipoReclamacion;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReclamacion.dao.ITIDDTipoReclamacionDao;

@Service("ITIDDTipoReclamacionManager")
public class ITIDDTipoReclamacionManager {
	
	@Autowired
	ITIDDTipoReclamacionDao tipoReclamacionDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRC_MGR_GETTIPOSRECLAMACION)
	public List<DDTipoReclamacion> getTiposReclamacion(){
		return tipoReclamacionDao.getList();
	}
	

}
