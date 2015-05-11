package es.pfsgroup.plugin.recovery.mejoras.contrato;

import java.util.List;

import es.capgemini.devon.web.DynamicElement;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

public interface MEJVistaContratoApi {
	
	public static final String MEJ_MGR_CONTRATO_BUTTONS_RIGHT = "plugin.mejoras.web.contratos.consulta.buttons.right";
	public static final String MEJ_MGR_CONTRATO_BUTTONS_LEFT = "plugin.mejoras.web.contratos.consulta.buttons.left";
	
	
	/**
     * Manejadores dinámicos de botones y tabs para contratos 
     */
	@BusinessOperationDefinition(MEJ_MGR_CONTRATO_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsContratoRight();
	
	@BusinessOperationDefinition(MEJ_MGR_CONTRATO_BUTTONS_LEFT)
	List<DynamicElement> getButtonsContratoLeft();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_CONTRATO_BUTTONS_RIGHT_FAST)
	List<DynamicElement> getButtonsContratoRightFast();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_CONTRATO_BUTTONS_LEFT_FAST)
	List<DynamicElement> getButtonsContratoLeftFast();	
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_CONTRATO_TABS_FAST)
	List<DynamicElement> getTabsFast();	

}
