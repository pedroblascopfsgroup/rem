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

	private static final class MS_PROPERTIES {
		private static String BASE_URL = "192.168.31.221:3141";
		private static String DEFAULT_TIMEOUT = "10000";
	}
	
	@Autowired
	private HttpClientFacade httpClient;
	
	@Resource
	private Properties appProperties;

	ObjectMapper mapper = new ObjectMapper();
	
	//Urls para el microservicio dependiendo del entorno. devon.properties ? 
	private void iniciarServicio() throws WIException {
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
		this.URL = !Checks.esNulo(appProperties.getProperty("rest.client.microservicio.url.base"))
				? appProperties.getProperty("rest.client.uvem.url.base") : "";
		this.ALIAS = !Checks.esNulo(appProperties.getProperty("rest.client.uvem.alias.integrador"))
				? appProperties.getProperty("rest.client.uvem.alias.integrador") : "";

		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);
	}
	
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
