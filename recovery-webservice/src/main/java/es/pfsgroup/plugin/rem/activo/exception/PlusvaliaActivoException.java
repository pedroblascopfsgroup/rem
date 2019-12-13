package es.pfsgroup.plugin.rem.activo.exception;

public class PlusvaliaActivoException extends Exception {

	private static final long serialVersionUID = 1L;

	public PlusvaliaActivoException ( String error ) {
		super (error);	
	}
	public PlusvaliaActivoException ( String error, Throwable cause) {
		super ( error, cause);
	}

	/*TEMPLATES*/
	public static String getErrorNoExisteEstadoDeGestionPorCodigo ( String codigo ) {
		return String.format("No existe ningún estado con el código %s", codigo);
	}
}
