package es.pfsgroup.plugin.gestorDocumental.model.servicios;

public class RespuestaBuscarExpediente {

	/**
	 * Código del error
	 */
	private String codigoError;

	/**
	 * Mensaje del error
	 */
	private String mensajeError;

	/**
	 * Identificador del expediente creado (DataID)
	 */
	private Integer idExpediente;
	

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

	public Integer getIdExpediente() {
		return idExpediente;
	}
	
	public void setIdExpediente(Integer idExpediente) {
		this.idExpediente = idExpediente;
	}

}