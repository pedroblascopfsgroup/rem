package es.pfsgroup.plugin.rem.activo.exception;

public class HistoricoTramitacionException extends Exception {

	private static final long serialVersionUID = 1L;

	public HistoricoTramitacionException ( String error ) {
		super (error);	
	}
	public HistoricoTramitacionException ( String error, Throwable cause) {
		super ( error, cause);
	}

	/*TEMPLATES*/
	public static String getErrorAlAnyadirRegistroAlTitulo ( String estadoPresentacion ) {
		return String.format("Ya existe un registro '%s', y está activo", estadoPresentacion);
	}
}
