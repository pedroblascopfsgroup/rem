package es.pfsgroup.plugin.rem.restclient.httpclient;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpVersion;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import net.sf.json.JSONObject;

@Component
public class HttpClientFacade {

	private final Log logger = LogFactory.getLog(getClass());

	@Resource
	private Properties appProperties;

	public JSONObject processRequest(String serviceUrl, String sendMethod, Map<String, String> headers,
			String jsonString, int responseTimeOut, String charSet) throws HttpClientException {

		if (StringUtils.isBlank(serviceUrl)) {
			throw new HttpClientFacadeInternalError("Service URL is required");
		}

		if (jsonString == null) {
			throw new HttpClientFacadeInternalError("JSON request is required");
		}

		responseTimeOut = responseTimeOut * 1000;
		trace("Estableciendo coneixón con httpClient [url=" + serviceUrl + ", method=" + sendMethod + ", timeout="
				+ responseTimeOut + ", charset=" + charSet + "]");

		// Essentially return a new HttpClient(), but can be pulled from Spring
		// context
		HttpMethod method = null;
		try {
			HttpClient httpclient = new HttpClient();

			method = getHttpMethodFromString(sendMethod, jsonString, charSet);
			trace("Método de conexión: " + method.toString());

			if (headers != null && (!headers.isEmpty())) {
				for (Entry<String, String> e : headers.entrySet()) {
					trace("Se añade Header [" + e.getKey() + " : " + e.getValue() + "]");
					method.addRequestHeader(e.getKey(), e.getValue());
				}
			}
			method.addRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml, application/json");
			// Below
			method.setPath(serviceUrl);
			trace("http.protocol.version : " + HttpVersion.HTTP_1_1);
			httpclient.getParams().setParameter("http.protocol.version", HttpVersion.HTTP_1_1);

			trace("http.socket.timeout : " + responseTimeOut);
			httpclient.getParams().setParameter("http.socket.timeout", responseTimeOut);

			trace("http.protocol.content-charset : " + charSet);
			httpclient.getParams().setParameter("http.protocol.content-charset", charSet);

			trace(jsonString);

			return execute(httpclient, method);
		} catch (HttpClientException e) {
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + "]";
			throw new HttpClientException(errorMsg, e.getResponseCode(), e);
		} catch (Exception e) {
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + "]";
			throw new HttpClientException(errorMsg, 0, e);
		} finally {
			if (method != null) {
				method.releaseConnection();
			}
		}
	}

	private JSONObject execute(HttpClient httpclient, HttpMethod method)
			throws HttpException, IOException, HttpClientException {
		trace("Lanzando peticion : httpClient.executeMethod()");
		Boolean webcomSimulado = Boolean.valueOf(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.WEBCOM_SIMULADO, "true"));
		Integer responseCode = 0;
		if (!webcomSimulado) {
			responseCode = httpclient.executeMethod(method);
		}
		if (responseCode >= 300) {
			logger.error(
					"Se ha recibido un código de respuesta HTTP inesperado. Esto suele ser indicativo de un error en el servidor al procesar la respuesta [errorCode = "
							+ responseCode + "]");
			throw new HttpClientException("Código de error inespeado", responseCode, null);
		}

		trace("Petición finalizada. Response Code : " + responseCode);

		String respBody = getResponseBody(method);// See details Below
		trace("-- RESPONSE BODY --");
		trace(respBody);

		if (respBody.trim().isEmpty()) {
			throw new HttpClientException("Empty response", responseCode);
		}

		return JSONObject.fromObject(respBody);
	}

	private void setRequestParams(PostMethod method, String jsonString, String charSet)
			throws UnsupportedEncodingException {
		trace("Configurando PostMethod");
		String contentType = "application/json";
		trace(" - Content Type : " + contentType);
		trace(" - charset : " + charSet);

		StringRequestEntity entity = new StringRequestEntity(jsonString, contentType, charSet);
		method.setRequestEntity(entity);

	}

	private HttpMethod getHttpMethodFromString(String methodString, String jsonString, String charSet)
			throws UnsupportedEncodingException {
		if (StringUtils.isNotBlank(methodString)) {
			int method = HttpClientMethods.valueOf(methodString);

			switch (method) {// Add other methods as needed PUT, DELETE etc.
			case HttpClientMethods.GET:
				return new GetMethod();
			case HttpClientMethods.POST:
				PostMethod postMethod = new PostMethod();
				setRequestParams(postMethod, jsonString, charSet);
				return postMethod;
			default:
				return new GetMethod();
			}
		}
		return new GetMethod();
	}

	private String getResponseBody(HttpMethod method) {
		String resultado = "";
		Boolean webcomSimulado = Boolean.valueOf(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.WEBCOM_SIMULADO, "true"));

		if (method != null && method.hasBeenUsed() && !webcomSimulado) {
			BufferedReader in = null;
			StringWriter stringOut = new StringWriter();
			BufferedWriter dumpOut = new BufferedWriter(stringOut, 8192);
			try {
				in = new BufferedReader(new InputStreamReader(method.getResponseBodyAsStream()));
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
			resultado = StringEscapeUtils.unescapeHtml(stringOut.toString());
		} else {
			resultado ="{\"id\":0,\"succes\":\"true\"}";
		}
		return resultado;
	}

	private void trace(String mensaje) {
		Boolean webcomSimulado = Boolean.valueOf(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.WEBCOM_SIMULADO, "true"));
		if (webcomSimulado) {
			logger.error(mensaje);
		} else {
			logger.trace(mensaje);
		}

	}

}
