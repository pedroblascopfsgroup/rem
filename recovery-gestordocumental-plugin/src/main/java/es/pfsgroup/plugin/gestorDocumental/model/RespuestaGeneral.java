package es.pfsgroup.plugin.gestorDocumental.model;

public class RespuestaGeneral {

	/**
	 * Código del error
	 */
	private String codigoError;
	
	/**
	 * Mensaje del error
	 */
	private String mensajeError;

	public String getCodigoError() {
		return codigoError;
	}

	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}

	public String getMensajeError() {
		return mensajeError;
	}

	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}

}