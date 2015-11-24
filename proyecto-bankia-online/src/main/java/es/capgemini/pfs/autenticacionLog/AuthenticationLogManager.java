package es.capgemini.pfs.autenticacionLog;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.eventfactory.EventFactory;

@Component
public class AuthenticationLogManager implements AuthenticationLogApi {

	private String MARCA = "SGSID";
	private String SEPARADOR = "|";
	private String APLICACION = "PFS";
	private String TIPOIDENTIFICACION = "A"; // Identificacion con usuario SSA

	private static final String ACCION_LOGIN = "L"; // Login
	private static final String ACCION_LOGOUT = "O"; // Logout
	private static final String RESPUESTA_EXITOSA = "0000"; //Accion exitosa
	private static final String RESPUESTA_FALLIDA = "FFFF"; //Accion fallida

	@Autowired
	ClienteUDP udpClient;

	private enum TipoMensaje {
		LOGIN_OK, LOGIN_ERROR, LOGOUT
	};

	@Override
	@BusinessOperation(BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGIN)
	public void registrarLogin(String ipHost, String remoteIP, String username) {
		EventFactory.onMethodStart(this.getClass());
		String mensaje = prepararMensaje(TipoMensaje.LOGIN_OK, ipHost, username, remoteIP);
		udpClient.sendDatagram(mensaje);
		EventFactory.onMethodStop(this.getClass());
	}

	@Override
	@BusinessOperation(BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGIN_ERROR)
	public void registrarLoginError(String ipHost, String remoteIP,
			String username) {
		EventFactory.onMethodStart(this.getClass());
		String mensaje = prepararMensaje(TipoMensaje.LOGIN_ERROR, ipHost,
				username, remoteIP);
		udpClient.sendDatagram(mensaje);
		EventFactory.onMethodStop(this.getClass());
	}

	@Override
	@BusinessOperation(BO_CORE_AUTHENTICATION_LOG_REGISTRAR_LOGOUT)
	public void registrarLogout(String ipHost, String remoteIP, String username) {
		EventFactory.onMethodStart(this.getClass());
		String mensaje = prepararMensaje(TipoMensaje.LOGOUT, ipHost, username, remoteIP);
		udpClient.sendDatagram(mensaje);
		EventFactory.onMethodStop(this.getClass());
	}

	private String prepararMensaje(TipoMensaje tipo, String ipHost,
			String username, String remoteIP) {
		String resultado = MARCA + SEPARADOR + APLICACION + SEPARADOR;
		SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd|HHmmss");
		String fechaHora = dt.format(new Date());
		resultado = resultado + fechaHora + SEPARADOR;
		resultado = resultado + ipHost + SEPARADOR;
		switch (tipo) {
			case LOGIN_OK:
			case LOGIN_ERROR:
				resultado = resultado + ACCION_LOGIN + SEPARADOR;
				break;
			case LOGOUT:
				resultado = resultado + ACCION_LOGOUT + SEPARADOR;
		}
		resultado = resultado + SEPARADOR;
		resultado = resultado + username + SEPARADOR;
		resultado = resultado + SEPARADOR;
		resultado = resultado + SEPARADOR;
		resultado = resultado + remoteIP + SEPARADOR;
		resultado = resultado + SEPARADOR;
		resultado = resultado + SEPARADOR;
		resultado = resultado + TIPOIDENTIFICACION + SEPARADOR;
		switch (tipo) {
			case LOGIN_OK:
			case LOGOUT:
				resultado = resultado + RESPUESTA_EXITOSA + SEPARADOR;
				break;
			case LOGIN_ERROR:
				resultado = resultado + RESPUESTA_FALLIDA + SEPARADOR;
		}
		resultado = resultado + SEPARADOR + SEPARADOR + SEPARADOR + SEPARADOR + SEPARADOR;
		resultado = resultado + SEPARADOR + SEPARADOR + SEPARADOR + SEPARADOR + SEPARADOR;
		resultado = resultado + SEPARADOR + SEPARADOR + SEPARADOR;

		return resultado;
	}
}
