package es.pfsgroup.plugin.rem.microservicios;

import java.io.IOException;
import java.io.Serializable;
import java.util.Map;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import net.sf.json.JSONObject;

@Component
public class ClienteMicroservicioGenerico {

	@Autowired
	private HttpClientFacade httpClient;

	ObjectMapper mapper = new ObjectMapper();
	
	public String send(Serializable parametros, String metodo, String serviceUrl)
			throws JsonGenerationException, JsonMappingException, IOException, HttpClientException {
		return this.send(parametros, metodo, serviceUrl, null);
	}

	public String send(Serializable parametros, String metodo, String serviceUrl, Map<String, String> headers)
			throws JsonGenerationException, JsonMappingException, IOException, HttpClientException {

		String jsonString = mapper.writeValueAsString(parametros);
		JSONObject result = httpClient.processRequest(serviceUrl, metodo, headers, jsonString, 1000, "UTF-8");

		return result.toString();

	}

}
