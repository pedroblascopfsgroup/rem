package es.capgemini.pfs.batch.recobro.facturacion.dao.impl;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.batch.recobro.facturacion.dao.RecobroCobrosPagosDao;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroCobroPreprocesado;

@Repository("RecobroCobrosPagosDao")
public class RecobroCobrosPagosDaoImpl extends AbstractEntityDao<RecobroCobroPreprocesado, Long>  implements RecobroCobrosPagosDao {

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroCobroPreprocesado> obtenerCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta) {
		HQLBuilder hb = new HQLBuilder("from RecobroCobroPreprocesado");
		HQLBuilder.addFiltroBetweenSiNotNull(hb, "fecha", fechaDesde, fechaHasta);
		
		return (List<RecobroCobroPreprocesado>)HibernateQueryUtils.list(this, hb);
	}
}
