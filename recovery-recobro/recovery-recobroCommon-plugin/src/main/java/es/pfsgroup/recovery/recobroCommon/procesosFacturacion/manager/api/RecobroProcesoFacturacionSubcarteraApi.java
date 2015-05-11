package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonProcesosFacturacionConstants;

public interface RecobroProcesoFacturacionSubcarteraApi {
	
	/**
	 * Crea un nuevo proceso de facturación subcartera
	 * @param procesoFacturacionSubCartera
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACIONSUBCARTERA_SAVE)
	void saveProcesoFacturacion(RecobroProcesoFacturacionSubcartera pfs);
	
	/**
	 * Actuliza la tabla PFS_PROC_FAC_SUBCARTERA
	 * con el sumatorio de la facturación en
	 * TMP_RECOBRO_DETALLE_FACTURA
	 */
	void updateSumProcesoFacturacionSubcartera(long procesoFacturacionId);	
}
