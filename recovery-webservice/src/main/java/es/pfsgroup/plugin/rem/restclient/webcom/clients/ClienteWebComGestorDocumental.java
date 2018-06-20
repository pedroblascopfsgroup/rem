package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import net.sf.json.JSONObject;

@Component
public class ClienteWebComGestorDocumental {

	private static final String DEFAULT_TIMEOUT = "10000";

	@Autowired
	private HttpClientFacade httpClient;

	@Resource
	private Properties appProperties;

	@Autowired
	private RestLlamadaDao llamadaDao;

	@Autowired
	private LogTrustWebService trustMe;

	private final Log logger = LogFactory.getLog(getClass());

	public JSONObject send(String authtoken, String endpoint, String jsonString)
			throws NumberFormatException, HttpClientException, RestConfigurationException {
		RestLlamada registro = new RestLlamada();
		registro.setMetodo("POST");
		Map<String, String> headers = new HashMap<String, String>();
		if (authtoken != null) {
			headers.put("AUTHTOKEN", authtoken);
		}

		String serviceUrl = null;
		String urlBase = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.BASE_URL_GESTOR_DOCUMENTAL, null);

		if (urlBase == null) {
			throw new RestConfigurationException("La url base del gestor documental no esta definida");
		} else {
			serviceUrl = urlBase.concat("/").concat(endpoint);
		}
		registro.setEndpoint(serviceUrl);
		registro.setRequest(jsonString);

		String timeout = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.TIMEOUT_CONEXION, DEFAULT_TIMEOUT);

		JSONObject result = httpClient.processRequest(serviceUrl, "POST", headers, jsonString,
				Integer.parseInt(timeout), "UTF-8");

		try {
			registro.setResponse(result.toString());
			llamadaDao.guardaRegistro(registro);
			trustMe.registrarLlamadaServicioWeb(registro);
		} catch (Exception e) {
			logger.error("Error al trazar la llamada al CDM", e);
		}

		return result;
	}
}
