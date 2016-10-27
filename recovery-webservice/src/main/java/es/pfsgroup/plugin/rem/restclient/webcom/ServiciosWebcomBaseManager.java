package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.exception.ExceptionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.FaltanCamposObligatoriosException;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomGenerico;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.WebcomEndpoint;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ConstantesGenericas;

public abstract class ServiciosWebcomBaseManager {

	private static final String REGEXP_4_DOT = "\\.";
	private final Log logger = LogFactory.getLog(getClass());

	protected abstract ClienteWebcomGenerico getClienteWebcom();

	public ServiciosWebcomBaseManager() {
		super();
	}

	/**
	 * Inicializa un HashMap de parámetros para invocar a un Servicio Web. Este
	 * método setea los campos comunes que se requieren en todos los Servicios.
	 * 
	 * @param dto
	 *            DTO que contiene los datos que queremos enviar.
	 * @return
	 */
	protected HashMap<String, Object> createParametersMap(WebcomRESTDto dto) {

		if (dto == null) {
			throw new IllegalArgumentException("'dto' no puede ser NULL");
		}

		LongDataType usuarioId = dto.getIdUsuarioRemAccion();
		DateDataType fechaAccion = dto.getFechaAccion();
		/*
		 * Dejamos esto comentado, no validamos los campos obligatorios, que sea
		 * WEBCOM quien nos devuelva el error
		 * 
		 * if ((usuarioId == null) || (usuarioId.getValue() == null)) { throw
		 * new IllegalArgumentException(
		 * "El dto no está bien conformado: 'idUsuarioRemAccion' no puede ser null"
		 * ); }
		 * 
		 * if ((fechaAccion == null) || (fechaAccion.getValue() == null)) {
		 * throw new IllegalArgumentException(
		 * "El dto no está bien conformado: 'fechaAccion' no puede ser null"); }
		 */

		HashMap<String, Object> params = new HashMap<String, Object>();

		String strFechaAccion = WebcomRequestUtils.formatDate(fechaAccion.getValue());
		params.put(ConstantesGenericas.FECHA_ACCION, strFechaAccion);
		params.put(ConstantesGenericas.ID_USUARIO_REM_ACCION, usuarioId);
		return params;
	}

	/**
	 * Este método compprueba que un determinado Map (String, Object) contenta
	 * todos los valores marcados como obligatorios en el DTO.
	 * 
	 * <p>
	 * La indicación de que un campo es obligatorio debe realizarse anotando los
	 * campos como @WebcomRequired en el mismo DTO
	 * </p>
	 * 
	 * <p>
	 * Este método lanza una excepción de tipo
	 * {@link FaltanCamposObligatoriosException} si falta algún campo
	 * obligatorio.
	 * 
	 * @param dtoClass
	 *            Clase del DTO. Se va a buscar en él la
	 *            anotación @WebcomRequired
	 * @param params
	 *            Map que queremos comprobar.
	 * 
	 * 
	 */
	public void compruebaObligatorios(Class dtoClass, Map<String, Object> params) {

		if (dtoClass == null) {
			throw new IllegalArgumentException("'dtoClass' no puede ser NULL");
		}

		if (params == null) {
			throw new IllegalArgumentException("'params' no puede ser NULL");
		}

		logger.debug("Compprobando obligatoriedad de campos.");

		ArrayList<String> missingFields = new ArrayList<String>();
		if (!fieldExists(params, ConstantesGenericas.FECHA_ACCION)) {
			missingFields.add(ConstantesGenericas.FECHA_ACCION);
		}

		if (!fieldExists(params, ConstantesGenericas.ID_USUARIO_REM_ACCION)) {
			missingFields.add(ConstantesGenericas.ID_USUARIO_REM_ACCION);
		}

		String[] camposObligatorios = WebcomRequestUtils.camposObligatorios(dtoClass);

		if (camposObligatorios != null) {
			for (String f : camposObligatorios) {
				String complexObject = objectName(f);
				if (complexObject == null) {
					if (!fieldExists(params, f)) {
						missingFields.add(f);
					}
				} else {
					String missingField = checkMissingInNestedObject(params.get(complexObject), f);
					if (missingField != null) {
						missingFields.add(missingField);
					}
				}
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
	 * @param endpoint
	 *            Endpoint al que nos queremos conectar.
	 * @param paramsList
	 *            Parámetros que queremos enviarle al servicio.
	 *
	 * @throws ErrorServicioWebcom
	 */
	protected void invocarServicioRestWebcom(WebcomEndpoint endpoint, ParamsList paramsList, RestLlamada registro)
			throws ErrorServicioWebcom {

		if (endpoint == null) {
			throw new IllegalArgumentException("'endpoint' no puede ser NULL");
		}

		if (paramsList == null) {
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}

		RestLlamada registroLlamada = registro;
		if (registroLlamada == null) {
			registroLlamada = new RestLlamada();
		}

		try {

			logger.debug("Invocando al servicio " + endpoint);
			getClienteWebcom().send(endpoint, paramsList, registroLlamada);
			logger.debug("Respuesta recibida " + endpoint);

		} catch (ErrorServicioWebcom e) {
			logger.error("Error al invocar " + endpoint + " con parámetros " + paramsList.toString(), e);
			if (!e.isHttpError()) {
				logger.fatal("Se ha producido un error no-reintentable en la llamada a servicio REST de Webcom", e);
				e.setReintentable(false);
			} else {
				logger.error(
						"Se va a reintentar la invocación a " + endpoint + " con parámetros " + paramsList.toString());
				e.setReintentable(true);
			}

			registroLlamada.setException(ExceptionUtils.getFullStackTrace(e));

			throw e;
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

	/**
	 * Comprueba si el campo hace referencia a un objeto complejo. Si es así
	 * devuelve el nombre del campo. Si es un valor simple devuelve NULL
	 * <p>
	 * Para ello comprueba que el campo tenga el formato
	 * <code>collection.field</code>
	 * </p>
	 * 
	 * @param field
	 * @return
	 */
	private String objectName(String field) {
		if (field != null) {
			String[] split = field.split(REGEXP_4_DOT);
			if (split.length > 1) {
				return split[0];
			}
		}
		return null;
	}

	/**
	 * Comprueba si un campo 'f' falta por informar en un determinado objeto.
	 * <p>
	 * Devuelve el nombre del campo 'f' si no está informado el/los objeto/s
	 * complejos que queremos comprobar. En caso contrario (si no falta)
	 * devuelve null.
	 * </p>
	 * 
	 * @param complexObject
	 *            Map o Collection de Maps que representan a un objet complejo o
	 *            a un conjunto de ellos.
	 * @param f
	 * @return Si complexObject es null o es una colección vacía devuelve NULL.
	 */
	private String checkMissingInNestedObject(Object complexObject, String f) {
		if ((complexObject != null) && (f != null)) {
			if (Collection.class.isAssignableFrom(complexObject.getClass())) {
				// Si se trata de una colección de objetos
				String missing = null;
				for (Object o : ((Collection) complexObject)) {
					// Volvemos a llamar recursivamente por cada uno de los
					// objetos
					missing = checkMissingInNestedObject(o, f);
				}
				return missing;
			} else {
				// Si se trata de un Map ... ¿lo comprobamos primero?
				if (Map.class.isAssignableFrom(complexObject.getClass())) {
					String[] split = f.split(REGEXP_4_DOT);
					String key = split[split.length - 1];
					if (!fieldExists((Map) complexObject, key)) {
						return f;
					}
				} else {
					// si no es un map, decimos que el campo falta.
					return f;
				}

			}
		}
		return null;
	}

	/**
	 * Crea un objeto ParamList para invocar al web service a partir de una
	 * lista de DTO's. Este método también hará una comprobación de que los
	 * campos obligatorios estén presentes.
	 * 
	 * @param dtoList
	 *            Lista de DTO's que queremos mandar al servicio
	 * @param camposObligatorios
	 *            Lista variable de campos obligatorios.
	 * @return
	 */
	protected <T extends WebcomRESTDto> ParamsList createParamsList(List<T> dtoList) {
		ParamsList paramsList = new ParamsList();
		if (dtoList != null) {
			logger.debug("Convirtiendo dtoList -> ParamsList");
			for (WebcomRESTDto dto : dtoList) {
				HashMap<String, Object> params = createParametersMap(dto);
				params.putAll(Converter.dtoToMap(dto));
				// Comentado con Anahuac. No fallamos si faltan campos
				// obligatorios. Dejamos que falle webcom.
				// compruebaObligatorios(dto.getClass(), params);
				paramsList.add(params);
			}
		} else {
			logger.debug("'dtoList' es NULL");
		}
		return paramsList;
	}

}