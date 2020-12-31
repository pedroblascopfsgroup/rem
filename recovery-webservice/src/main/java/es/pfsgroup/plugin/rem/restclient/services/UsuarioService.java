package es.pfsgroup.plugin.rem.restclient.services;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import net.sf.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

/**
 * Implementación de ejemplo para llamadas al servicio de autenticación de REM3.
 */
@Component
public class UsuarioService extends Service {
	private static final String SERVICE_ROUTE = "autenticacion";
	private static final String SERVICE_VERSION_ROUTE = "latest";

	private final Log logger = LogFactory.getLog(getClass());


	@Override
	public String getServiceRouteName() {
		return UsuarioService.SERVICE_ROUTE;
	}

	@Override
	public String getServiceVersionRoute() {
		return UsuarioService.SERVICE_VERSION_ROUTE;
	}

	/**
	 * Método de ejemplo para obtener un usuario, 'SUPER', del servicio de autenticación de REM3.
	 *
	 * @throws HttpClientException Esta excepción se da cuando algo ha ido mal en la petición del cliente HTTP.
	 */
	public void getUsuarioFromService() throws HttpClientException {
		JSONObject response = this.process("usuario/SUPER", "GET", "");
		logger.info(response);
	}
}
