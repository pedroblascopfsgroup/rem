package es.pfsgroup.plugin.gestorDocumental.model.documentos;

public class RespuestaCrearDocumento {

	/**
	 * Código del error
	 */
	private String codigoError;

	/**
	 * Mensaje del error
	 */
	private String mensajeError;

	/**
	 * DataID del documento creado
	 */
	private Integer idDocumento;
	

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

	public Integer getIdDocumento() {
		return idDocumento;
	}

	public void setIdDocumento(Integer idDocumento) {
		this.idDocumento = idDocumento;
	}

}