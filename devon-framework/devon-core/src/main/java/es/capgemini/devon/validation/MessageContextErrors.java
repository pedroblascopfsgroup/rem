/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   MessageContextErrors.java
package es.capgemini.devon.validation;

import java.util.List;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.validation.AbstractErrors;
import org.springframework.validation.Errors;

/**
 * 
 * <p>Adapts a MessageContext object to the Spring Errors interface. Allows Spring Validators to record errors that are
 * managed by a backing MessageContext.</p>
 * 
 * <p>Para la validación de formularios que tienen objetos compuestos, necesitamos crear los  mensajes de error con el 
 * nombre de la propiedad precediendo el nombre del campo, para que ExtJS pueda pintar los errores. Es decir:</p>
 * 
 * <p>el DTO a usar tenemos</p>
 * 
 * <pre>class myDto{
 *   Usuario usuario;
 *   String criterio
 * }</pre>
 * 
 * <p>por tanto, los campos del objeto usuario se acceden mediante usuario.nombre, usuario.apellido... y si hay un 
 * error al validar estos campos, el error tiene que venir como 
 * 
 * <pre>errors : {
 *      'usuario.nombre' : 'el nombre no puede ser null', 
 *      'usuario.apellido' : 'no puede ser perez' 
 * }</pre>
 * 
 * así que introducimos el messageContext con un nuevo parámetro "prefix" que añadirá el nombre del campo a los errores
 * 
 * @see org.springframework.binding.message.MessageContextErrors
 * 
 */
public class MessageContextErrors extends AbstractErrors {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    private MessageContext messageContext;
    private String prefix; //prefijo para los objetos compuestos de un formulario

    /**
     * Creates a new message context errors adapter.
     * @param messageContext the backing message context
     */
    public MessageContextErrors(MessageContext messageContext) {
        this.messageContext = messageContext;

    }

    public MessageContextErrors(MessageContext messageContext, String prefix) {
        this.messageContext = messageContext;
        this.prefix = prefix;
    }

    public void reject(String errorCode, Object[] errorArgs, String defaultMessage) {
        messageContext.addMessage(new MessageBuilder().error().code(errorCode).args(errorArgs).defaultText(defaultMessage).build());
    }

    public void rejectValue(String field, String errorCode, Object[] errorArgs, String defaultMessage) {
        if (prefix != null && !"".equals(prefix)) field = prefix + "." + field;
        messageContext.addMessage(new MessageBuilder().error().source(field).code(errorCode).args(errorArgs).defaultText(defaultMessage).build());
    }

    public void addAllErrors(Errors errors) {
        throw new UnsupportedOperationException("Not expected to be called by a validator");
    }

    public List getFieldErrors() {
        throw new UnsupportedOperationException("Not expected to be called by a validator");
    }

    public Object getFieldValue(String field) {
        throw new UnsupportedOperationException("Not expected to be called by a validator");
    }

    public List getGlobalErrors() {
        throw new UnsupportedOperationException("Not expected to be called by a validator");
    }

    public String getObjectName() {
        throw new UnsupportedOperationException("Not expected to be called by a validator");
    }

}