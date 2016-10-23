package es.pfsgroup.plugin.rem.api;

import java.util.HashMap;

import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;

public interface ReservaApi {

	public static final String COBRO_RESERVA = "1";
	public static final String COBRO_VENTA = "3";
	public static final String DEVOLUCION_RESERVA = "5";
	
	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
	 * @param ReservaDto con los parametros de entrada
	 * @param jsonFields estructura de parámetros para validar campos en caso de venir informados
	 * @return HashMap<String, String>  
	 */
	public HashMap<String, String> validateReservaPostRequestData(ReservaDto reservaDto, Object jsonFields) throws Exception;
	
	

}
