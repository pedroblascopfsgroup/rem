package es.pfsgroup.plugin.recovery.mejoras.analisisExterna;

import java.util.List;

import es.capgemini.devon.web.DynamicElement;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

public interface MEJAnalisisExternaApi {
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_ANALISIS_EXT_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsAnalisisExternaRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_ANALISIS_EXT_BUTTONS_LEFT)
	List<DynamicElement> getButtonsAnalisisExternaLeft();

}
