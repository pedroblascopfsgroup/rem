package es.pfsgroup.plugin.rem.service;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;

public interface PropuestaPreciosExcelService extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	

	
	/**
	 * C�digo de tipo de operaci�n para el que aplica este servicio.
	 * @return
	 */
	public String[] getCodigoCartera();
	
	/**
	 * Devuelve un mapa con los pares columna-dato para rellenar una excel
	 * @param lista
	 * @return
	 */
	public List<Map<String,String>> getExcelData(List<VBusquedaActivosPrecios> lista);
	


}
