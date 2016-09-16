package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.Properties;

public class WebcomRESTDevonProperties {

	public static final String BASE_URL = "rest.client.webcom.url.base";
	public static final String ESTADO_TRABAJO_ENDPOINT = "rest.client.webcom.endpoint.trabajo";
	public static final String ESTADO_OFERTA_ENDPOINT = "rest.client.webcom.endpoint.oferta";
	public static final String ACTUALIZAR_STOCK_ENDPOINT = "rest.client.webcom.endpoint.stock";
	public static final String TIMEOUT_CONEXION = "rest.client.webcom.timeout.seconds";
	public static final String SERVER_API_KEY = "rest.server.rem.api.key";
	public static final String SERVER_PUBLIC_ADDRESS = "rest.client.rem.public.ip";
	
	// Esta property se usa en el fichero de configuración de Spring ac-rem-deteccion-cambios-bd.xml
	public static final String CRON_EXPRESSION_TRIGGER_CHANGE_DETECTION = "rest.client.chrone.rem.time.trigger";
	
	
	public static String extractDevonProperty(Properties appProperties, String key, String defaultValue) {
		return (appProperties != null ? appProperties.getProperty(key, defaultValue)
				: defaultValue);
	}

}
