package es.pfsgroup.plugin.rem.logTrust;

import java.util.Date;

import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.beans.Service;

@Service
public class LogTrustAcceso extends LogTrust {
	private static final String CODIGO_ACCION_INICIO_SESION = "inicio-sesion";


	public LogTrustAcceso() {
		super();
		logTrustLogger = LogFactory.getLog(LogTrustAcceso.class);
	}

	/**
	 * Este método obtiene los datos del usuario que inicia sesión para montar un registro para LogTrust.
	 */
	public void registrarAcceso() {
		StringBuilder builder = new StringBuilder();
		builder.append(sdf.format(new Date()));
		builder.append(SEPARADOR);
		builder.append(CODIGO_ACCION_INICIO_SESION);
		builder.append(SEPARADOR);
		builder.append(getUsernameUsuarioLogueado());
		builder.append(SEPARADOR);
		builder.append(getCodigoCarteraUsuarioLogueado());
		
		this.registrarMensaje(builder.toString());
	}
}
