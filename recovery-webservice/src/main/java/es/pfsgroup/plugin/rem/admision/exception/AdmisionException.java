package es.pfsgroup.plugin.rem.admision.exception;

public class AdmisionException extends Exception {

	private static final long serialVersionUID = 1L;
	
	private static final String ACTIVO_NO_INFORMADO =  "No se ha informado el identificador del activo";
	private static final String ACTIVO_NO_EXISTE =  "El activo '%s', no existe";

	public AdmisionException ( String error ) {
		super (error);	
	}
	public AdmisionException ( String error, Throwable cause) {
		super ( error, cause);
	}

	/*TEMPLATES*/
	public static String getActivoNoInformado ( ) {
		return ACTIVO_NO_INFORMADO;
	}
	public static String getActivoNoExisteError ( String idActivo ) {
		return String.format(ACTIVO_NO_EXISTE, idActivo);
	}
}
