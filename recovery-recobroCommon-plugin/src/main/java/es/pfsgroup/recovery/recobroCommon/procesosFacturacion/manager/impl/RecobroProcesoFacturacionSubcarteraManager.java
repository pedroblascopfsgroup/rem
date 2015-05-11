package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroProcesoFacturacionSubcarteraDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroProcesoFacturacionSubcarteraApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonProcesosFacturacionConstants;

@Service
public class RecobroProcesoFacturacionSubcarteraManager implements RecobroProcesoFacturacionSubcarteraApi {
	
	@Autowired
	RecobroProcesoFacturacionSubcarteraDao recobroProcesoFacturacionSubcarteraDao;

	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACIONSUBCARTERA_SAVE)
	@Transactional(readOnly=false)
	public void saveProcesoFacturacion(RecobroProcesoFacturacionSubcartera pfs) {
		recobroProcesoFacturacionSubcarteraDao.saveOrUpdate(pfs);
	}

	@Override
	public void updateSumProcesoFacturacionSubcartera(long procesoFacturacionId) {
		recobroProcesoFacturacionSubcarteraDao.updateSumProcesoFacturacionSubcartera(procesoFacturacionId);
	}

}
