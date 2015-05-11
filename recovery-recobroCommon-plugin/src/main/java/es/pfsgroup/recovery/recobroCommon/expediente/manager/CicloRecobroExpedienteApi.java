package es.pfsgroup.recovery.recobroCommon.expediente.manager;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroContratoExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroPersonaExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.CicloRecobroExpedienteConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroExpedienteConstants;


public interface CicloRecobroExpedienteApi {
	
	@BusinessOperationDefinition(RecobroCommonCicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXP_GETPAGE_BO)
	public Page getPageCicloRecobroExpediente(CicloRecobroExpedienteDto dto);
	
	/**
	 * Devuelve una lista de ciclos de recobro para esa persona en ese expediente
	 * @param idExpediente
	 * @param idPersona
	 * @return
	 */
	@BusinessOperationDefinition(CicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSPERSONAEXP_BO)
	public List<CicloRecobroPersona> getListCiclosRecobroPersonaExpediente(Long idExpediente, Long idPersona);

	/**
	 * Devuelve una lista de dtos de ciclos de recobro para esa persona en ese expediente
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(CicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSPERSONAEXPDTO_BO)
	public List<CicloRecobroPersonaExpedienteDto> dameListaMapeadaCiclosRecobroPersonaExpediente(Long idExpediente);

	/**
	 * Devuelve una lista de dtos de ciclos de recobro para ese contrato en ese expediente
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(CicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSCNTEXPDTO_BO)
	public List<CicloRecobroContratoExpedienteDto> dameListaMapeadaCiclosRecobroContratoExpediente(Long idExpediente);
	
	/**
	 * Devuelve una lista paginada de los ciclos de recobro de un expediente.
	 * Si el usuario logado tiene permiso de ver todo devolverá todos los ciclos de recobro de ese expediente y 
	 * si no devolverá solamente los ciclos de recobro asociados a la agencia a la que pertenezca el usuario logado
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonCicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXP_BY_USU_GETPAGE_BO)
	public Page getPageCicloRecobroExpedienteTipoUsuario(CicloRecobroExpedienteDto dto);
}
