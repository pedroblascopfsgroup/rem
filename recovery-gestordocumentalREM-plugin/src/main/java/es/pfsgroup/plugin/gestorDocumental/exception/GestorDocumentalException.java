package es.pfsgroup.plugin.gestorDocumental.exception;

public class GestorDocumentalException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2496096133922346420L;
	
	public static final String CODIGO_ERROR_CONTENEDOR_NO_EXISTE = "-1";

	private String codigoError = null;
	
	public GestorDocumentalException(String mensajeError, String codigoError) {
		super(mensajeError);
		this.codigoError = codigoError;
	}
	public GestorDocumentalException(String mensajeError) {
		super(mensajeError);
	}

	public String getCodigoError() {
		return codigoError;
	}

	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}
	

}