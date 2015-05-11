package es.pfsgroup.recovery.ext.api.tareas;

/**
 * Error al crear una tarea utilizando el API EXTTareasApi
 * @author bruno
 *
 */
public class EXTCrearTareaException extends Exception {
	
	
	private static final long serialVersionUID = 6321232696028601825L;
	public static final String ERR_CREAR_TAREA_USER_NOT_FOUND = "USER_NOT_FOUND";
	
	public EXTCrearTareaException(String motivoError) {
		super();
		this.motivoError = motivoError;
	}

	/**
	 * Devuelve el motivo por el que se ha producido el error. Es una de las constantes definidas en la clase
	 * @return
	 */
	public String getMotivoError() {
		return motivoError;
	}

	public void setMotivoError(String motivoError) {
		this.motivoError = motivoError;
	}

	private String motivoError;

}
