package es.pfsgroup.plugin.rem.microservicios;

import java.util.HashMap;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import net.sf.json.JSONObject;

@Component
public class ClienteMicroservicioGenerico {

	private static final class MS_PROPERTIES {
		private static String BASE_URL = "192.168.31.221:3141";
		private static String DEFAULT_TIMEOUT = "10000";
	}
	
	
	@Autowired
	private HttpClientFacade httpClient;

	ObjectMapper mapper = new ObjectMapper();
	
	
	public JSONObject send(String method, String endpoint, String jsonString)
			throws NumberFormatException, HttpClientException, RestConfigurationException {
	
		Map<String, String> headers = new HashMap<String, String>();
		headers = null;
		
		String serviceUrl = null;
		String urlBase = MS_PROPERTIES.BASE_URL;

		if (urlBase == null) {
			throw new RestConfigurationException("La url base del microservicio no esta definida");
		} else {
			serviceUrl = urlBase.concat("/").concat(endpoint);
		}
		
		String timeout = MS_PROPERTIES.DEFAULT_TIMEOUT;
		
		JSONObject result = httpClient.processRequest(serviceUrl, method, headers, jsonString,
				Integer.parseInt(timeout), "UTF-8");
		
		return result;
	}	

}
