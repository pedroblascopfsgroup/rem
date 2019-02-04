package es.pfsgroup.plugin.rem.restclient.salesforce.clients;

import java.util.Properties;

import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.salesforce.SalesforceRESTDevonProperties;

/**
 * Esta clase encapsula la información necesaria para saber cómo conectarnos a
 * un determinado endpoint del Saleforce de Haya. Así como métodos factoría para obtener las
 * configuraciones para cada uno de los servicios.
 * 
 * @author Isidro Sotoca
 *
 */
public class SalesforceEndpoint {

	//Variables default que se asignaran en el caso de que no se puedan obtener las del devon
	private static final String DEFAULT_METHOD = "POST";
	private static final String DEFAULT_CHARSET = "UTF-8";
	private static final String DEFAULT_TIMEOUT = "10";
	private static final String DEFAULT_BASE_URL = "http://unknown";
	private static final String DEFAULT_ENDPOINT_VALUE = "unknown";
	private static final String DEFAULT_USERNAME = "unknown";
	private static final String DEFAULT_PASSWORD = "unknown";
	private static final String DEFAULT_CLIENT_ID = "0123456789";
	private static final String DEFAULT_CLIENT_SECRET = "0123456789";
	private static final String GRANT_LOGIN = "password";
	
	private String httpMethod;
	private int timeout;
	private String baseUrl;
	private String endpointUrl;
	private String user;
	private String password;
	private String clientId;
	private String clientSecret;
	
	public SalesforceEndpoint(String httpMethod, int timeout, String baseUrl, String endpointUrl, String user,
			String password, String clientId, String clientSecret) {
		super();
		this.httpMethod = httpMethod;
		this.timeout = timeout;
		this.baseUrl = baseUrl;
		this.endpointUrl = endpointUrl;
		this.user = user;
		this.password = password;
		this.clientId = clientId;
		this.clientSecret = clientSecret;
	}

	/**
	 * Método factoría para obtener el endpoint para obtener el token de la sesión.
	 * 
	 * @return
	 */
	public static SalesforceEndpoint getTokenEndPoint(Properties appProperties) {
		return createSalesforceEndpointInstance(appProperties, SalesforceRESTDevonProperties.GET_TOKEN);
	}
	
	/**
	 * Charset que debemos usar para conectarnos.
	 * 
	 * @return
	 */
	public String getCharset() {
		return DEFAULT_CHARSET;
	}
	
	/**
	 * Timeout para la conexión con el endpoint
	 * 
	 * @return Devuelve el timeout en segundos
	 */
	public int getTimeout() {
		return this.timeout;
	}
	
	/**
	 * Método con el que nos debemos conectar al endpoint.
	 * 
	 * @return
	 */
	public String getHttpMethod() {
		return this.httpMethod;
	}

	/**
	 * Url para acceder al endpoint.
	 * 
	 * @return
	 */
	public String getEndpointUrl() {
		return this.endpointUrl;
	}
	
	public String getBaseUrl() {
		return baseUrl;
	}
	
	public String getFullUrl() {
		return this.baseUrl.concat(this.endpointUrl);
	}

	public String getUser() {
		return user;
	}

	public String getPassword() {
		return password;
	}

	public String getClientId() {
		return clientId;
	}

	public String getClientSecret() {
		return clientSecret;
	}
	
	public String getFullTokenUrl() {
		String fullUrl = getFullUrl();
		fullUrl += "?grant_type=" + GRANT_LOGIN;
		fullUrl += "&client_id=" + getClientId();
		fullUrl += "&client_secret=" + getClientSecret();
		fullUrl += "&username=" + getUser();
		fullUrl += "&password=" + getPassword();
		return fullUrl;
	}

	@Override
	public String toString() {
		return "SalesforceEndpoint [" + httpMethod + " => " + this.getEndpointUrl() + "]";
	}
	
	private static SalesforceEndpoint createSalesforceEndpointInstance(Properties appProperties, String endpointKey) {
		
		String timeout = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.TIMEOUT_CONEXION, DEFAULT_TIMEOUT);
		String baseUrl = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.BASE_URL, null);
		String endpoint = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				endpointKey, null);
		String user = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.USERNAME, null);
		String password = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.PASSWORD, null);
		String clientId = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.CLIENT_ID, null);
		String clientSecret = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.CLIENT_SECRET, null);
		
		return new SalesforceEndpoint(DEFAULT_METHOD, Integer.parseInt(timeout), baseUrl, endpoint, user, password, clientId, clientSecret);
	}
	
	public void validateCallTokenEndpoint() throws RestConfigurationException {
		
		if (this.clientId == null || this.clientId.isEmpty() || this.clientSecret == null || this.clientSecret.isEmpty()) {
			throw new RestConfigurationException("configura el clientId y el clientSecret");
		}
		
		if (this.user == null || this.user.isEmpty() || this.password == null || this.password.isEmpty()) {
			throw new RestConfigurationException("configura el user y el password");
		}
		
		if (this.baseUrl == null || this.baseUrl.isEmpty()) {
			throw new RestConfigurationException("configura la baseUrl");
		}
		
		if (this.endpointUrl == null || this.endpointUrl.isEmpty()) {
			throw new RestConfigurationException("configura el endpointUrl");
		}
		
	}
	
}
