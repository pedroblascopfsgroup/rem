package es.pfsgroup.plugin.rem.microservicios;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.gfi.webIntegrator.WIException;
import com.gfi.webIntegrator.WIService;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import net.sf.json.JSONObject;

@Component
public class ClienteMicroservicioGenerico {

	private String URL = "";
	private String DEFAULT_TIMEOUT = "10000";
	
	@Autowired
	private HttpClientFacade httpClient;
	
	@Resource
	private Properties appProperties;

	ObjectMapper mapper = new ObjectMapper();
	
	public JSONObject send(String method, String endpoint, String jsonString)
			throws NumberFormatException, HttpClientException, RestConfigurationException {
	
		Map<String, String> headers = new HashMap<String, String>();
		headers = null;
		
		String serviceUrl = null;
		String urlBase = null;
		
		//Url del microservicio dependiendo del entorno. 
		if (appProperties == null) {
			// esto solo se ejecuta desde el jar ejecutable de pruebas. No
			// podemos usar log4j
			appProperties = new Properties();
			try {
				appProperties
						.load(new FileInputStream(new File(new File(".").getCanonicalPath() + "/devon.properties")));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		urlBase = !Checks.esNulo(appProperties.getProperty("rest.client.mscomisionamiento.url.base"))
				? appProperties.getProperty("rest.client.mscomisionamiento.url.base") : "http://192.168.31.222:3141";
		
		if (Checks.esNulo(urlBase)) {
			throw new RestConfigurationException("La url base del microservicio no esta definida");
		} else if(urlBase.equals("")) {
			throw new RestConfigurationException("La url base del microservicio no esta definida");
		} else {
			serviceUrl = urlBase.concat("/").concat(endpoint);
		}
		
		String timeout = this.DEFAULT_TIMEOUT;
		
		JSONObject result = httpClient.processRequest(serviceUrl, method, headers, jsonString,
				Integer.parseInt(timeout), "UTF-8");
		
		return result;
	}	

}
