package es.capgemini.devon.bo;

import es.capgemini.devon.exception.FrameworkException;

/** Excepción a lanzar cuando no se encuentra la operación de negocio
 * @author amarinso
 *
 */
public class BusinessOperationDefinitionNotFoundException extends FrameworkException {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    /**
     * @param messageKey
     * @param messageArgs
     */
    public BusinessOperationDefinitionNotFoundException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }

}
