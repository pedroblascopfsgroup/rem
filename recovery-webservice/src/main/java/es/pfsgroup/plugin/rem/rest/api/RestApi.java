package es.pfsgroup.plugin.rem.rest.api;

import java.beans.IntrospectionException;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

public interface RestApi {

	public enum TIPO_VALIDCION {
		UPDATE, INSERT
	}

	public static final String CODE_ERROR = "ERROR";
	public static final String CODE_OK = "OK";
	public static final String REST_MSG_BROKER_NOT_EXIST = "BROKER_NOT_EXIST";
	public static final String REST_MSG_INVALID_SIGNATURE = "INVALID_SIGNATURE";
	public static final String REST_MSG_REPETEAD_REQUEST = "REPETEAD_REQUEST";
	public static final String REST_MSG_MISSING_REQUIRED_FIELDS = "MISSING_REQUIRED_FIELDS";
	public static final String REST_MSG_INVALID_WORKINGCODE = "INVALID_WORKINGCODE";
	public static final String REST_MSG_UNKNOWN_KEY = "UNKNOWN_KEY";
	public static final String REST_LOGGED_USER_USERNAME = "USER";
	public static final Object REST_LOGGED_USER_EMPTY_PASSWORD = "";

	/**
	 * Valida la firma
	 * 
	 * @param ipClient
	 * @param signature
	 * @return
	 */
	public boolean validateSignature(Broker broker, String signature, String peticion)
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
	public List<String> validateRequestObject(Serializable obj, TIPO_VALIDCION tipovalidacion);

	/**
	 * Valida el pojo pasado a la rest api
	 * 
	 * @param obj
	 * @return
	 */
	public List<String> validateRequestObject(Serializable obj);

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
	public String getClientIpAddr(HttpServletRequest request);

	@SuppressWarnings("rawtypes")
	public void saveDtoToBbdd(Object dto, Class entity)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException,
			ClassNotFoundException, InstantiationException, NoSuchMethodException, SecurityException;

}
