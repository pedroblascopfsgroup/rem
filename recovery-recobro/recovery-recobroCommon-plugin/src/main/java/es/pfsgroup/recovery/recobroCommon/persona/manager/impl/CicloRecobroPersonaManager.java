package es.pfsgroup.recovery.recobroCommon.persona.manager.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.recovery.recobroCommon.persona.dao.api.CicloRecobroPersonaDao;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;
import es.pfsgroup.recovery.recobroCommon.persona.manager.CicloRecobroPersonaApi;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroPersonaConstants;

@Component
public class CicloRecobroPersonaManager implements CicloRecobroPersonaApi {

	@Autowired
	private CicloRecobroPersonaDao cicloRecobroPersonaDao;
	
	@Override
	@BusinessOperation(RecobroCommonCicloRecobroPersonaConstants.PLUGIN_RECOBRO_CICLORECOBROPER_GETPAGE_BO)
	public Page getPageCicloRecobroPersona(CicloRecobroPersonaDto dto) {
		return cicloRecobroPersonaDao.getPage(dto);
	}

}
