package es.pfsgroup.plugin.recovery.liquidaciones.excepciones;

public class STAContabilidadException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final String COBROS_NO_ENVIADOS = "cobros_no_enviados_a_contabilizar";

	public STAContabilidadException() {
	}

	public STAContabilidadException(String message) {
		super(message);
	}

	public STAContabilidadException(Throwable cause) {
		super(cause);
	}

	public STAContabilidadException(String message, Throwable cause) {
		super(message, cause);
	}

}
