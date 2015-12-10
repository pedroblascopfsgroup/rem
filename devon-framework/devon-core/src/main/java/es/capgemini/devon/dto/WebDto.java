package es.capgemini.devon.dto;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.binding.message.Message;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.validation.BeanValidator;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.MessageContextErrors;
import es.capgemini.devon.validation.ValidationException;

/** 
 * @author amarinso
 *
 * <p>Este objeto nos ayuda con las validaciones de los campos mediante los m�todos</p>
 * <ul><li>addValidation</li>
 * <li>validate</li></ul>
 * 
 * Utiliza un objeto interno CompoundValidationObject para ir almacenando objetos que ser�n
 * validados con el m�todo validate. 
 * 
 * No se puede ir validando objeto a objeto porque la validaci�n lanza una excepci�n, y si
 * falla la primera validaci�n no se a�adir�an los mensajes de error del resto de validaciones
 *  
 */
public class WebDto extends AbstractDto {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public CompoundValidationObject addValidation(Object object, MessageContext messageContext, String prefix) {
        return new CompoundValidationObject(messageContext, new ObjectToValidate(object, prefix));
    }

    public CompoundValidationObject addValidation(Object object, MessageContext messageContext) {
        return new CompoundValidationObject(messageContext, new ObjectToValidate(object, null));
    }

    /*
     * Objeto compuesto que agrupa distintos objetos a validar junto con sus prefijos.
     * Al final de la composici�n se realizar� un validate() sobre este objeto que ser� el que
     * deber� lanzar una excepci�n en caso de error.
     */
    public class CompoundValidationObject {
        List<ObjectToValidate> objects = new ArrayList<ObjectToValidate>();
        MessageContext messageContext;

        public CompoundValidationObject(MessageContext messageContext, ObjectToValidate object) {
            this.messageContext = messageContext;
            objects.add(object);
        }

        public CompoundValidationObject addValidation(Object object, MessageContext messageContext, String prefix) {
            objects.add(new ObjectToValidate(object, prefix));
            return this;
        }

        public CompoundValidationObject addValidation(Object object, MessageContext messageContext) {
            objects.add(new ObjectToValidate(object, null));
            return this;
        }

        /**
         * Una vez tenemos un objeto creado, podemos llamar al m�todo validate que ser� el encargado
         * de realizar la validaci�n y lanzar una excepci�n con los errores que encontremos
         */
        public void validate() {
            List<Message> messages = new ArrayList<Message>();
            for (ObjectToValidate o : objects) {
                MessageContextErrors errors = new MessageContextErrors(messageContext, o.prefix);
                BeanValidator.getDefaultInstance().validate(o.object, errors);
                messages.addAll(Arrays.asList(messageContext.getAllMessages()));
            }

            //una vez obtenidos los mensajes ya nos hacemos cargo, y vaciamos el messageContext
            //si no, la proxima ejecuci�n seguir� lleno
            messageContext.clearMessages();
            if (messages.size() > 0) {
                throw new ValidationException(ErrorMessageUtils.convertMessages(messages));
            }

        }
    }

    //contenedor simple de un objeto a validar junto con su contexto y prefijo
    private class ObjectToValidate {
        Object object;
        String prefix;

        ObjectToValidate(Object object, String prefix) {
            this.object = object;
            this.prefix = prefix;
        }

        ObjectToValidate(Object object) {
            this(object, null);
        }
    }

}
