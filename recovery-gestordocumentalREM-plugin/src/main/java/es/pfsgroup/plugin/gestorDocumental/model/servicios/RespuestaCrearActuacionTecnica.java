package es.pfsgroup.plugin.gestorDocumental.model.servicios;

public class RespuestaCrearActuacionTecnica {

	/**
	 * Código del error
	 */
	private String codigoError;

	/**
	 * Mensaje del error
	 */
	private String mensajeError;

	/**
	 * Identificador del trabajo creado (DataID)
	 */
	private Integer idTrabajo;
	

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

	public Integer getIdTrabajo() {
		return idTrabajo;
	}
	
	public void setIdTrabajo(Integer idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

}