package es.pfsgroup.plugin.rem.restclient.services;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import net.sf.json.JSONObject;
import org.apache.commons.codec.CharEncoding;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import javax.annotation.Resource;
import javax.ws.rs.core.HttpHeaders;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Clase abstracta para la implementación de servicios que consulten a la red de servicios de REM3.
 */
abstract class Service {
	public static final String LATEST_ROUTE = "latest";
	public static final String KONG_URL_PROPERTY_KEY = "kong.service.url";
	public static final Integer RESPONSE_TIMEOUT = 10000;
	public static final Integer KONG_DEFAULT_PORT = 8000;

	@Autowired
	public HttpClientFacade httpClient;

	@Resource
	public Properties appProperties;

	/**
	 * Este método devuelve la ruta de acceso al servicio.
	 *
	 * @return Devuelve un literal con la ruta de acceso al servicio.
	 */
	public abstract String getServiceRouteName();

	/**
	 * Este método indica la versión de la ruta para atacar a los endpoints específicos de un despliegue
	 * por versión (sin usar latest).
	 *
	 * @return Devuelve un literal con la versión de la ruta del servicio.
	 */
	public String getServiceVersionRoute() {
		return LATEST_ROUTE;
	}

	/**
	 * Este método monta la URL de un servicio con el endpoint que recibe como parámetro.
	 *
	 * @param endpoint literal con la ruta final del servicio
	 * @return Devuelve un literal con la ruta URL a atacar por el cliente HTTP para obtener los recursos solicitados en la llamada.
	 */
	private String mountServiceURL(String endpoint) {
		String kongURL = this.appProperties.getProperty(Service.KONG_URL_PROPERTY_KEY, "localhost");

		return "http://" + kongURL + ":" + Service.KONG_DEFAULT_PORT + File.separator + this.getServiceRouteName() + File.separator + this.getServiceVersionRoute() + File.separator + endpoint;
	}

	/**
	 * Este método obtiene el token JWT de usuario válido para consultas hacia REM3
	 * y lo adjunta como cabecera de tipo "Authorization".
	 *
	 * @return Devuelve un mapa con la única cabecera de "Authorization".
	 */
	private Map<String, String> getAuthorizationHeader() {
		String token = (String) RequestContextHolder.getRequestAttributes().getAttribute("token_jwt", RequestAttributes.SCOPE_SESSION);

		if (null == token || token.isEmpty()) {
			throw new IllegalArgumentException("No se ha encontrado un token JWT en la sesión de usuario para realizar la petición hacia los servicios de REM3");
		}

		Map<String, String> header = new HashMap<String, String>();
		header.put(HttpHeaders.AUTHORIZATION, "Bearer " + token);

		return header;
	}

	/**
	 * Este método solicita al cliente HTTP que ejecute la acción solicitada.
	 * <br>
	 * Aunque permita adjuntar cabeceras personalizadas, también adjunta por defecto la cabecera
	 * de "Authorization" junto al token JWT.
	 *
	 * @param endpoint       ruta de ataque del servicio.
	 * @param sendMethod     tipo de método (POST, GET, PUT, PATCH, DELETE)
	 * @param headers        cabeceras de la petición (por defecto se incluye el token JWT).
	 * @param bodyJsonString cuerpo json de la petición en formato String.
	 * @return Devuelve un objeto JSONObject con la respuesta.
	 * @throws HttpClientException Esta excepción se da cuando algo ha ido mal en la petición del cliente HTTP.
	 */
	public JSONObject process(String endpoint, String sendMethod, Map<String, String> headers, String bodyJsonString) throws HttpClientException {
		headers.putAll(this.getAuthorizationHeader());
		return httpClient.processRequest(this.mountServiceURL(endpoint), sendMethod, headers, bodyJsonString, Service.RESPONSE_TIMEOUT, CharEncoding.UTF_8);
	}

	/**
	 * Este método solicita al cliente HTTP que ejecute la acción solicitada.
	 * Incluye cabecera Authorization con el token JWT automáticamente.
	 *
	 * @param endpoint       ruta de ataque del servicio.
	 * @param sendMethod     tipo de método (POST, GET, PUT, PATCH, DELETE)
	 * @param bodyJsonString cuerpo json de la petición en formato String.
	 * @return Devuelve un objeto JSONObject con la respuesta.
	 * @throws HttpClientException Esta excepción se da cuando algo ha ido mal en la petición del cliente HTTP.
	 */
	public JSONObject process(String endpoint, String sendMethod, String bodyJsonString) throws HttpClientException {
		return httpClient.processRequest(this.mountServiceURL(endpoint), sendMethod, this.getAuthorizationHeader(), bodyJsonString, Service.RESPONSE_TIMEOUT, CharEncoding.UTF_8);
	}
}
