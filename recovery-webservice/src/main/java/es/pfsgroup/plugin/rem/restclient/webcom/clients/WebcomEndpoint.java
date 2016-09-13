package es.pfsgroup.plugin.rem.restclient.webcom.clients;

/**
 * Esta clase encapsula la información necesaria para saber cómo conectarnos a
 * un determinado endpoint de WEBCOM. Así como métodos factoría para obtener las
 * configuraciones para cada uno de los servicios.
 * 
 * @author bruno
 *
 */
public class WebcomEndpoint {
	
	private String httpMethod;
	

	private WebcomEndpoint(String httpMethod) {
		this.httpMethod = httpMethod;
	};

	/**
	 * Método factoría para obtener el endpoint para el servicio de actualización del estado del trabajo.
	 * @return
	 */
	public static WebcomEndpoint estadoTrabajo() {
		// TODO Configuración de las URL para los endpoints de los servicios a
		// invocar
		return new WebcomEndpoint("POST");
	}

	/**
	 * Método factoría para obtener el endpoint para el servicio de actualización del estado de una oferta.
	 * @return
	 */
	public static WebcomEndpoint estadoOferta() {
		// TODO Configuración de las URL para los endpoints de los servicios a
		// invocar
		return new WebcomEndpoint("POST");
	}

	/**
	 * Charset que debemos usar para conectarnos.
	 * @return
	 */
	public String getCharset() {
		return "UTF-8";
	}

	/**
	 * Timeout para la conexión con el endpoint
	 * @return
	 */
	public int getTimeout() {
		// TODO Configuración del timeout para invocar los servicios.
		return 10;
	}

	/**
	 * Método con el que nos debemos conectar al endpoint.
	 * @return
	 */
	public String getHttpMethod() {
		return this.httpMethod;
	}

	/**
	 * Url para acceder al endpoint.
	 * @return
	 */
	public String getEndpointUrl() {
		return "http://test/test";
	}

	/**
	 * AIP Key para WebCom
	 * @return
	 */
	public String getApiKey() {
		// TODO Obtener el API KEY del entorno WebCom al que nos conectamos
		return "0123456789";
	}
	
	@Override
	public String toString() {
		return "WebcomEndpoint [" + httpMethod + " => " + this.getEndpointUrl() + "]";
	}
}
