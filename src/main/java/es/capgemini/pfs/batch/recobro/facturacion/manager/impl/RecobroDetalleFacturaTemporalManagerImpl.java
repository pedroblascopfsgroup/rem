package es.capgemini.pfs.batch.recobro.facturacion.manager.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.batch.recobro.facturacion.dao.RecobroDetalleFacturaTemporalDao;
import es.capgemini.pfs.batch.recobro.facturacion.manager.RecobroDetalleFacturaTemporalManager;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionCorrectorTemporal;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionTemporal;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Implementaci�n del manager de detalles temporales de facturas
 * @author Guillem
 *
 */
@Service
public class RecobroDetalleFacturaTemporalManagerImpl implements	RecobroDetalleFacturaTemporalManager {
	
	@Autowired
	RecobroDetalleFacturaTemporalDao recobroDetalleFacturaTemporalDao;

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroSubCartera> obtenerSubcarterasExistentes() throws Throwable {
		return recobroDetalleFacturaTemporalDao.obtenerSubcarterasExistentesEnDetallesFacturaTemporalesSinCorregir();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroDetalleFacturacionTemporal> obtenerDetallesTemporalesFacturacionPorSubcartera(RecobroSubCartera recobroSubCartera) throws Throwable {
		return recobroDetalleFacturaTemporalDao.obtenerDetallesTemporalesFacturacionPorSubcartera(recobroSubCartera);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void insertarDetalleTemporalCorregidoFacturacion(RecobroDetalleFacturacionCorrectorTemporal recobroDetalleFacturacionCorrectorTemporal) throws Throwable {
		recobroDetalleFacturaTemporalDao.insertarDetalleTemporalCorregidoFacturacion(recobroDetalleFacturacionCorrectorTemporal);
	}
	
	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void vaciarDetallesFacturaTemporales() throws Throwable {
		recobroDetalleFacturaTemporalDao.deleteAll();
	}

	/**
	 * {@inheritDoc}
	 */		
	@Override
	public void vaciarDetallesFacturaTemporalesCo() throws Throwable {
		recobroDetalleFacturaTemporalDao.deleteAllCo();
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void transferirDetallesTemporalesFacturacionAProduccion() throws Throwable {
		recobroDetalleFacturaTemporalDao.transferirDetallesTemporalesCorregidosFacturacionAProduccion();
	}

	/**
	 * {@inheritDoc}
	 */		
	@Override
	public void insertarDetalleTemporalFacturacion(RecobroDetalleFacturacionTemporal recobroDetalleFacturacionTemporal) throws Throwable {
		recobroDetalleFacturaTemporalDao.insertarDetalleTemporalFactura(recobroDetalleFacturacionTemporal);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void moveDetallesTemporalesSinCorrectores(Long subCarteraId) throws Throwable {
		// TODO Auto-generated method stub
		recobroDetalleFacturaTemporalDao.moveDetallesTemporalesSinCorrectores(subCarteraId);
	}

	@Override
	public void procesaProcesoFacturacion() {
		recobroDetalleFacturaTemporalDao.procesaProcesoFacturacion();
		
	}

}
