package es.pfsgroup.plugin.rem.rest.api;

import java.beans.IntrospectionException;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.ModelMap;

import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import net.sf.json.JSONObject;

public interface RestApi {

	public enum TIPO_VALIDACION {
		UPDATE, INSERT
	}

	public enum TRANSFORM_TYPE {
		NONE, BOOLEAN_TO_INTEGER, FLOAT_TO_BIGDECIMAL, DATE_TO_YEAR_INTEGER, LONG_TO_STRING
	}

	public enum ALGORITMO_FIRMA {
		DEFAULT, NO_IP
	}
	
	public enum ENTIDADES {
		ACTIVO,INFORME
	}

	public static final String CODE_ERROR = "ERROR";
	public static final String CODE_OK = "OK";
	public static final String REST_MSG_BROKER_NOT_EXIST = "BROKER_NOT_EXIST";
	public static final String REST_MSG_INVALID_SIGNATURE = "INVALID_SIGNATURE";
	public static final String REST_MSG_REPEATED_REQUEST = "REPEATED_REQUEST";
	public static final String REST_MSG_MISSING_REQUIRED_FIELDS = "MISSING_REQUIRED_FIELDS";
	public static final String REST_NO_RELATED_OFFER = "NO_EXISTE_OFERTA_RELACIONADA";
	public static final String REST_NO_RELATED_OFFER_ACCEPTED = "NO_EXISTE_OFERTA_ACEPTADA_RELACIONADA";
	public static final String REST_NO_RELATED_EXPEDIENT = "NO_EXISTE_EXPEDIENTE_RELACIONADO";
	public static final String REST_NO_RELATED_COND_EXPEDIENT = "NO_EXISTE_CONDICIONANTE_EXPEDIENTE_RELACIONADO";
	public static final String REST_NO_RELATED_ASSET = "SIN_ACTIVO_RELACIONADO_CON_LA_OFERTA";
	public static final String REST_MSG_MISSING_REQUIRED = "REQUIRED";
	public static final String REST_MSG_INVALID_WORKINGCODE = "INVALID";
	public static final String REST_MSG_UNKNOWN_KEY = "INVALID";
	public static final String REST_MSG_OVERFLOW = "INVALID";
	public static final String REST_UNIQUE_VIOLATED = "INVALID";
	public static final String REST_MSG_UNEXPECTED_ERROR = "UNEXPECTED_ERROR";
	public static final String REST_LOGGED_USER_USERNAME = "REST-USER";
	public static final String REM_LOGGED_USER_USERNAME = "REM-USER";
	public static final String REST_LOGGED_USER_USERNAME_FULL = "REST-USER";
	public static final Object REST_LOGGED_USER_EMPTY_PASSWORD = "";
	public static final String REST_API_LOCKED = "REST_API_LOCKED";
	public static final String REST_API_ALL = "TODOS";
	public static final String REST_API_WEBCOM = "WEBCOM";
	public static final String REST_API_BANKIA = "BANKIA";
	public static final String REST_API_ENVIAR_CAMBIOS = "CAMBIOS";
	public static final String REST_MSG_TAREA_INVALIDA = "INVALID";
	public static final String REST_MSG_VALIDACION_TAREA = "VALIDACION_TAREA_ERROR";
	public static final String REST_MSG_INVALID_ENTITY_TYPE = "ENTIDAD INCORRECTA";
	public static final String REST_MSG_UNKNOW_KEY = "UNKNOW_KEY";
	public static final String REST_MSG_NO_RELATED_OFFER = "NO_RELATED_OFFER";
	public static final String REST_MSG_UNKNOW_ENTITY = "UNKNOW_ENTITY";
	public static final String REST_MSG_UNKNOW_JOB = "UNKNOW_JOB";
	public static final String REST_MSG_UNKNOW_OFFER = "UNKNOW_OFFER";
	public static final String REST_MSG_NO_RELATED_AT = "NO_RELATED_AT";
	public static final String REST_NO_PARAM = "MISSING_PARAMS";
	public static final String REST_MSG_FORMAT_ERROR = "FORMAT_ERROR";
	public static final String REST_FASE_SUBFASE_INVALIDAS = "FASE_O_SUBFASE_INVALIDAS";
	public static final String REST_INF_COM_APROBADO = "YA_TIENE_INFORME_COMERCIAL_APROBADO";
	public static final String REST_NO_EXIST_CUENTA_VIRTUAL = "NO_HAY_CUENTAS_VIRTUALES_LIBRES";
	/**
	 * Valida la firma
	 * 
	 * @param ipClient
	 * @param signature
	 * @return
	 */
	public boolean validateSignature(Broker broker, String signature, RestRequestWrapper restRequest)
			throws NoSuchAlgorithmException, UnsupportedEncodingException;

	/**
	 * Valida la firma del webhook
	 * 
	 * @param signature
	 * @return
	 */
	public boolean validateWebhookSignature(ServletRequest req, String signature) throws RestConfigurationException;

	/**
	 * Valida el id
	 * 
	 * @param id
	 * @return
	 */
	public boolean validateId(Broker broker, String id);

	/**
	 * Valida el pojo pasado a la rest api
	 * 
	 * @param obj
	 * @return
	 */
	public HashMap<String, String> validateRequestObject(Serializable obj, TIPO_VALIDACION tipovalidacion);

	/**
	 * Valida el pojo pasado a la rest api
	 * 
	 * @param obj
	 * @return
	 */
	public HashMap<String, String> validateRequestObject(Serializable obj);

	/**
	 * Obtiene un operador dada su ip pblica
	 * 
	 * @param ip
	 * @return
	 */
	public Broker getBrokerByIp(String ip);

	/**
	 * Obtiene el operador por defecto para una querystring
	 * 
	 * @param queryString
	 * @return
	 */
	public Broker getBrokerDefault(String queryString);

	/**
	 * Guarda una peticion rest
	 * 
	 * @param peticion
	 */
	public void guardarPeticionRest(PeticionRest peticion);

	/**
	 * Obtiene una peticion rest por id
	 * 
	 * @param id
	 *            de la petición a consultar
	 * @return PeticionRest
	 */
	public PeticionRest getPeticionById(Long id);

	/**
	 * Obtiene una peticion rest por token
	 * 
	 * @param token
	 *            de la petición a consultar
	 * @return PeticionRest
	 */
	public PeticionRest getLastPeticionByToken(String token);

	/**
	 * Obtiene una llamada rest por token
	 * 
	 * @param token
	 * @return
	 */
	public RestLlamada getLlamadaByToken(String token);

	/**
	 * Obtiene la ip del operador
	 * 
	 * @param request
	 * @return
	 */
	public String getClientIpAddr(ServletRequest request);

	/**
	 * Escribe en la salida standard una respuesta JSON
	 * 
	 * @param response
	 * @param model
	 */
	public void sendResponse(HttpServletResponse response, ModelMap model, RestRequestWrapper request);

	/**
	 * Escribe en la salida standard una respuesta JSON
	 * 
	 * @param response
	 * @param model
	 * @param request
	 * @param jsonResp
	 * @param result
	 */
	public void sendResponse(HttpServletResponse response, RestRequestWrapper request, JSONObject jsonResp,
			String result);

	/**
	 * Escribe en la salida standard una respuesta JSON
	 * 
	 * @param response
	 * @param request
	 * @param jsonResp
	 */
	public void sendResponse(HttpServletResponse response, String jsonResp);

	/**
	 * 
	 * Crea un usuario ficticio. Los datos del usuario ficticio deberán existir
	 * en base de datos ya que en posteriores ejecuciones se accederá a ésta
	 * para login. 
	 * @param entidad
	 * @param user
	 * @return
	 */
	public UsuarioSecurity loadUser(Entidad entidad, String userName);

	/**
	 * Realiza el login de un usuario ficticio en una entidad de base de datos
	 * pasada por parámetro. Los datos del usuario ficticio deberán existir en
	 * base de datos ya que en posteriores ejecuciones se accederá a ésta para
	 * login.
	 * 
	 * @param entidad
	 */
	public void doLogin(UsuarioSecurity user);

	/**
	 * Crea un objeto de tipo peticion rest
	 * 
	 * @param req
	 * @return
	 */
	public PeticionRest crearPeticionObj(RestRequestWrapper req);

	/**
	 * Obtiene el nombre del del servicio ejecutado
	 * 
	 * @param req
	 * @return
	 */
	public String obtenerNombreServicio(ServletRequest req);

	/**
	 * Obtiene el algoritmo de la firma
	 * 
	 * @param req
	 * @return
	 */
	public ALGORITMO_FIRMA obtenerAlgoritmoFirma(ServletRequest req);

	/**
	 * Obtiene el algoritmo de la firma segun el servicio
	 * 
	 * @param nombreServicio
	 * @return
	 */
	public ALGORITMO_FIRMA obtenerAlgoritmoFirma(String nombreServicio, String ipClient);

	/**
	 * Lanza una excepcion rest
	 * 
	 * @param res
	 * @param errorCode
	 * @param jsonFields
	 */
	public void throwRestException(ServletResponse res, String errorCode, JSONObject jsonFields,
			RestRequestWrapper req);

	/**
	 * Realiza la configuracion de la sesión
	 * 
	 * @param response
	 * @throws Exception
	 */
	public void doSessionConfig() throws Exception;
	
	/**
	 * Realiza la configuracion de la sesión usando el usuario dado
	 * 
	 * @param usuario
	 * @throws Exception
	 */
	public void doSessionConfig(String usuario) throws Exception;
	
	/**
	 * 
	 * @param req
	 */
	public void simulateRestFilter(ServletRequest req) throws Exception;
	
	/**
	 * Obtiene el valor de un campo de un dto
	 * 
	 * @param dto
	 * @param claseDto
	 * @param methodName
	 * @return
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 * @throws IntrospectionException
	 */
	@SuppressWarnings("rawtypes")
	public Object getValue(Object dto, Class claseDto, String methodName)
			throws Exception;
	
	/**
	 * Traza en log solo en desarrollo
	 * 
	 * @param mensaje
	 */
	public void trace(String mensaje);

}
