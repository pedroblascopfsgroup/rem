package es.pfsgroup.plugin.rem.restclient.salesforce.clients;

import java.io.FileWriter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacadeInternalError;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.salesforce.SalesforceRESTDevonProperties;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.WebcomEndpoint;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Este cliente de Salesforce sirve para invocar a todos los endpoints. El endpoint
 * al que queremos invocar se pasa como parámetro al método de invocación.
 * 
 * @author Isidro Sotoca
 *
 */
@Component
public class ClienteSalesforceGenerico {

	@Autowired
	private HttpClientFacade httpClient;

	@Resource
	private Properties appProperties;

	@Autowired
	private RestLlamadaDao llamadaDao;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Método genérico para enviar una petición REST a Salesforce.
	 * 
	 * @param authtoken
	 *            Token que se usará para verificarnos en Salesforce. Si es
	 *            null se entiende que 
	 * @param endpoint
	 *            Endpoint al que nos vamos a conectar.
	 * @param paramsList
	 *            Colección de Map de parámetros (campos) a enviar en la
	 *            petición.
	 * 
	 * @return
	 * @throws ErrorServicioWebcom
	 */
	public JSONObject send(String authtoken, SalesforceEndpoint endpoint, String jsonString)
			throws NumberFormatException, HttpClientException, RestConfigurationException {
		
		if (httpClient == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el httpClient.");
		}
		
		if (endpoint == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el endpoint.");
		}
		
		if (jsonString == null) {
			throw new IllegalArgumentException("'jsonString' no puede ser NULL");
		}
		
		RestLlamada registro = new RestLlamada();
		registro.setMetodo(endpoint.getHttpMethod());
		Map<String, String> headers = new HashMap<String, String>();
		
		String serviceUrl = null;
		if (authtoken != null) {
			headers.put("AUTHTOKEN", authtoken);
			serviceUrl = endpoint.getFullUrl();
		}
		else {
			serviceUrl = endpoint.getFullTokenUrl();
		}
		
		registro.setEndpoint(serviceUrl);
		registro.setRequest(jsonString);

		JSONObject result = 
			httpClient.processRequest(serviceUrl, endpoint.getHttpMethod(), headers, jsonString, endpoint.getTimeout(), endpoint.getCharset());

		try {
			registro.setResponse(result.toString());
			llamadaDao.guardaRegistro(registro);
		} catch (Exception e) {
			logger.error("Error al trazar la llamada al CDM", e);
		}

		return result;
	}
	
	/*TODO: 
	 * - Descargar certificado del endpoint al que vamos a atacar en formato .crt y añadirlo en una keytool al apache.
	 * 		Esto no hará falta, para las pruebas de desarrollo desactivaremos esta validacion (falta saber como hacerlo). Y
	 * 		luego al terminar el item se pondrá en la descripcion para que lo tengan en cuenta los de explotacion.
	 * - Comprobar si nos podemos conectar al endpoint del documento (con la informacion que nos contesten los de haya) DONE
	 * - Cambiar el nombre y requerimiento de los campos del formulario de alta de visitas DONE
	 * - Crear script que añada las 3 columnas acordadas en la tabla de visitas DONE
	 * - Hacer la validacion para activar o desactivar el boton de alta de visita (esta a medias HREOS-5306)
	 * - Verificar que despues de añadir la firma ssh al tomcat se obtiene el token correctamente
	 * - Hacer la segunda llamada que dara de alta la visita
	 * - Adaptar el WS de alta de visitas para que si llega con los nuevos parametros ademas de crear la visita
	 * se actualice su registro respecto
	 * */
	
}
