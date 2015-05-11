package es.pfsgroup.plugin.recovery.masivo.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.recovery.geninformes.factories.GENBusinessObjectApi;

/**
 * Interfaz que deben cumplir los generadores de n�meros de lote
 * @author manuel
 *
 */
@SuppressWarnings("deprecation")
public interface MSVLoteGeneratorApi extends GENBusinessObjectApi{
	
	public static final String PLUGIN_MASIVO_OBTENER_NUMERO_LOTE = "es.pfsgroup.plugin.recovery.masivo.api.MSVLoteGeneratorApi.getNumeroLote";
	
	/**
	 * Devuelve un n�mero de lote. 
	 * 
	 * @param exc Objeto Hoja Excel
	 * @param tipoOperacion Objeto tipo de operaci�n.
	 * @return String n�mero de lote con el formato CCC-YYYYMMDD-HHMISS
	 * donde CCC es el c�digo de operaci�n, 
	 * y YYYMMDD-HHMISS es la fecha.
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_OBTENER_NUMERO_LOTE)	
	public String getNumeroLote(MSVHojaExcel exc, MSVDDOperacionMasiva tipoOperacion);
	
}
