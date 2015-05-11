package es.capgemini.pfs.batch.recobro.facturacion.dao.impl;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.batch.recobro.facturacion.dao.EXTRecobroCobroPagoDAO;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.EXTRecobroCobroPago;

/**
 * Implementaci�n de la persistencia de cobros/pagos de recobro
 * @author Guillem
 *
 */
@Repository
public class EXTRecobroCobroPagoDAOImpl extends AbstractEntityDao<EXTRecobroCobroPago, Long> implements EXTRecobroCobroPagoDAO {

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<EXTRecobroCobroPago> obtenerCobrosPagosPorContratoIntervaloFecha(
			Contrato contrato, Date fechaInicial, Date fechaFin) {

		HQLBuilder hb = new HQLBuilder(" select rec from EXTRecobroCobroPago rec ");
		HQLBuilder.addFiltroIgualQue(hb, " rec.contrato.id ", contrato.getId());
		HQLBuilder.addFiltroBetweenSiNotNull(hb, " rec.fechaExtraccion ", fechaInicial, fechaFin);
		
		return (List<EXTRecobroCobroPago>)HibernateQueryUtils.list(this, hb);
		
	}

}
