package es.pfsgroup.plugin.gestorDocumental.model.documentos;

public class RespuestaDocumentosExpedientes {

	/**
	 * Código del error
	 */
	private String codigoError;

	/**
	 * Mensaje del error
	 */
	private String mensajeError;

	/**
	 * Listado de los documentos del expediente
	 */
	private IdentificacionDocumento[] documentos;

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

	public IdentificacionDocumento[] getDocumentos() {
		return documentos;
	}

	public void setDocumentos(IdentificacionDocumento[] documentos) {
		this.documentos = documentos;
	}

}