package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.io.FileWriter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacadeInternalError;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Este cliente de Webcom sirve para invocar a todos los endpoints. El endpoint
 * al que queremos invocar se pasa como parámetro al método de invocación.
 * 
 * @author bruno
 *
 */
@Component
public class ClienteWebcomGenerico {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private HttpClientFacade httpClient;

	@Resource
	private Properties appProperties;

	public ClienteWebcomGenerico() {
		super();
	}

	/**
	 * Método genérico para enviar una petición REST a Webcom.
	 * 
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
	@SuppressWarnings("unchecked")
	public Map<String, Object> send(WebcomEndpoint endpoint, ParamsList paramsList, RestLlamada registroLlamada)
			throws ErrorServicioWebcom {

		if (httpClient == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el httpClient.");
		}

		if (endpoint == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el endpoint.");
		}

		if (paramsList == null) {
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}

		if (registroLlamada == null) {
			throw new IllegalArgumentException("'registroLlamada' no puede ser NULL");
		}

		logger.trace("Llamada a servicio " + endpoint.toString() + " con parámetros " + paramsList);
		JSONObject response = null;
		JSONObject requestBody = null;
		try {
			// Llamada al servicio
			requestBody = WebcomRequestUtils.createRequestJson(paramsList);
			String jsonString = requestBody.toString();
			logger.debug("[DETECCIÓN CAMBIOS] Request:");
			logger.debug(jsonString);
			registroLlamada.logTiempPrepararJson();
			registroLlamada.setToken(requestBody.getString(WebcomRequestUtils.JSON_PROPERTY_ID));
			registroLlamada.setRequest(jsonString);

			String apiKey = endpoint.getApiKey();
			String publicAddress = getPublicAddress();
			registroLlamada.setApiKey(apiKey);
			registroLlamada.setIp(publicAddress);

			String signature = WebcomSignatureUtils.computeSignatue(apiKey, publicAddress, jsonString);
			registroLlamada.setSignature(signature);
			logger.trace("Cálculo del signature [apiKey=" + apiKey + ", ip=" + publicAddress + "] => " + signature);

			Map<String, String> headers = new HashMap<String, String>();
			headers.put("signature", signature);
			String httpMethod = endpoint.getHttpMethod();
			registroLlamada.setMetodo(httpMethod);
			String endpointUrl = endpoint.getEndpointUrl();
			registroLlamada.setEndpoint(endpointUrl);

			debugJsonFile(jsonString);

			response = httpClient.processRequest(endpointUrl, httpMethod, headers, jsonString,
					(endpoint.getTimeout() * 1000), endpoint.getCharset());
			registroLlamada.setResponse(response.toString());

			logger.debug("[DETECCIÓN CAMBIOS] Response:");
			if(response != null && !response.isEmpty()){
				logger.debug(response.toString());
			}
			
			// Gestión de errores si respuesta OK
			if (response.containsKey("error")) {
				String error = response.getString("error");
				registroLlamada.setErrorDesc(error);
				if ((error != null) && (!"".equals(error)) && (!"null".equals(error))) {
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
		} finally {
			if (response != null && response.containsKey("data")) {
				trazarObjetosRechazados(registroLlamada, response.getJSONArray("data"), false);
			} else {
				if ((response == null || (response.containsKey("error") && response.getBoolean("error")))
						&& requestBody.containsKey("data")) {
					trazarObjetosRechazados(registroLlamada, requestBody.getJSONArray("data"), true);
				}
			}
			registroLlamada.logTiempoPeticionRest();

		}
	}

	private void trazarObjetosRechazados(RestLlamada registroLlamada, JSONArray data, boolean trazandoRequest) {
		ArrayList<JSONObject> datosErroneos = new ArrayList<JSONObject>();
		for (int i = 0; i < data.size(); i++) {
			JSONObject jsonObject = data.getJSONObject(i);
			if (trazandoRequest || (jsonObject.containsKey("success") && !jsonObject.getBoolean("success"))) {
				datosErroneos.add(jsonObject);
			}

		}
		registroLlamada.setDatosErroneos(datosErroneos);
	}

	private void debugJsonFile(String jsonString) {
		String DEBUG_FILE = !Checks.esNulo(appProperties.getProperty("rest.client.json.debug.file"))
				? appProperties.getProperty("rest.client.json.debug.file") : "true";

		if (DEBUG_FILE.equals("true")) {
			FileWriter fileW = null;

			try {
				fileW = new FileWriter(System.getProperty("user.dir").concat(System.getProperty("file.separator"))
						.concat("call.json"));
				fileW.write(jsonString);
			} catch (Exception e) {
				logger.error("error al guardar el fichero JSON");
			} finally {
				try {
					if (fileW != null) {
						fileW.close();
					}
				} catch (IOException e) {
					logger.error("error al cerrar el fichero");
				}
			}
		}
	}

	private String getPublicAddress() {
		return WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.SERVER_PUBLIC_ADDRESS, "UNKNOWN_ADDRESS");
	}

}