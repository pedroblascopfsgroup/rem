package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacadeInternalError;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;
import net.sf.json.JSONObject;

public abstract class ClienteWebcomBase {

	private HttpClientFacade httpClient;
	private WebcomEndpoint endpoint;

	public ClienteWebcomBase() {
		super();
	}

	protected Map<String, Object> send(Map<String, Object> params) throws ErrorServicioWebcom {
		
		if (httpClient == null){
			throw new IllegalStateException("El bean no está correctamente inicializado. Falta el httpClient.");
		}
		
		if (endpoint == null){
			throw new IllegalStateException("El bean no está correctamente inicializado. Falta el endpoint.");
		}
		
		try {
			// Llamada al servicio
			JSONObject createRequestJson = WebcomRequestUtils.createRequestJson(params);
			String signature = WebcomSignatureUtils.computeSignatue(endpoint.getApiKey(), getPublicAddress(), createRequestJson.toString());
			Map<String, String> headers = new HashMap<String, String>();
			headers.put("signature", signature);
			JSONObject response =  httpClient.processRequest(endpoint.getEndpointUrl(), endpoint.getHttpMethod(), headers, createRequestJson,
					endpoint.getTimeout(), endpoint.getCharset());
			
			// Gestión de errores si respuesta OK
			if (response.containsKey("error")){
				String error = response.getString("error");
				if ((error != null) && (! "".equals(error))){
					throw new ErrorServicioWebcom(error);
				}
			}
			return response;
		} catch (HttpClientException e) {
			// Gestión de error en la respuesta
			throw new ErrorServicioWebcom(e);
		} catch (UnsupportedEncodingException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		} catch (NoSuchAlgorithmException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		}
	}

	protected void receive(Map<String, Object> respuesta) {
		// TODO Auto-generated method stub
		
	}

	private String getPublicAddress() {
		// TODO Auto-generated method stub
		return "1.2.3.4";
	}

	protected void setEndpoint(WebcomEndpoint endpoint) {
		this.endpoint = endpoint;
	}

	public void setHttpClient(HttpClientFacade httpClient) {
		this.httpClient = httpClient;
	}

}