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
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
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

	/**
	 * Método genérico para enviar una petición REST a Salesforce.
	 * 
	 * @param authtoken
	 *            Token que se usará para verificarnos en Salesforce. Si es
	 *            null se entiende que 
	 * @param endpoint
	 *            Endpoint al que nos vamos a conectar.
	 * @param paramsList
	 *            Colección de Map de parámetros (campos) a enviar en la
	 *            petición.
	 * 
	 * @return
	 * @throws ErrorServicioWebcom
	 */
	public JSONObject send(String authtoken, SalesforceEndpoint endpoint, String jsonString)
			throws NumberFormatException, HttpClientException, RestConfigurationException {
		
		if (httpClient == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el httpClient.");
		}
		
		if (endpoint == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el endpoint.");
		}
		
		RestLlamada registro = new RestLlamada();
		registro.setMetodo(endpoint.getHttpMethod());
		Map<String, String> headers = new HashMap<String, String>();
		
		String serviceUrl = null;
		if (authtoken != null) {
			headers.put("Authorization", authtoken);
			serviceUrl = endpoint.getFullUrl();
		}
		else {
			serviceUrl = endpoint.getFullTokenUrl();
		}
		
		registro.setEndpoint(serviceUrl);
		registro.setRequest(jsonString);

		JSONObject result = processRequest(serviceUrl, endpoint, headers, jsonString, endpoint.getTimeout(), endpoint.getCharset());
		
		try {
			registro.setResponse(result.toString());
			llamadaDao.guardaRegistro(registro);
		} catch (Exception e) {
			logger.error("Error al trazar la llamada al CDM", e);
		}

		return result;
	}
	
	public JSONObject processRequest(String serviceUrl, SalesforceEndpoint endpoint, Map<String, String> headers, String jsonString,int responseTimeOut, String charSet) throws HttpClientException {

		if (StringUtils.isBlank(serviceUrl)) {
			throw new HttpClientFacadeInternalError("Service URL is required");
		}

		String sendMethod = endpoint.getHttpMethod();
		responseTimeOut = responseTimeOut * 1000;
		logger.trace("Estableciendo coneixón con httpClient [url=" + serviceUrl + ", method=" + sendMethod
				+ ", timeout=" + responseTimeOut + ", charset=" + charSet + "]");

		
		Integer responseCode = null;
		try {

			System.out.println("Generando SSLContext tipo TLSv1.2, aqui puede fallar facil , C103 , CON JAVA 6 AQUI FALLA SIEMPRE");
			SSLContext sslContext = SSLContext.getInstance("TLSv1.2");
			System.out.println("Inicializando SSLContext");
			sslContext.init(null, new TrustManager[] { new CustomInsecureX509TrustManager() }, new java.security.SecureRandom());
			
			System.out.println("Creando URL");
			URL url = new URL(serviceUrl);
			System.out.println("URL creada, abriendo conexion (aqui puede fallar facil)");
			
			HttpsURLConnection httpsURLConnection = (HttpsURLConnection) url.openConnection();
			
			httpsURLConnection.setHostnameVerifier(new SFHostnameVerifier());
			httpsURLConnection.setSSLSocketFactory(sslContext.getSocketFactory());
			httpsURLConnection.setRequestMethod("POST");
			httpsURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpsURLConnection.setConnectTimeout(responseTimeOut);
			
			System.out.println("Metiendo headers");
			Iterator<Map.Entry<String, String>> it = headers.entrySet().iterator();
			System.out.println("While in");
			while (it.hasNext()) {
				Map.Entry<String, String> headerPair = it.next();
				System.out.println("H : " +headerPair.getKey() + " V : " + headerPair.getValue());
				httpsURLConnection.setRequestProperty(headerPair.getKey(),headerPair.getValue());
			}
			
			System.out.println("While out");
			
			
			// Body
			if (jsonString != null && !jsonString.isEmpty()) {
				
				httpsURLConnection.setRequestProperty("Content-Type", "application/json");
				
				System.out.println("Metiendo cuerpo");
				System.out.println(jsonString);
				System.out.println("Output a true");
				httpsURLConnection.setDoOutput(true);
				OutputStream body = httpsURLConnection.getOutputStream();
				body.write(jsonString.getBytes("UTF-8"));
				body.flush();
				body.close();
			}
			
			System.out.println("INICIANDO COMUNICACION, aqui puede fallar facil , C103");
			InputStream inputStream = httpsURLConnection.getInputStream();
			System.out.println("COMUNICACION REALIZADA, C103");
			String respBody = getResponseBody(inputStream);
			System.out.println(respBody);
			logger.trace("-- RESPONSE BODY --");
			logger.trace(respBody);
			
			httpsURLConnection.disconnect();
			
			if (respBody.trim().isEmpty()){
				throw new HttpClientException("Empty response", responseCode);
			}
			
			return JSONObject.fromObject(respBody);
		} catch (Exception e) {
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
		} catch (IOException e) {
			throw new HttpClientFacadeInternalError("Error Reading Response Stream", e);
		} finally {
			try {
				dumpOut.flush();
				dumpOut.close();
				if (in != null)
					in.close();
			} catch (IOException e) {
				logger.warn("Error Closing Response Stream", e);
			}
		}
		return StringEscapeUtils.unescapeHtml(stringOut.toString());

	}
	
	/*TODO: 
	 * - Descargar certificado del endpoint al que vamos a atacar en formato .crt y añadirlo en una keytool al apache.
	 * 		Esto no hará falta, para las pruebas de desarrollo desactivaremos esta validacion (falta saber como hacerlo). Y
	 * 		luego al terminar el item se pondrá en la descripcion para que lo tengan en cuenta los de explotacion.
	 * - Comprobar si nos podemos conectar al endpoint del documento (con la informacion que nos contesten los de haya) DONE
	 * - Cambiar el nombre y requerimiento de los campos del formulario de alta de visitas DONE
	 * - Crear script que añada las 3 columnas acordadas en la tabla de visitas DONE
	 * - Hacer la validacion para activar o desactivar el boton de alta de visita (esta a medias HREOS-5306)
	 * - Verificar que despues de añadir la firma ssh al tomcat se obtiene el token correctamente
	 * - Hacer la segunda llamada que dara de alta la visita
	 * - Adaptar el WS de alta de visitas para que si llega con los nuevos parametros ademas de crear la visita
	 * se actualice su registro respecto
	 * */
	
}
