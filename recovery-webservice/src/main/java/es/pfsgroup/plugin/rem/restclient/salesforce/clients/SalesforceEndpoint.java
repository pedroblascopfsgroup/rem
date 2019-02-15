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
	private static final String GRANT_LOGIN = "password";
	
	//ERRORES
	private static String ERROR_CLIENTID_CLIENTSECRET = "configura el clientId y el clientSecret";
	private static String ERROR_USER_PASS = "configura el user y el password";
	private static String ERROR_TOKENBASEURL = "configura la tokenBaseUrl";
	private static String ERROR_TOKENENDPOINTURL = "configura el tokenEndpointUrl";
	private static String ERROR_BASEURL = "configura la baseUrl";
	private static String ERROR_ENDPOINTURL = "configura el endpointUrl";
	
	private String httpMethod;
	private int timeout;
	private String tokenBaseUrl;
	private String tokenEndpointUrl;
	private String user;
	private String password;
	private String clientId;
	private String clientSecret;
	private String baseUrl;
	private String endpointUrl;
	
	public SalesforceEndpoint(String httpMethod, int timeout, String tokenBaseUrl, String tokenEndpointUrl, String user,
			String password, String clientId, String clientSecret, String baseUrl, String endpointUrl) {
		super();
		this.httpMethod = httpMethod;
		this.timeout = timeout;
		this.tokenBaseUrl = tokenBaseUrl;
		this.tokenEndpointUrl = tokenEndpointUrl;
		this.user = user;
		this.password = password;
		this.clientId = clientId;
		this.clientSecret = clientSecret;
		this.baseUrl = baseUrl;
		this.endpointUrl = endpointUrl;
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
	 * Método factoría para obtener el endpoint de Salesforce.
	 * 
	 * @return
	 */
	public static SalesforceEndpoint getEndPoint(Properties appProperties, String endpointKey) {
		return createSalesforceEndpointInstance(appProperties, endpointKey);
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
	public String getTokenEndpointUrl() {
		return this.tokenEndpointUrl;
	}
	
	public String getTokenBaseUrl() {
		return tokenBaseUrl;
	}
	
	public String getTokenFullUrl() {
		return this.tokenBaseUrl.concat(this.tokenEndpointUrl);
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
		String fullUrl = getTokenFullUrl();
		fullUrl += "?grant_type=" + GRANT_LOGIN;
		fullUrl += "&client_id=" + getClientId();
		fullUrl += "&client_secret=" + getClientSecret();
		fullUrl += "&username=" + getUser();
		fullUrl += "&password=" + getPassword();
		return fullUrl;
	}
	
	public String getFullUrl() {
		return this.baseUrl.concat(this.endpointUrl);
	}

	@Override
	public String toString() {
		return "SalesforceEndpoint [" + httpMethod + " => " + this.getTokenEndpointUrl() + "]";
	}
	
	private static SalesforceEndpoint createSalesforceEndpointInstance(Properties appProperties, String endpointKey) {
		
		String tokenBaseUrl = "";
		String tokenEndpointUrl = "";
		String baseUrl = "";
		String endpointUrl = "";
		if (SalesforceRESTDevonProperties.GET_TOKEN.equals(endpointKey)) {
			tokenBaseUrl = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
					SalesforceRESTDevonProperties.TOKEN_BASE_URL, null);
			tokenEndpointUrl = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
					SalesforceRESTDevonProperties.GET_TOKEN, null);
		}
		else {
			endpointUrl = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
					endpointKey, null);
		}
		
		String timeout = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.TIMEOUT_CONEXION, DEFAULT_TIMEOUT);
		String user = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.USERNAME, null);
		String password = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.PASSWORD, null);
		String clientId = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.CLIENT_ID, null);
		String clientSecret = SalesforceRESTDevonProperties.extractDevonProperty(appProperties,
				SalesforceRESTDevonProperties.CLIENT_SECRET, null);
		
		return new SalesforceEndpoint(DEFAULT_METHOD, Integer.parseInt(timeout), tokenBaseUrl, 
				tokenEndpointUrl, user, password, clientId, clientSecret, baseUrl, endpointUrl);
	}
	
	public void validateTokenEndpointCall() throws RestConfigurationException {
		
		if (this.clientId == null || this.clientId.isEmpty() || this.clientSecret == null || this.clientSecret.isEmpty()) {
			throw new RestConfigurationException(ERROR_CLIENTID_CLIENTSECRET);
		}
		
		if (this.user == null || this.user.isEmpty() || this.password == null || this.password.isEmpty()) {
			throw new RestConfigurationException(ERROR_USER_PASS);
		}
		
		if (this.tokenBaseUrl == null || this.tokenBaseUrl.isEmpty()) {
			throw new RestConfigurationException(ERROR_TOKENBASEURL);
		}
		
		if (this.tokenEndpointUrl == null || this.tokenEndpointUrl.isEmpty()) {
			throw new RestConfigurationException(ERROR_TOKENENDPOINTURL);
		}
		
	}
	
	public void validateEndpointCall() throws RestConfigurationException {
		
		if (this.baseUrl == null || this.baseUrl.isEmpty()) {
			throw new RestConfigurationException(ERROR_BASEURL);
		}
		
		if (this.endpointUrl == null || this.endpointUrl.isEmpty()) {
			throw new RestConfigurationException(ERROR_ENDPOINTURL);
		}
		
	}

	public void setBaseUrl(String fullUrl) {
		this.baseUrl = fullUrl;
	}

	public String getBaseUrl() {
		return baseUrl;
	}

	public String getEndpointUrl() {
		return endpointUrl;
	}
	
	
}
