package es.pfsgroup.plugin.recovery.mejoras.mapaGlobalOficina;

import java.util.List;

import es.capgemini.devon.web.DynamicElement;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

public interface MEJMapaGlobalOficinaApi {
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_MAPA_GLOBAL_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsMapaGlobalRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_MAPA_GLOBAL_BUTTONS_LEFT)
	List<DynamicElement> getButtonsMapaGlobalLeft();

}
