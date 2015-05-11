package es.capgemini.pfs.batch.recobro.facturacion.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroCobroPreprocesado;

/**
 * Intefaz de m�tdodos para el acceso a BBDD de los cobros Pagos de Recobro 
 * @author javier
 *
 */
public interface RecobroCobrosPagosDao extends AbstractDao<RecobroCobroPreprocesado, Long>{

	/**
	 * Obtiene los cobros pagos de recobro entre las fechas determinadas
	 * @param fechaDesde, fecha de inicio de periodo, inclusive
	 * @param fechaHasta, fecha fin de periodo, inclusive
	 * @return lista con los Cobros pagos de recobro durante las fechas indicadas
	 */
	public List<RecobroCobroPreprocesado> obtenerCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta);
}
