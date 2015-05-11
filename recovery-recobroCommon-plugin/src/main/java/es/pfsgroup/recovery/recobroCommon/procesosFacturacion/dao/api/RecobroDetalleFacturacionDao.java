package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroDetalleFacturacion;

public interface RecobroDetalleFacturacionDao extends AbstractDao<RecobroDetalleFacturacion, Long> {
	
	/**
	 * Vacia la tabla RDF_RECOBRO_DETALLE_FACTURACION
	 */
	void vaciarRecobroDetalleFacturacion();
}
