package es.capgemini.pfs.exceptions;

import es.capgemini.devon.exception.UserException;

/**
 * Excepción que NO debe lanzar un Rollback por ser una excepción controlada
 * @author pajimene
 *
 */
public class NonRollbackException extends UserException {
    private static final long serialVersionUID = 1L;

    /**
     * Constructor vacio.
     */
    protected NonRollbackException() {
        super();
    }

    /**
     * Crea una excepción con un mensaje.
     * @param msg el mensaje
     * @param messageArgs argumentos
     */
    public NonRollbackException(String msg, Object... messageArgs) {
        super(msg, messageArgs);
    }
}
