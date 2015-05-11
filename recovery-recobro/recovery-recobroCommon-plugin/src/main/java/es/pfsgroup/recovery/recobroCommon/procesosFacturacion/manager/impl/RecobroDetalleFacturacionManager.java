package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroDetalleFacturacionDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroDetalleFacturacionApi;

@Service
public class RecobroDetalleFacturacionManager implements RecobroDetalleFacturacionApi {

	@Autowired
	RecobroDetalleFacturacionDao recobroDetalleFacturacionDao;
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void vaciarRecobroDetalleFacturacion() {
		recobroDetalleFacturacionDao.vaciarRecobroDetalleFacturacion();
	}

}
