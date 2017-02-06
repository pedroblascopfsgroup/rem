package es.pfsgroup.plugin.rem.api;

import java.io.File;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.service.api.GenerateJasperPdfServiceApi;

public interface GenerarFacturaVentaActivosApi extends GenerateJasperPdfServiceApi {
	
	/**
	 * Genera la Factura de Venta en un pdf, para 1 o N Activos y 1 o N Compradores.
	 * @param expediente
	 * @return
	 */
	public File getFacturaVenta(ExpedienteComercial expediente) throws Exception;

	/**
	 * Recopila en un map todos los valores a setear en la factura.
	 * @param expediente
	 * @param compradorExp
	 * @param isFacturaActivo
	 * @return
	 */
	public Map<String, Object> paramsHojaDatos(ExpedienteComercial expediente, CompradorExpediente compradorExp, Boolean isFacturaActivo)  throws Exception;
	
}
