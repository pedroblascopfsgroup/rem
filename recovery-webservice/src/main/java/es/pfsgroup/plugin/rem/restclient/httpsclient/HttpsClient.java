package es.pfsgroup.plugin.rem.restclient.httpsclient;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.restclient.httpsclient.HttpsClientInternalError;
import es.pfsgroup.plugin.rem.rest.salesforce.api.impl.CustomInsecureX509TrustManager;
import es.pfsgroup.plugin.rem.restclient.httpsclient.HttpsClientException;
import es.pfsgroup.plugin.rem.restclient.salesforce.clients.SFHostnameVerifier;
import net.sf.json.JSONObject;

@Component
public class HttpsClient {

	private final Log logger = LogFactory.getLog(getClass());
	
	//Errores
	private static String ERROR_SERVICE_URL_REQUIRED = "Service URL is required.";
	private static String ERROR_JSON_REQUIRED = "JSON request is required";
	

	public JSONObject processRequest(String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString,int responseTimeOut, String charSet) 
			throws HttpsClientException {
		
	
		if (StringUtils.isBlank(serviceUrl)) {
			throw new HttpsClientInternalError(ERROR_SERVICE_URL_REQUIRED);
		}
		
		if (jsonString == null) {
			throw new HttpsClientInternalError(ERROR_JSON_REQUIRED);
		}
		
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
			
			httpsURLConnection.setRequestMethod(sendMethod);
			httpsURLConnection.setConnectTimeout(responseTimeOut);
			
			
			
			if (!Checks.esNulo(headers)){
				Iterator<Map.Entry<String, String>> it = headers.entrySet().iterator();
				
				while (it.hasNext()) {
					Map.Entry<String, String> headerPair = it.next();
					httpsURLConnection.setRequestProperty(headerPair.getKey(),headerPair.getValue());
				}
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
				throw new HttpsClientException("Empty response", responseCode);
			}
			
			return JSONObject.fromObject(respBody);
		} catch (HttpsClientException e) {
			logger.error("error ws",e);
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + "]";
			throw new HttpsClientException(errorMsg, e.getResponseCode(), e);
		} catch (Exception e) {
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + "]";
			//Se añade este logger para poder ver en consola los errores que desvuelve el webservice
			logger.error(e);
			throw new HttpsClientException(errorMsg, responseCode, e);
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
			throw new HttpsClientInternalError("Error Reading Response Stream", e);
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
