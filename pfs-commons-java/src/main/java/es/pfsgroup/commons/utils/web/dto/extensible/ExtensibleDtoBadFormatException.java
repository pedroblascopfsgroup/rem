package es.pfsgroup.commons.utils.web.dto.extensible;

/**
 * Esta excepción se produce si el formato de los parámetros no es el correcto.
 * 
 * @author bruno
 * 
 */
public class ExtensibleDtoBadFormatException extends RuntimeException {
    
    private static final long serialVersionUID = -1182883471706946058L;

    public ExtensibleDtoBadFormatException(String params) {
        super("Bad format in params string [" + params + "]");
    }

}
