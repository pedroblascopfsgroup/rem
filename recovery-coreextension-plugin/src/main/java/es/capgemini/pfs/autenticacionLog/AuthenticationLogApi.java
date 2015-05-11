package es.capgemini.pfs.autenticacionLog;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AuthenticationLogApi {

	String BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGIN = "es.capgemini.pfs.autenticacionLog.AuthenticationLogApi.registrarLogin";
	String BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGIN_ERROR = "es.capgemini.pfs.autenticacionLog.AuthenticationLogApi.registrarLoginError";
	String BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGOUT = "es.capgemini.pfs.autenticacionLog.AuthenticationLogApi.registrarLogout";

	/**
	 * registra en el log correspondiente el evento Login exitoso
	 * @param username 
	 * @param remoteIP 
	 * @param hostname 
	 */
	@BusinessOperationDefinition(BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGIN)
	public void registrarLogin(String ipHost, String remoteIP, String username);


	/**
	 * registra en el log correspondiente el evento Login erróneo
	 * @param username 
	 * @param remoteIP 
	 * @param hostname 
	 */
	@BusinessOperationDefinition(BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGIN_ERROR)
	public void registrarLoginError(String ipHost, String remoteIP, String username);


	/**
	 * registra en el log correspondiente el evento Logout exitoso
	 */
	@BusinessOperationDefinition(BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGOUT)
	public void registrarLogout(String ipHost, String remoteIP, String username);

}
