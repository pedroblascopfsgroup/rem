package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.rem.api.services.webcom.FaltanCamposObligatoriosException;
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
	 * método setea los campos comunes qeu se requieren en todos los Servicios.
	 * 
	 * @param proxyFactory
	 *            Este método requiere de una instancia de
	 *            {@link ApiProxyFactory} para obtener el 'usuarioLogado' del
	 *            sistema.
	 * @return
	 */
	protected HashMap<String, Object> createParametersMap(ApiProxyFactory proxyFactory) {
		logger.debug("Inicializando HashMap de parámetros");
		Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		HashMap<String, Object> params = new HashMap<String, Object>();

		String fechaAccion = WebcomRequestUtils.formatDate(new Date());
		logger.debug(ConstantesGenericas.FECHA_ACCION + " = " + fechaAccion);
		params.put(ConstantesGenericas.FECHA_ACCION, fechaAccion);

		String username = usuLogado.getUsername();
		logger.debug(ConstantesGenericas.ID_USUARIO_REM_ACCION + " = " + username);
		params.put(ConstantesGenericas.ID_USUARIO_REM_ACCION, username);
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
	 * @param params
	 *            Parámetros que queremos enviarle al servicio.
	 * @param servicio
	 *            Implementación del servicio. Debe extender la clase
	 *            {@link ClienteWebcomBase}.
	 */
	protected void invocarServicioRestWebcom(HashMap<String, Object> params, ClienteWebcomBase servicio) {
		try {
			
			
			logger.debug("Invocando al servicio " + servicio.getClass().getSimpleName()
					+ ".enviarPeticion con parámetros " + params);
			Map<String, Object> respuesta = servicio.enviaPeticion(params);

			logger.debug("Procesando respuesta" + servicio.getClass().getSimpleName() + ".procesarRespuesta " + params);
			servicio.procesaRespuesta(respuesta);
			
			
		} catch (ErrorServicioWebcom e) {
			logger.error("Error al invocar " + servicio.getClass().getSimpleName() + ".enviarPeticion con parámetros "
					+ params, e);
			if (ErrorServicioWebcom.INVALID_SIGNATURE.equals(e.getErrorWebcom())) {
				// TODO Loguear errores de las llamadas que no se deban
				// reintentar
			} else {
				logger.info("Se va a reintentar la invocación a " + servicio.getClass().getSimpleName()
						+ ".enviarPeticion con parámetros " + params);
				// TODO Configuración de colas para gestionar los reintentos
				MessageBroker mb = this.getMessageBroker();
				if (mb != null) {
					mb.sendAsync(servicio.getClass(), params);
				}else{
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