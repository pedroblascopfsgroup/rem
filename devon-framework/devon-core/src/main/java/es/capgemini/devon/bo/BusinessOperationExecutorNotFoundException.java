package es.capgemini.devon.bo;

import es.capgemini.devon.exception.FrameworkException;

/** Excepción a lanzar cuando no se encuentra la operación de negocio
 * @author amarinso
 *
 */
public class BusinessOperationExecutorNotFoundException extends FrameworkException {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    /**
     * @param messageKey
     * @param messageArgs
     */
    public BusinessOperationExecutorNotFoundException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }

}
