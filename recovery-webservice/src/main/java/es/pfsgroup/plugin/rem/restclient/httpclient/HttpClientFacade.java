package es.pfsgroup.plugin.rem.restclient.httpclient;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpVersion;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import net.sf.json.JSONObject;

@Component
public class HttpClientFacade {

	private final Log logger = LogFactory.getLog(getClass());

	@Resource
	private Properties appProperties;

	@Autowired
	private RestApi restApi;

	public JSONObject processRequest(String serviceUrl, String sendMethod, Map<String, String> headers,
			String jsonString, int responseTimeOut, String charSet) throws HttpClientException {

		if (StringUtils.isBlank(serviceUrl)) {
			throw new HttpClientFacadeInternalError("Service URL is required");
		}

		if (jsonString == null) {
			throw new HttpClientFacadeInternalError("JSON request is required");
		}

		responseTimeOut = responseTimeOut * 1000;
		restApi.trace("Estableciendo coneixón con httpClient [url=" + serviceUrl + ", method=" + sendMethod
				+ ", timeout=" + responseTimeOut + ", charset=" + charSet + "]");

		// Essentially return a new HttpClient(), but can be pulled from Spring
		// context
		HttpMethod method = null;
		try {
			HttpClient httpclient = new HttpClient();

			method = getHttpMethodFromString(sendMethod, jsonString, charSet);
			restApi.trace("Método de conexión: " + method.toString());

			if (headers != null && (!headers.isEmpty())) {
				for (Entry<String, String> e : headers.entrySet()) {
					restApi.trace("Se añade Header [" + e.getKey() + " : " + e.getValue() + "]");
					method.addRequestHeader(e.getKey(), e.getValue());
				}
			}
			method.addRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml, application/json");
			// Below
			method.setPath(serviceUrl);
			restApi.trace("http.protocol.version : " + HttpVersion.HTTP_1_1);
			httpclient.getParams().setParameter("http.protocol.version", HttpVersion.HTTP_1_1);

			restApi.trace("http.socket.timeout : " + responseTimeOut);
			httpclient.getParams().setParameter("http.socket.timeout", responseTimeOut);

			restApi.trace("http.protocol.content-charset : " + charSet);
			httpclient.getParams().setParameter("http.protocol.content-charset", charSet);

			restApi.trace(jsonString);
			
			JSONObject jsonRespuesta = execute(httpclient, method);
			logger.error("Respuesta: " + jsonRespuesta.toString());
			logger.error("Respuesta httpClient [url=" + serviceUrl + ", method=" + sendMethod
					+ ", timeout=" + responseTimeOut + ", charset=" + charSet + "]");

			return execute(httpclient, method);
		} catch (HttpClientException e) {
			logger.error("error ws", e);
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + "]";
			throw new HttpClientException(errorMsg, e.getResponseCode(), e);
		} catch (Exception e) {
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + "]";
			// Se añade este logger para poder ver en consola los errores que desvuelve el
			// webservice
			logger.error("error ws", e);
			throw new HttpClientException(errorMsg, 0, e);
		} finally {
			if (method != null) {
				method.releaseConnection();
			}
		}
	}

	private JSONObject execute(HttpClient httpclient, HttpMethod method) throws IOException, HttpClientException {
		restApi.trace("Lanzando peticion : httpClient.executeMethod()");
		Boolean webcomSimulado = Boolean.valueOf(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.WEBCOM_SIMULADO, "false"));
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

		restApi.trace("Petición finalizada. Response Code : " + responseCode);

		String respBody = getResponseBody(method);// See details Below
		restApi.trace("-- RESPONSE BODY --");
		restApi.trace(respBody);

		if (respBody.trim().isEmpty()) {
			throw new HttpClientException("Empty response", responseCode);
		}

		return JSONObject.fromObject(respBody);
	}

	private void setRequestParams(PostMethod method, String jsonString, String charSet)
			throws UnsupportedEncodingException {
		restApi.trace("Configurando PostMethod");
		String contentType = "application/json";
		restApi.trace(" - Content Type : " + contentType);
		restApi.trace(" - charset : " + charSet);

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
				WebcomRESTDevonProperties.WEBCOM_SIMULADO, "false"));

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
			//resultado = "{\"id\":0,\"succes\":\"true\"}";
			resultado = "{\"id\":\"157734784728321256810068\",\"data\":[{\"idOfertaRem\":\"62875808\",\"idOfertaWebcom\":\"210472\",\"origenLeadProveedor\":\"02\",\"idOfertaSalesforce\":\"a0V4I00000G9AZlUAN\",\"idClienteRem\":\"2212163\",\"idClienteSalesforce\":\"0014I00001tbOLQQA2\",\"idProveedorPrescriptorRemOrigenLead\":\"10\",\"fechaOrigenLead\":\"2017-08-13T20:02:12\",\"codTipoProveedorOrigenCliente\":\"0609\",\"idProveedorRealizadorRemOrigenLead\":\"11\",\"success\":true}],\"error\":null}";
		}
		return resultado;
	}

}
