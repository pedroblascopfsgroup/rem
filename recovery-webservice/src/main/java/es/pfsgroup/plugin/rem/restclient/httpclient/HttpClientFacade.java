package es.pfsgroup.plugin.rem.restclient.httpclient;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.aopalliance.intercept.Joinpoint;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpVersion;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;

import net.sf.json.JSONObject;
import net.sf.sojo.interchange.json.JsonParser;

@Component
public class HttpClientFacade {

	public JSONObject processRequest(String serviceUrl, String sendMethod, Map<String, String> headers, JSONObject requestJson,
			int responseTimeOut, String charSet) throws HttpClientException {
		if (StringUtils.isBlank(serviceUrl)) {
			throw new HttpClientFacadeInternalError("Service URL is required");
		}
		
		if (requestJson == null){
			throw new HttpClientFacadeInternalError("JSON request is required");
		}
		
		// Essentially return a new HttpClient(), but can be pulled from Spring
		// context
		HttpMethod method = null;
		Integer responseCode = null; 
		try {
			HttpClient httpclient = new HttpClient();
			method = getHttpMethodFromString(sendMethod, requestJson, charSet);
			if (headers != null && (! headers.isEmpty())){
				for (Entry<String, String> e : headers.entrySet()){
					method.addRequestHeader(e.getKey(), e.getValue());
				}
			}
			// Below
			method.setPath(serviceUrl);
			httpclient.getParams().setParameter("http.protocol.version", HttpVersion.HTTP_1_1);
			httpclient.getParams().setParameter("http.socket.timeout", responseTimeOut);
			httpclient.getParams().setParameter("http.protocol.content-charset", charSet);

			responseCode = httpclient.executeMethod(method);
			String respBody = getResponseBody(method);// See details Below
			
			return JSONObject.fromObject(respBody);
		} catch (Exception e) {
			String errorMsg = "Error Sending REST Request [URL:" + serviceUrl + ",METHOD:" + sendMethod + ",PARAMS:"
					+ requestJson.toString() + "]";
			throw new HttpClientException(errorMsg, responseCode, e);
		} finally {
			if (method != null) {
				method.releaseConnection();
			}
		}
	}


	private void setRequestParams(PostMethod method, JSONObject params, String charSet)
			throws UnsupportedEncodingException {

		StringRequestEntity entity = new StringRequestEntity(params.toString(), "application/json", charSet);
		method.setRequestEntity(entity);

	}

	private HttpMethod getHttpMethodFromString(String methodString, JSONObject params, String charSet)
			throws UnsupportedEncodingException {
		if (StringUtils.isNotBlank(methodString)) {
			int method = HttpClientMethods.valueOf(methodString);

			switch (method) {// Add other methods as needed PUT, DELETE etc.
			case HttpClientMethods.GET:
				return new GetMethod();
			case HttpClientMethods.POST:
				PostMethod postMethod = new PostMethod();
				setRequestParams(postMethod, params, charSet);
				return postMethod;
			default:
				return new GetMethod();
			}
		}
		return new GetMethod();
	}

	private String getResponseBody(HttpMethod method) {
		// Ensure we have read entire response body by reading from buffered
		// stream
		if (method != null && method.hasBeenUsed()) {
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
					// logger.warn("Error Closing Response Stream",e);
				}
			}
			return StringEscapeUtils.unescapeHtml(stringOut.toString());
		}
		return null;
	}

}
