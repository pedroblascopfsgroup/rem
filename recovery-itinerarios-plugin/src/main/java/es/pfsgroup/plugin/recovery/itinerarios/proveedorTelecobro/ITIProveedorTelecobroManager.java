package es.pfsgroup.plugin.recovery.itinerarios.proveedorTelecobro;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;


import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.telecobro.model.ProveedorTelecobro;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.proveedorTelecobro.dao.ITIProveedorTelecobroDao;


@Service("ITIProveedorTelecobroManager")
public class ITIProveedorTelecobroManager {
	
	@Autowired
	ITIProveedorTelecobroDao proveedorTelecobroDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.PTL_MGR_LISTAPROVEEDORES)
	public List<ProveedorTelecobro> listaProveedores(){
		return proveedorTelecobroDao.getList();
	}

}
