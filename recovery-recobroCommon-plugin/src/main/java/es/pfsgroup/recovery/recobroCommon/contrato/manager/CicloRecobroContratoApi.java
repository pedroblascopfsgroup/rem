package es.pfsgroup.recovery.recobroCommon.contrato.manager;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.contrato.dto.CicloRecobroContratoDto;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroContratoConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroExpedienteConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroPersonaConstants;

public interface CicloRecobroContratoApi {
	
	@BusinessOperationDefinition(RecobroCommonCicloRecobroContratoConstants.PLUGIN_RECOBRO_CICLORECOBROCNT_GETPAGE_BO)
	public Page getPageCicloRecobroContrato(CicloRecobroContratoDto dto);

	/**
	 * devuelve una lista de ciclos de recobro de un contrato para un expediente
	 * @param idExpediente
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonCicloRecobroContratoConstants.PLUGIN_RECOBRO_CICLORECOBROCNT_LISTADTOCICLOSCNTEXP_BO)
	public List<CicloRecobroContrato> getCiclosRecobroPersonaExpediente(
			Long idExpediente, Long id);

	/**
	 * Devuelve la lista de ciclos de recobro de un contrato en un expediente y para una agencia
	 * @param idExpediente
	 * @param idContrato
	 * @param idAgencia
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonCicloRecobroContratoConstants.PLUGIN_RECOBRO_CICLORECOBROCNT_LISTACICLOCNTEXP_AGENCIA_BO)
	public List<CicloRecobroContrato> getCiclosRecobroContratoExpedienteAgencia(
			Long idExpediente, Long idContrato, Long idAgencia);
}
