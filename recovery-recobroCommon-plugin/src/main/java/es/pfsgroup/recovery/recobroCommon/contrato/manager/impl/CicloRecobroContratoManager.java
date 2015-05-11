package es.pfsgroup.recovery.recobroCommon.contrato.manager.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.recovery.recobroCommon.contrato.dao.CicloRecobroContratoDao;
import es.pfsgroup.recovery.recobroCommon.contrato.dto.CicloRecobroContratoDto;
import es.pfsgroup.recovery.recobroCommon.contrato.manager.CicloRecobroContratoApi;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroContratoConstants;

@Component
public class CicloRecobroContratoManager implements CicloRecobroContratoApi {

	@Autowired
	private CicloRecobroContratoDao cicloRecobroContratoDao;
	
	@Override
	@BusinessOperation(RecobroCommonCicloRecobroContratoConstants.PLUGIN_RECOBRO_CICLORECOBROCNT_GETPAGE_BO)
	public Page getPageCicloRecobroContrato(CicloRecobroContratoDto dto) {
		return cicloRecobroContratoDao.getPage(dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonCicloRecobroContratoConstants.PLUGIN_RECOBRO_CICLORECOBROCNT_LISTADTOCICLOSCNTEXP_BO)
	public List<CicloRecobroContrato> getCiclosRecobroPersonaExpediente(
			Long idExpediente, Long idContrato) {
		return cicloRecobroContratoDao.getCiclosRecobroContratoExpediente(idExpediente, idContrato);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonCicloRecobroContratoConstants.PLUGIN_RECOBRO_CICLORECOBROCNT_LISTACICLOCNTEXP_AGENCIA_BO)
	public List<CicloRecobroContrato> getCiclosRecobroContratoExpedienteAgencia(
			Long idExpediente, Long idContrato, Long idAgencia) {
		return cicloRecobroContratoDao.getCiclosRecobroContratoExpedienteAgencia(idExpediente, idContrato, idAgencia);
	}

}
