package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.exception.ExceptionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.rem.api.services.webcom.FaltanCamposObligatoriosException;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.NullDataType;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomBase;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ConstantesGenericas;

public abstract class ServiciosWebcomBaseManager {

	private final Log logger = LogFactory.getLog(getClass());

	protected abstract RegistroLlamadasManager getRegistroLlamadas();

	public ServiciosWebcomBaseManager() {
		super();
	}

	/**
	 * Inicializa un HashMap de parámetros para invocar a un Servicio Web. Este
	 * método setea los campos comunes que se requieren en todos los Servicios.
	 * 
	 *@param dto DTO que contiene los datos que queremos enviar.
	 * @return
	 */
	protected HashMap<String, Object> createParametersMap(WebcomRESTDto dto) {
		
		if (dto == null){
			throw new IllegalArgumentException("'dto' no puede ser NULL");
		}
		
		LongDataType usuarioId = dto.getIdUsuarioRemAccion();
		if ((usuarioId == null) || (usuarioId instanceof NullDataType)){
			throw new IllegalArgumentException("El dto no está bien conformado: 'idUsuarioRemAccion' no puede ser null");
		}
		
		DateDataType fechaAccion = dto.getFechaAccion();
		if ((fechaAccion == null) || (fechaAccion instanceof NullDataType)){
			throw new IllegalArgumentException("El dto no está bien conformado: 'fechaAccion' no puede ser null");
		}
		
		logger.debug("Inicializando HashMap de parámetros");
		
		HashMap<String, Object> params = new HashMap<String, Object>();

		String strFechaAccion = WebcomRequestUtils.formatDate(fechaAccion.getValue());
		logger.debug(ConstantesGenericas.FECHA_ACCION + " = " + strFechaAccion);
		params.put(ConstantesGenericas.FECHA_ACCION, strFechaAccion);

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
	 * @throws ErrorServicioWebcom 
	 */
	protected void invocarServicioRestWebcom(ParamsList paramsList, ClienteWebcomBase servicio) throws ErrorServicioWebcom {
		if (paramsList == null){
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}
		
		if (servicio == null){
			IllegalArgumentException e = new IllegalArgumentException("El Cliente REST Webcom asociado a este servicio es NULL");
			logger.fatal("No se va a invocar el servicio porque la implementación del cliente rest no está disponible o es desconocida", e);
			throw e;
		}
		
		RestLlamada registroLlamada = new RestLlamada();
		try {
			
			logger.debug("Invocando al servicio " + servicio.getClass().getSimpleName()
					+ ".enviarPeticion con parámetros " + paramsList.toString());
			Map<String, Object> respuesta = servicio.enviaPeticion(paramsList, registroLlamada);

			logger.debug(
					"Procesando respuesta" + servicio.getClass().getSimpleName() + ".procesarRespuesta " + respuesta);
			servicio.procesaRespuesta(respuesta);

		} catch (ErrorServicioWebcom e) {
			logger.error("Error al invocar " + servicio.getClass().getSimpleName() + ".enviarPeticion con parámetros "
					+ paramsList.toString(), e);
			if (! e.isHttpError()) {
				logger.fatal("Se ha producido un error no-reintentable en la llamada a servicio REST de Webcom", e);
				e.setReintentable(false);
			} else {
				logger.error("Se va a reintentar la invocación a " + servicio.getClass().getSimpleName()
						+ ".enviarPeticion con parámetros " + paramsList.toString());
				//getRegistroLlamadas().guardaRegistroLlamada(registroLlamada);
				e.setReintentable(true);
			}
			
			registroLlamada.setException(ExceptionUtils.getFullStackTrace(e));
			
			throw e;
		}finally{
			getRegistroLlamadas().guardaRegistroLlamada(registroLlamada);
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