package es.pfsgroup.recovery.recobroCommon.persona.manager;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroExpedienteConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroPersonaConstants;

public interface CicloRecobroPersonaApi {
	
	@BusinessOperationDefinition(RecobroCommonCicloRecobroPersonaConstants.PLUGIN_RECOBRO_CICLORECOBROPER_GETPAGE_BO)
	public Page getPageCicloRecobroPersona(CicloRecobroPersonaDto dto);
}
