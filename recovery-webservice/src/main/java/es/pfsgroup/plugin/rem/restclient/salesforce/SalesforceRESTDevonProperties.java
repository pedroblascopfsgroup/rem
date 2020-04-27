package es.pfsgroup.plugin.rem.restclient.salesforce;

import java.util.Properties;

/**
 * Esta clase contendrá las variables del devon relacionadas 
 * con la transferencia de datos a Salesforce.
 * 
 * @author Isidro Sotoca
 *
 */
public class SalesforceRESTDevonProperties {

	//Rutas
	public static final String TOKEN_BASE_URL = "rest.client.salesforce.url.base";
	public static final String GET_TOKEN = "rest.client.salesforce.endpoint.login";
	public static final String ALTA_VISITAS = "rest.client.salesforce.endpoint.alta.visitas";
	
	//Credenciales
	public static final String USERNAME = "rest.client.salesforce.username";
	public static final String DEVON_PASS = "rest.client.salesforce.password";
	public static final String TIMEOUT_CONEXION = "rest.client.salesforce.timeout.seconds";
	public static final String CLIENT_ID = "rest.client.salesforce.client.id";
	public static final String CLIENT_SECRET = "rest.client.salesforce.client.secret";
	
	/*
	 * TODO: las contraseñas están puestas a pelo en el devon, hay que encriptarlas para mayor seguridad usando esto:
	 * https://link-doc.pfsgroup.es/confluence/pages/viewpage.action?pageId=7114213
	 */

	//Este método extrae la propiedad pasada como parámetro del devon
	public static String extractDevonProperty(Properties appProperties, String key, String defaultValue) {
		String value = appProperties != null ? appProperties.getProperty(key, defaultValue) : defaultValue;
		return value != null ? value : defaultValue;
	}
	
}
