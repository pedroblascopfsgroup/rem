package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;

public interface RecobroProcesoFacturacionSubcarteraDao extends AbstractDao<RecobroProcesoFacturacionSubcartera, Long> {

	/**
	 * Actuliza la tabla PFS_PROC_FAC_SUBCARTERA
	 * con el sumatorio de la facturación en
	 * TMP_RECOBRO_DETALLE_FACTURA
	 */
	void updateSumProcesoFacturacionSubcartera(long procesoFacturacionId);
}
