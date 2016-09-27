package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacadeInternalError;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
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
	 *            Colección de Map con los parámetros (campos) que se quieren
	 *            enviar.
	 * @param registroLlamada
	 * @return
	 * @throws ErrorServicioWebcom
	 *             Si la invocación al servicio falla debe gestionarse la
	 *             excepción.
	 */
	public abstract Map<String, Object> enviaPeticion(ParamsList paramsList, RestLlamada registroLlamada)
			throws ErrorServicioWebcom;

	/**
	 * Método que implementa cada Cliente REST de WebCom para processar la
	 * respuesta del servicio.
	 * 
	 * @param respuesta
	 */
	public abstract void procesaRespuesta(Map<String, Object> respuesta);

	/**
	 * Este método debe implementarse en las clases hijas para poder acceder a
	 * las propiedades del sistema desde la clase padre.
	 * 
	 * @return
	 */
	protected abstract Properties getAppProperties();

	/**
	 * Método genérico para enviar una petición REST a Webcom.
	 * 
	 * @param httpClient
	 *            Fachada del Http Client que se usará para la conexión.
	 * @param endpoint
	 *            Endpoint al que nos vamos a conectar.
	 * @param paramsList
	 *            Colección de Map de parámetros (campos) a enviar en la
	 *            petición.
	 * 
	 * @param registroLlamada
	 *            Objeto en el que se irán registrando los detalles sobre la
	 *            invocación al servicio.
	 * 
	 * @return
	 * @throws ErrorServicioWebcom
	 */
	protected Map<String, Object> send(HttpClientFacade httpClient, WebcomEndpoint endpoint, ParamsList paramsList,
			RestLlamada registroLlamada) throws ErrorServicioWebcom {

		if (httpClient == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el httpClient.");
		}

		if (endpoint == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el endpoint.");
		}

		if (paramsList == null) {
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}
		
		if (registroLlamada == null){
			throw new IllegalArgumentException("'registroLlamada' no puede ser NULL");
		}

		logger.debug("Llamada a servicio " + endpoint.toString() + " con parámetros " + paramsList);

		try {
			// Llamada al servicio
			JSONObject requestBody = WebcomRequestUtils.createRequestJson(paramsList);
			registroLlamada.setToken(requestBody.getString(WebcomRequestUtils.JSON_PROPERTY_ID));
			registroLlamada.setRequest(requestBody.toString());
			logger.debug("Cuerpo de la petición: " + requestBody.toString());

			String apiKey = endpoint.getApiKey();
			String publicAddress = getPublicAddress();
			registroLlamada.setApiKey(apiKey);
			registroLlamada.setIp(publicAddress);
			
			
			String signature = WebcomSignatureUtils.computeSignatue(apiKey, publicAddress,
					requestBody.toString());
			registroLlamada.setSignature(signature);
			logger.debug("Cálculo del signature [apiKey=" + apiKey + ", ip=" + publicAddress
					+ "] => " + signature);

			Map<String, String> headers = new HashMap<String, String>();
			headers.put("signature", signature);
			String httpMethod = endpoint.getHttpMethod();
			registroLlamada.setMetodo(httpMethod);
			String endpointUrl = endpoint.getEndpointUrl();
			registroLlamada.setEndpoint(endpointUrl);
			JSONObject response = httpClient.processRequest(endpointUrl, httpMethod,
					headers, requestBody, (endpoint.getTimeout() * 1000), endpoint.getCharset());
			registroLlamada.setResponse(response.toString());

			logger.debug("Respuesta recibida " + response);

			// Gestión de errores si respuesta OK
			if (response.containsKey("error")) {
				String error = response.getString("error");
				registroLlamada.setErrorDesc(error);
				if ((error != null) && (!"".equals(error))) {
					logger.error("Webcom ha respondido con un código de error: " + error);
					throw new ErrorServicioWebcom(error);
				}
			}
			return response;
		} catch (HttpClientException e) {
			logger.fatal("No se ha podido establecer la conexión por un error en Http Client", e);
			registroLlamada.setErrorDesc("HTTP:" + e.getResponseCode());
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
		return WebcomRESTDevonProperties.extractDevonProperty(getAppProperties(),
				WebcomRESTDevonProperties.SERVER_PUBLIC_ADDRESS, "UNKNOWN_ADDRESS");
	}

}