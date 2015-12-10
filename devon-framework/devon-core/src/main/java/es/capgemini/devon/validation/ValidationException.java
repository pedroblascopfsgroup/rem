package es.capgemini.devon.validation;

import java.util.List;

import es.capgemini.devon.exception.FrameworkException;

/** Excepci�n producida al realizar la validaci�n. Contiene los mensajes de error
 * que puede recuperar con getMessages
 * @author amarinso
 *
 */
public class ValidationException extends FrameworkException {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    private List<ErrorMessage> messages;

    public ValidationException() {
        super("**Excepci�n al validar");
    }

    public ValidationException(List<ErrorMessage> messages) {
        this.setMessages(messages);
    }

    public void setMessages(List<ErrorMessage> messages) {
        this.messages = messages;
    }

    public List<ErrorMessage> getMessages() {
        return messages;
    }
}
