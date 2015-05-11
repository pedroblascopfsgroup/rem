package es.pfsgroup.plugin.recovery.mejoras.expediente;

import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

public interface MEJExpedienteApi {
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsConsultaExpedienteRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_LEFT)
	List<DynamicElement> getButtonsConsultaExpedienteLeft();

	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_RIGHT_FAST)
	List<DynamicElement> getButtonsConsultaExpedienteRightFast();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_LEFT_FAST)
	List<DynamicElement> getButtonsConsultaExpedienteLeftFast();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_EXPEDIENTE_TABS_FAST)
    List<DynamicElement> getTabsExpedienteFast();
	
    /**
     * Excluye el contrato del expediente.
     * @param dto DtoExclusionContratoExpediente
     */
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE)
	public void excluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto);
	
    /**
     * Incluye el contrato del expediente.
     * @param dto DtoExclusionContratoExpediente
     */
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE)
	public void incluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto);
    
}