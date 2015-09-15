package es.pfsgroup.plugin.recovery.itinerarios.ddTipoActuacion;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoActuacion.dao.ITIDDTipoActuacionDao;

@Service("ITIDDTipoActuacionManager")
public class ITIDDTipoActuacionManager {
	
	@Autowired
	ITIDDTipoActuacionDao tipoActuacionDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TPA_MGR_GETTIPOSACTUACION)
	public List<DDTipoActuacion> getTiposActuacion(){
		return tipoActuacionDao.getList();
	}

}
