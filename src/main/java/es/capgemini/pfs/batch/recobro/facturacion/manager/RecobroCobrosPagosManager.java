package es.capgemini.pfs.batch.recobro.facturacion.manager;

import java.util.Date;
import java.util.List;

import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroCobroPreprocesado;

/**
 * Interfaz de m�todos del manager de Cobros Pagos de Recobro
 * @author javier
 *
 */
public interface RecobroCobrosPagosManager {

	/**
	 * Obtiene los cobros pagos de recobro entre las fechas determinadas
	 * @param fechaDesde, fecha de inicio de periodo, inclusive
	 * @param fechaHasta, fecha fin de periodo, inclusive
	 * @return lista con los Cobros pagos de recobro durante las fechas indicadas
	 * @throws Throwable
	 */
	public List<RecobroCobroPreprocesado> obtenerCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta) throws Throwable;
	

}
