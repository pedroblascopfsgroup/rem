package es.capgemini.pfs.exceptions;

import es.capgemini.devon.exception.FrameworkException;

/**
 * Excepción que SI debe lanzar un Rollback
 * @author pajimene
 *
 */
public class GenericRollbackException extends FrameworkException {
    private static final long serialVersionUID = 1L;

    /**
     * Constructor vacio.
     */
    protected GenericRollbackException() {
        super();
    }

    /**
     * Crea una excepción con un mensaje.
     * @param msg el mensaje
     * @param messageArgs argumentos
     */
    public GenericRollbackException(String msg, Object... messageArgs) {
        super(msg, messageArgs);
    }
}
