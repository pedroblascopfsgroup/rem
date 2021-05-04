package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class ComunicacionBoardingResponse implements Serializable {

	private static final long serialVersionUID = 1L;
	private boolean resultadoOK;
	private String mensaje;
	public static final String KO_ACTUALIZACION_OFERTA_BOARDING = "Error en el servicio de actualización de ofertas de Boarding.";
	public static final String OK_ACTUALIZACION_OFERTA_BOARDING = "Exito en el servicio de actualización de ofertas de Boarding.";
	
	
	public ComunicacionBoardingResponse(boolean resultadoOK,String mensaje ) {
		this.resultadoOK = resultadoOK;
		this.mensaje = mensaje;
	}


	public boolean getSuccess() {
		return resultadoOK;
	}


	public void setSuccess(boolean success) {
		this.resultadoOK = success;
	}


	public String getMensaje() {
		return mensaje;
	}


	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	
}
