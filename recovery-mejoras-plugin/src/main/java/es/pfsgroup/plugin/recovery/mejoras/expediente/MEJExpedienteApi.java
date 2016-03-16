package es.pfsgroup.plugin.recovery.mejoras.expediente;

import java.util.List;

import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

public interface MEJExpedienteApi {
	
	public static final String OBTENER_ZONAS_JERARQUIA_BY_COD_OR_DESC = "es.pfsgroup.plugin.recovery.mejoras.expediente.MEJExpedienteApi.getZonasJerarquiaByCodDesc";
	
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
	

	@BusinessOperationDefinition(OBTENER_ZONAS_JERARQUIA_BY_COD_OR_DESC)
	public List<DDZona> getZonasJerarquiaByCodDesc(Integer idNivel, String codDesc);
	
	public void guardaSancionExpediente(Long idExpediente, String decionSancion, String observaciones);
    
}