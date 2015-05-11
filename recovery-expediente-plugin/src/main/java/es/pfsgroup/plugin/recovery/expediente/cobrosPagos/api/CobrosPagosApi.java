package es.pfsgroup.plugin.recovery.expediente.cobrosPagos.api;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dto.DtoCobrosPagos;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.model.RecobroPagoContrato;

/**
 * Mánager de la entidad LINVinculaciones.
 * 
 * @author Oscar
 * 
 */
public interface CobrosPagosApi {

	public static final String BO_GET_LISTADO_COBROS_PAGOS = "es.pfsgroup.recovery.expediente.api.getListadoCobrosPagos";
	public static final String BO_GET_DETALLE_COBRO_PAGO = "es.pfsgroup.recovery.expediente.api.getDetalleCobroPago";

	@BusinessOperationDefinition(BO_GET_LISTADO_COBROS_PAGOS)
	Page getListadoCobrosPagos(DtoCobrosPagos dto);

	@BusinessOperationDefinition(BO_GET_DETALLE_COBRO_PAGO)
	RecobroPagoContrato getDetalleCobroPago(DtoCobrosPagos dto);

}