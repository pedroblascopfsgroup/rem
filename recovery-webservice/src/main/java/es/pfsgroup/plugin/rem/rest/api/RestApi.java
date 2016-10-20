package es.pfsgroup.plugin.rem.rest.api;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.ModelMap;

import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

public interface RestApi {

	public enum TIPO_VALIDACION {
		UPDATE, INSERT
	}

	public enum TRANSFORM_TYPE {
		NONE, BOOLEAN_TO_INTEGER, FLOAT_TO_BIGDECIMAL, DATE_TO_YEAR_INTEGER
	}

	public enum ALGORITMO_FIRMA {
		DEFAULT, NO_IP
	}

	public static final String CODE_ERROR = "ERROR";
	public static final String CODE_OK = "OK";
	public static final String REST_MSG_BROKER_NOT_EXIST = "BROKER_NOT_EXIST";
	public static final String REST_MSG_INVALID_SIGNATURE = "INVALID_SIGNATURE";
	public static final String REST_MSG_REPETEAD_REQUEST = "REPETEAD_REQUEST";
	public static final String REST_MSG_MISSING_REQUIRED_FIELDS = "MISSING_REQUIRED_FIELDS";
	public static final String REST_MSG_MISSING_REQUIRED = "REQUIRED";
	public static final String REST_MSG_INVALID_WORKINGCODE = "INVALID_WORKINGCODE";
	public static final String REST_MSG_UNKNOWN_KEY = "INVALID";
	public static final String REST_MSG_OVERFLOW = "OVERFLOW";
	public static final String REST_MSG_UNEXPECTED_ERROR = "UNEXPECTED_ERROR";
	public static final String REST_LOGGED_USER_USERNAME = "REST-USER";
	public static final String REM_LOGGED_USER_USERNAME = "REM-USER";
	public static final String REST_LOGGED_USER_USERNAME_FULL = "REST-USER";
	public static final Object REST_LOGGED_USER_EMPTY_PASSWORD = "";

	/**
	 * Valida la firma
	 * 
	 * @param ipClient
	 * @param signature
	 * @return
	 */
	public boolean validateSignature(Broker broker, String signature, String peticion,ALGORITMO_FIRMA algoritmoFirma)
			throws NoSuchAlgorithmException, UnsupportedEncodingException;

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
	public void sendResponse(HttpServletResponse response, ModelMap model);

	/**
	 * Crea un usuario ficticio. Los datos del usuario ficticio deberán existir
	 * en base de datos ya que en posteriores ejecuciones se accederá a ésta
	 * para login.
	 * 
	 * @param entidad
	 * @return
	 */
	public UsuarioSecurity loadUserRest(Entidad entidad);

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
	public PeticionRest crearPeticionObj(ServletRequest req);

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
	public ALGORITMO_FIRMA obtenerAlgoritmoFirma(String nombreServicio,String ipClient);

}
