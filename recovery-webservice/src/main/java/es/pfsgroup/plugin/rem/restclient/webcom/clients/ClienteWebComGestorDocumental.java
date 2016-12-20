package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import net.sf.json.JSONObject;

@Component
public class ClienteWebComGestorDocumental {

	private static final String DEFAULT_TIMEOUT = "10000";

	@Autowired
	private HttpClientFacade httpClient;

	@Resource
	private Properties appProperties;

	public JSONObject send(String authtoken, String endpoint, String jsonString) throws Exception {

		Map<String, String> headers = new HashMap<String, String>();
		if (authtoken != null) {
			headers.put("AUTHTOKEN", authtoken);
		}

		String serviceUrl = null;
		String urlBase = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.BASE_URL_GESTOR_DOCUMENTAL, "http://gdtest.gestycontrolhaya.es/rest");

		if (urlBase == null) {
			throw new Exception("La url base del gestor documental no esta definida");
		} else {
			serviceUrl = urlBase.concat("/").concat(endpoint);
		}

		String timeout = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.TIMEOUT_CONEXION, DEFAULT_TIMEOUT);

		JSONObject result = httpClient.processRequest(serviceUrl, "POST", headers, jsonString,
				Integer.parseInt(timeout), "UTF-8");

		return result;
	}
}
