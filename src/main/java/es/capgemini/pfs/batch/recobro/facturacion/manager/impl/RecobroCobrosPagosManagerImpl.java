package es.capgemini.pfs.batch.recobro.facturacion.manager.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.batch.recobro.facturacion.dao.RecobroCobrosPagosDao;
import es.capgemini.pfs.batch.recobro.facturacion.manager.RecobroCobrosPagosManager;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroCobroPreprocesado;

@Service
public class RecobroCobrosPagosManagerImpl implements RecobroCobrosPagosManager {

	@Autowired
	private RecobroCobrosPagosDao recobroCobrosPagosDAO;
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroCobroPreprocesado> obtenerCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta) throws Throwable {
		return recobroCobrosPagosDAO.obtenerCobrosPagosPorFechas(fechaDesde, fechaHasta);
	}

}
