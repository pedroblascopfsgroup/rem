package es.capgemini.pfs.exceptions;

import es.capgemini.devon.exception.UserException;

/**
 * Excepci�n que NO debe lanzar un Rollback por ser una excepci�n controlada
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
     * Crea una excepci�n con un mensaje.
     * @param msg el mensaje
     * @param messageArgs argumentos
     */
    public NonRollbackException(String msg, Object... messageArgs) {
        super(msg, messageArgs);
    }
}
