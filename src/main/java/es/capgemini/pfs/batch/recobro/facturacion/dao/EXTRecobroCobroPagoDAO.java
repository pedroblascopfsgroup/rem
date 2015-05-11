package es.capgemini.pfs.batch.recobro.facturacion.dao;

import java.util.Date;
import java.util.List;

import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.EXTRecobroCobroPago;
import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Interfaz de m�todos para la persistencia de cobros/pagos de recobro
 * @author Guillem
 *
 */
public interface EXTRecobroCobroPagoDAO {

	/**
	 * Obtiene los cobros/pagos para un determinado contrato e intervalo de fecha
	 * @param contrato
	 * @param fechaInical
	 * @param fechaFin
	 * @return
	 */
	public List<EXTRecobroCobroPago> obtenerCobrosPagosPorContratoIntervaloFecha(Contrato contrato, Date fechaInicial, Date fechaFin);			
	
}
