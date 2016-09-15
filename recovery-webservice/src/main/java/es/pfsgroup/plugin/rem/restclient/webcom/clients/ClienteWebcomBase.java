package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.jamonapi.utils.Logger;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacadeInternalError;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;
import net.sf.json.JSONObject;

public abstract class ClienteWebcomBase {
	
	private final Log logger = LogFactory.getLog(getClass());

	public ClienteWebcomBase() {
		super();
	}

	/**
	 * Método que implementa cada Cliente REST de WebCom para enviar una
	 * petición al servicio.
	 * 
	 * @param paramsList
	 *            Colección de Map con los parámetros (campos) que se quieren enviar.
	 * @return
	 * @throws ErrorServicioWebcom
	 *             Si la invocación al servicio falla debe gestionarse la
	 *             excepción.
	 */
	public abstract Map<String, Object> enviaPeticion(ParamsList paramsList) throws ErrorServicioWebcom;

	/**
	 * Método que implementa cada Cliente REST de WebCom para processar la
	 * respuesta del servicio.
	 * 
	 * @param respuesta
	 */
	public abstract void procesaRespuesta(Map<String, Object> respuesta);


	/**
	 * Método genérico para enviar una petición REST a Webcom.
	 * @param httpClient Fachada del Http Client que se usará para la conexión.
	 * @param endpoint Endpoint al que nos vamos a conectar. 
	 * @param paramsList Colección de Map de parámetros (campos) a enviar en la petición.
	 * @return
	 * @throws ErrorServicioWebcom 
	 */
	protected Map<String, Object> send(HttpClientFacade httpClient, WebcomEndpoint endpoint, ParamsList paramsList) throws ErrorServicioWebcom {
		
		if (httpClient == null){
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el httpClient.");
		}
		
		if (endpoint == null){
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el endpoint.");
		}
		
		if (paramsList == null){
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}
		
		logger.debug("Llamada a servicio " + endpoint.toString() + " con parámetros " + paramsList);
		
		try {
			// Llamada al servicio
			JSONObject requestBody = WebcomRequestUtils.createRequestJson(paramsList);
			logger.debug("Cuerpo de la petición: " + requestBody.toString());
			
			String signature = WebcomSignatureUtils.computeSignatue(endpoint.getApiKey(), getPublicAddress(), requestBody.toString());
			logger.debug("Cálculo del signature [apiKey=" + endpoint.getApiKey() + ", ip=" + getPublicAddress() + "] => " + signature);
			
			Map<String, String> headers = new HashMap<String, String>();
			headers.put("signature", signature);
			JSONObject response =  httpClient.processRequest(endpoint.getEndpointUrl(), endpoint.getHttpMethod(), headers, requestBody,
					endpoint.getTimeout(), endpoint.getCharset());
			
			logger.debug("Respuesta recibida " + response);
			
			// Gestión de errores si respuesta OK
			if (response.containsKey("error")){
				String error = response.getString("error");
				if ((error != null) && (! "".equals(error))){
					logger.error("Webcom ha respondido con un código de error: " + error);
					throw new ErrorServicioWebcom(error);
				}
			}
			return response;
		} catch (HttpClientException e) {
			logger.fatal("No se ha podido establecer la conexión por un error en Http Client", e);
			throw new ErrorServicioWebcom(e);
		} catch (UnsupportedEncodingException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		} catch (NoSuchAlgorithmException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		}
	}

	protected void receive(Map<String, Object> respuesta) {
		logger.warn("Método no implementeado");
		// TODO Procesar la respuesta al servicio WebCom

	}

	private String getPublicAddress() {
		// TODO Obtener la IP pública de REM
		return "1.2.3.4";
	}

}