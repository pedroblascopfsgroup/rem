package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.rem.api.services.webcom.FaltanCamposObligatoriosException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomBase;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ConstantesGenericas;
import es.pfsgroup.recovery.api.UsuarioApi;

public abstract class ServiciosWebcomBaseManager {

	private final Log logger = LogFactory.getLog(getClass());

	protected abstract MessageBroker getMessageBroker();

	public ServiciosWebcomBaseManager() {
		super();
	}

	/**
	 * Inicializa un HashMap de parámetros para invocar a un Servicio Web. Este
	 * método setea los campos comunes que se requieren en todos los Servicios.
	 * 
	 * @param usuarioId ID del usuario que realiza la petición.
	 * @return
	 */
	protected HashMap<String, Object> createParametersMap(Long usuarioId) {
		logger.debug("Inicializando HashMap de parámetros");
		HashMap<String, Object> params = new HashMap<String, Object>();

		String fechaAccion = WebcomRequestUtils.formatDate(new Date());
		logger.debug(ConstantesGenericas.FECHA_ACCION + " = " + fechaAccion);
		params.put(ConstantesGenericas.FECHA_ACCION, fechaAccion);

		logger.debug(ConstantesGenericas.ID_USUARIO_REM_ACCION + " = " + usuarioId);
		params.put(ConstantesGenericas.ID_USUARIO_REM_ACCION, usuarioId);
		return params;
	}

	/**
	 * Comprueba que el HashMap de parámetros contenga todos los campos
	 * requeridos para invocar al Servcio Web
	 * 
	 * @param params
	 *            HashMap de parámetros.
	 * @param fields
	 *            Parámetros que son obligatorios
	 */
	protected void compruebaObligatorios(HashMap<String, Object> params, String... fields) {

		logger.debug("Compprobando obligatoriedad de campos.");

		ArrayList<String> missingFields = new ArrayList<String>();
		if (!fieldExists(params, ConstantesGenericas.FECHA_ACCION)) {
			missingFields.add(ConstantesGenericas.FECHA_ACCION);
		}

		if (!fieldExists(params, ConstantesGenericas.ID_USUARIO_REM_ACCION)) {
			missingFields.add(ConstantesGenericas.ID_USUARIO_REM_ACCION);
		}
		for (String f : fields) {
			if (!fieldExists(params, f)) {
				missingFields.add(f);
			}
		}
		if (!missingFields.isEmpty()) {
			throw new FaltanCamposObligatoriosException(missingFields);
		}
		logger.debug("Todos los campos requeridos estan presentes");
	}

	/**
	 * Método genérico que invoca Servicios Web de WebCom
	 * 
	 * @param paramsList
	 *            Parámetros que queremos enviarle al servicio.
	 * @param servicio
	 *            Implementación del servicio. Debe extender la clase
	 *            {@link ClienteWebcomBase}.
	 */
	protected void invocarServicioRestWebcom(ParamsList paramsList, ClienteWebcomBase servicio) {
		if (paramsList == null){
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}
		
		try {
			
			logger.debug("Invocando al servicio " + servicio.getClass().getSimpleName()
					+ ".enviarPeticion con parámetros " + paramsList.toString());
			Map<String, Object> respuesta = servicio.enviaPeticion(paramsList);

			logger.debug(
					"Procesando respuesta" + servicio.getClass().getSimpleName() + ".procesarRespuesta " + respuesta);
			servicio.procesaRespuesta(respuesta);

		} catch (ErrorServicioWebcom e) {
			logger.error("Error al invocar " + servicio.getClass().getSimpleName() + ".enviarPeticion con parámetros "
					+ paramsList.toString(), e);
			if (! e.isHttpError()) {
				logger.fatal("Se ha producido un error no-reintentable en la llamada a servicio REST de Webcom", e);
				// TODO Loguear errores de las llamadas que no se deban
				// reintentar
			} else {
				logger.error("Se va a reintentar la invocación a " + servicio.getClass().getSimpleName()
						+ ".enviarPeticion con parámetros " + paramsList.toString());
				// TODO Configuración de colas para gestionar los reintentos
				MessageBroker mb = this.getMessageBroker();
				if (mb != null) {
					mb.sendAsync(servicio.getClass(), paramsList);
				} else {
					logger.warn("MESSAGE BROKER no está disponible");
				}
			}
		} 
	}


	/**
	 * Comprueba si un determinado campo existe en el HashMap
	 * 
	 * @param params
	 * @param field
	 * @return
	 */
	private boolean fieldExists(Map<String, Object> params, String field) {
		if ((params.get(field) == null) || ("".equals(params.get(field)))) {
			return false;
		}
		return true;
	}
}