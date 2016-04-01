package es.pfsgroup.plugin.gestorDocumental.model.documentos;

public class RespuestaDescargarDocumento {

	/**
	 * Código del error
	 */
	private String codigoError;

	/**
	 * Mensaje del error
	 */
	private String mensajeError;

	/**
	 * Nombre del documento original en el gestor documental
	 */
	private String nombreDocumento;

	/**
	 * Contenido binario del documento
	 */
	private Byte[] contenido;

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

	public String getNombreDocumento() {
		return nombreDocumento;
	}

	public void setNombreDocumento(String nombreDocumento) {
		this.nombreDocumento = nombreDocumento;
	}

	public Byte[] getContenido() {
		return contenido;
	}

	public void setContenido(Byte[] contenido) {
		this.contenido = contenido;
	}

}