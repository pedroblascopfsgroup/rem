package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.Properties;

import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;

/**
 * Esta clase encapsula la información necesaria para saber cómo conectarnos a
 * un determinado endpoint de WEBCOM. Así como métodos factoría para obtener las
 * configuraciones para cada uno de los servicios.
 * 
 * @author bruno
 *
 */
public class WebcomEndpoint {

	private static final String DEFAULT_API_KEY = "0123456789";
	private static final String DEFAULT_TIMEOUT = "10";
	private static final String HTTP_UNKNOWN = "http://unknown";
	private static final String UNKNOWN_ENDPOINT_VALUE = "unknown";
	private String httpMethod;
	private String endpointUrl;
	private int timeout;
	private String apiKey;

	private WebcomEndpoint(String httpMethod, String endpointUrl, int timeout, String apiKey) {
		this.httpMethod = httpMethod;
		this.endpointUrl = endpointUrl;
		this.timeout = timeout;
		this.apiKey = apiKey;
	};

	/**
	 * Método factoría para obtener el endpoint para el servicio de
	 * actualización del estado del trabajo.
	 * 
	 * @return
	 */
	public static WebcomEndpoint estadoPeticionTrabajo(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ESTADO_TRABAJO_ENDPOINT,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de
	 * actualización del estado de una oferta.
	 * 
	 * @return
	 */
	public static WebcomEndpoint estadoOferta(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ESTADO_OFERTA_ENDPOINT,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de envío del
	 * stock de activos.
	 * 
	 * @return
	 */
	public static WebcomEndpoint stock(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ACTUALIZAR_STOCK_ENDPOINT,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de envío de
	 * ventas y comisiones.
	 * 
	 * @return
	 */
	public static WebcomEndpoint ventasYcomisiones(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.VENTAS_Y_COMISIONES_ENDPOINT,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de envío
	 * cambios de estado en notificaciones.
	 * 
	 * @return
	 */
	public static WebcomEndpoint estadoNotificacion(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ESTADO_NOTIFICACION_ENDPOINT,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de envío de
	 * proveedores.
	 * 
	 * @return
	 */
	public static WebcomEndpoint proveedores(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ENVIO_PROVEEDORES,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de envío de
	 * cambios de estado en el Informe del Mediador.
	 * 
	 * @return
	 */
	public static WebcomEndpoint estadoInformeMediador(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ENVIO_INFORME_MEDIADOR,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de envío de
	 * cabeceras de agrupaciones de obras nuevas (de).
	 * 
	 * @return
	 */
	public static WebcomEndpoint cabecerasObrasNuevas(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ENVIO_CABECERAS_OBRAS_NUEVAS,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de envío de
	 * activos de agrupaciones de obras nuevas (nunca hay demasiados des).
	 * 
	 * @return
	 */
	public static WebcomEndpoint activosObrasNuevas(Properties appProperties) {
		String url = createEndpointUrl(appProperties, WebcomRESTDevonProperties.ENVIO_ACTIVOS_OBRAS_NUEVAS,
				UNKNOWN_ENDPOINT_VALUE);
		return createWebcomEndpointInstance(appProperties, url);
	}

	/**
	 * Charset que debemos usar para conectarnos.
	 * 
	 * @return
	 */
	public String getCharset() {
		return "UTF-8";
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

	/**
	 * AIP Key para WebCom
	 * 
	 * @return
	 */
	public String getApiKey() {
		return this.apiKey;
	}

	@Override
	public String toString() {
		return "WebcomEndpoint [" + httpMethod + " => " + this.getEndpointUrl() + "]";
	}

	private static String createEndpointUrl(Properties appProperties, String key, String defaultValue) {
		String endpoint = (appProperties != null ? appProperties.getProperty(key, defaultValue) : defaultValue);

		String url = WebcomRESTDevonProperties.extractDevonProperty(appProperties, WebcomRESTDevonProperties.BASE_URL,
				HTTP_UNKNOWN) + endpoint;
		return url;
	}

	private static WebcomEndpoint createWebcomEndpointInstance(Properties appProperties, String url) {
		String timeout = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.TIMEOUT_CONEXION, DEFAULT_TIMEOUT);
		String apiKey = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.SERVER_API_KEY, DEFAULT_API_KEY);
		return new WebcomEndpoint("POST", url, Integer.parseInt(timeout), apiKey);
	}

}
