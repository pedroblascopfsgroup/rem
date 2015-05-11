package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.NMBconfigTabs;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.NMBconfigTabsTipoBien;

@Service
public class NMBBienManagerOnline implements NMBBienOnlineApi {

	@Autowired
	private NMBconfigTabs nmbConfigTabs;

	@Override
	@BusinessOperation(BO_CONFIGTABS_GET_TAGS_TIPOS_BIEN)
	public Map<String, NMBconfigTabsTipoBien> getMapaTabsTipoBien() {
		// TODO Auto-generated method stub
		if (nmbConfigTabs==null) {
			return null;
		}
		return nmbConfigTabs.getMapaTabsTipoBien();
	}
	
}
