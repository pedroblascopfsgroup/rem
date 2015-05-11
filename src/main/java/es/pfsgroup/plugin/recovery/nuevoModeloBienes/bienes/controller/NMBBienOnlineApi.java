package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.controller;

import java.util.Map;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.NMBconfigTabsTipoBien;

public interface NMBBienOnlineApi {

	public static final String BO_CONFIGTABS_GET_TAGS_TIPOS_BIEN = "NMBconfigTabs.getTabsTiposBien";
	
	/**
	 * Recupera el listado tabas para tipos de bien
	 *  
	 * @return
	 */
	@BusinessOperationDefinition(BO_CONFIGTABS_GET_TAGS_TIPOS_BIEN)
	public Map<String, NMBconfigTabsTipoBien> getMapaTabsTipoBien();
	
}
