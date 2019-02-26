package es.pfsgroup.plugin.rem.restclient.salesforce.clients;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.rest.salesforce.api.impl.CustomInsecureX509TrustManager;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacadeInternalError;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import net.sf.json.JSONObject;

/**
 * Este cliente de Salesforce sirve para invocar a todos los endpoints. El endpoint
 * al que queremos invocar se pasa como parámetro al método de invocación.
 * 
 * @author Isidro Sotoca
 *
 */
@Component
public class ClienteSalesforceGenerico {

	@Autowired
	private HttpClientFacade httpClient;

	@Resource
	private Properties appProperties;

	@Autowired
	private RestLlamadaDao llamadaDao;

	private final Log logger = LogFactory.getLog(getClass());
	
	//Errores
	private static String ERROR_FALTA_HTTPCLIENT = "El método no se ha invocado correctamente. Falta el httpClient.";
	private static String ERROR_FALTA_ENDPOINT = "El método no se ha invocado correctamente. Falta el endpoint.";
	private static String ERROR_SERVICE_URL_REQUIRED = "Service URL is required.";
	private static String ERROR_TRAZAR_CDM = "Error al trazar la llamada al CDM";

	/**
	 * Método genérico para enviar una petición REST a Salesforce.
	 * 
	 * @param authtoken
	 *            Token que se usará para verificarnos en Salesforce. Si es
	 *            null se entiende que la llamada que va a realizarse es para obtener el token
	 * @param endpoint
	 *            	Clase que encapsula la información necesaria para saber cómo conectarnos a
	 * 				un determinado endpoint del Saleforce de Haya
	 * @param jsonString
	 *            	String con los datos que se enviaran por POST al endpoint
	 * 
	 * @return
	 * @throws ErrorServicioWebcom
	 */
	public JSONObject send(String authtoken, SalesforceEndpoint endpoint, String jsonString) throws HttpClientException {
		
		if (httpClient == null) {
			throw new IllegalArgumentException(ERROR_FALTA_HTTPCLIENT);
		}
		
		if (endpoint == null) {
			throw new IllegalArgumentException(ERROR_FALTA_ENDPOINT);
		}
		
		RestLlamada registro = new RestLlamada();
		registro.setMetodo(endpoint.getHttpMethod());
		Map<String, String> headers = new HashMap<String, String>();
		
		String serviceUrl = null;
		if (authtoken != null) {
			headers.put("Authorization", authtoken);
			serviceUrl = endpoint.getFullUrl();
			
			/*Aqui se traza solo la base url base para no llevarnos tambien todas las variables que 
			 * se concatenan en la url, ya que de lo contrario nos saldria un error:
			 * value too large for column "REM01"."RST_LLAMADA"."RST_LLAMADA_ENDPOINT" (actual: 255, maximum: 100)*/
			registro.setEndpoint(endpoint.getBaseUrl());
		}
		else {
			serviceUrl = endpoint.getFullTokenUrl();
			registro.setEndpoint(endpoint.getTokenBaseUrl() + endpoint.getTokenEndpointUrl());
		}
		
		registro.setRequest(jsonString);
		JSONObject result = processRequest(serviceUrl, endpoint, headers, jsonString, endpoint.getTimeout(), endpoint.getCharset());
		
		try {
			registro.setResponse(result.toString());
			llamadaDao.guardaRegistro(registro);
		} 
		catch (Exception e) {
			logger.error(ERROR_TRAZAR_CDM, e);
		}

		return result;
	}
	
	public JSONObject processRequest(String serviceUrl, SalesforceEndpoint endpoint, Map<String, String> headers, String jsonString,int responseTimeOut, String charSet) throws HttpClientException {

		if (StringUtils.isBlank(serviceUrl)) {
			throw new HttpClientFacadeInternalError(ERROR_SERVICE_URL_REQUIRED);
		}

		String sendMethod = endpoint.getHttpMethod();
		responseTimeOut = responseTimeOut * 1000;
		logger.trace("Estableciendo coneixón con httpClient [url=" + serviceUrl + ", method=" + sendMethod
				+ ", timeout=" + responseTimeOut + ", charset=" + charSet + "]");

		
		Integer responseCode = null;
		try {

			/*
			 * TODO: Implementar un X509TrustManager para que compruebe y valide el certificado de la web a la que nos queramos conectar con
			 * los certificados que tenemos en nuestro cacerts. Actualmente da por buenos todos los certificados.
			 */
			SSLContext sslContext = SSLContext.getInstance("TLSv1.2");
			sslContext.init(null, new TrustManager[] { new CustomInsecureX509TrustManager() }, new java.security.SecureRandom());
			
			URL url = new URL(serviceUrl);
			
			HttpsURLConnection httpsURLConnection = (HttpsURLConnection) url.openConnection();
			
			httpsURLConnection.setHostnameVerifier(new SFHostnameVerifier());
			httpsURLConnection.setSSLSocketFactory(sslContext.getSocketFactory());
			
			httpsURLConnection.setRequestMethod(endpoint.getHttpMethod());
			httpsURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpsURLConnection.setConnectTimeout(responseTimeOut);
			
			Iterator<Map.Entry<String, String>> it = headers.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry<String, String> headerPair = it.next();
				//System.out.println("H : " +headerPair.getKey() + " V : " + headerPair.getValue());
				httpsURLConnection.setRequestProperty(headerPair.getKey(),headerPair.getValue());
			}
			
			// Body
			if (jsonString != null && !jsonString.isEmpty()) {
				
				httpsURLConnection.setRequestProperty("Content-Type", "application/json");
				
				httpsURLConnection.setDoOutput(true);
				OutputStream body = httpsURLConnection.getOutputStream();

				body.write(jsonString.getBytes(charSet));
				body.flush();
				body.close();
			}
			
			InputStream inputStream = httpsURLConnection.getInputStream();
			String respBody = getResponseBody(inputStream);
			logger.trace("-- RESPONSE BODY --");
			logger.trace(respBody);
			
			httpsURLConnection.disconnect();
			
			if (respBody.trim().isEmpty()) {
				throw new HttpClientException("Empty response", responseCode);
			}
			
			return JSONObject.fromObject(respBody);
		} 
		catch (Exception e) {
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + "]";
			//Se añade este logger para poder ver en consola los errores que desvuelve el webservice
			logger.error(e);
			throw new HttpClientException(errorMsg, responseCode, e);
		}
	}
	
	private String getResponseBody(InputStream inputStream) {

		BufferedReader in = null;
		StringWriter stringOut = new StringWriter();
		BufferedWriter dumpOut = new BufferedWriter(stringOut, 8192);
		try {
			in = new BufferedReader(new InputStreamReader(inputStream));
			String line = "";
			while ((line = in.readLine()) != null) {
				dumpOut.write(line);
				dumpOut.newLine();
			}
		} 
		catch (IOException e) {
			throw new HttpClientFacadeInternalError("Error Reading Response Stream", e);
		} 
		finally {
			try {
				dumpOut.flush();
				dumpOut.close();
				if (in != null)
					in.close();
			} 
			catch (IOException e) {
				logger.warn("Error Closing Response Stream", e);
			}
		}
		return StringEscapeUtils.unescapeHtml(stringOut.toString());

	}
	
}
