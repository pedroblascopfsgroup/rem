package es.pfsgroup.plugin.rem.api;

import java.util.HashMap;

import es.pfsgroup.plugin.rem.rest.dto.ReintegroDto;

public interface ReintegroApi {

	

	
	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
	 * @param ReintegroDto con los parametros de entrada
	 * @param jsonFields estructura de parámetros para validar campos en caso de venir informados
	 * @return HashMap<String, String>  
	 */
	public HashMap<String, String> validateReintegroPostRequestData(ReintegroDto reintegroDto, Object jsonFields) throws Exception;
	
	

}
