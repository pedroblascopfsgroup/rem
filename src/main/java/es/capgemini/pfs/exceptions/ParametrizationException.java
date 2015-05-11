package es.capgemini.pfs.exceptions;

/**
 * Exception que se usa cuando hay errores en la parametrización de un método.
 * @author pamuller
 *
 */
public class ParametrizationException extends NonRollbackException {

    /**
     *
     */
    private static final long serialVersionUID = -952672407300616106L;

    /**
     * Constructor vacio.
     */
    protected ParametrizationException() {
        super();
    }

    /**
     * Crea una excepción con un mensaje.
     * @param msg el mensaje
     * @param messageArgs argumentos
     */
    public ParametrizationException(String msg, Object... messageArgs) {
        super(msg, messageArgs);
    }
}
