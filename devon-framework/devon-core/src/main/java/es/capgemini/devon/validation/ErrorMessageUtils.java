package es.capgemini.devon.validation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;

public class ErrorMessageUtils {

    /** 
     * Convierte los mensajes de error de org.springframework.binding.message a es.capgemini.devon.validation.Message
     *  
     * @param messages
     * @return
     */
    public static List<ErrorMessage> convertMessages(List<org.springframework.binding.message.Message> messages) {
        List<ErrorMessage> lista = new ArrayList<ErrorMessage>();
        for (org.springframework.binding.message.Message message : messages) {
            Severity severity = Severity.ERROR;
            if (message.getSeverity().equals(org.springframework.binding.message.Severity.WARNING)) {
                severity = Severity.WARNING;
            } else if (message.getSeverity().equals(org.springframework.binding.message.Severity.INFO)) {
                severity = Severity.INFO;
            }

            lista.add(new ErrorMessage(message.getSource(), message.getText(), severity));

        }
        return lista;
    }

    public static List<ErrorMessage> convertMessages(org.springframework.binding.message.Message[] messages) {
        return convertMessages(Arrays.asList(messages));
    }

    /**
     * @param messages
     * @return
     */
    public static List<ErrorMessage> convertFieldErrors(List<FieldError> fieldErrors, List<ObjectError> objectErrors) {
        List<ErrorMessage> lista = new ArrayList<ErrorMessage>();
        for (FieldError fieldError : fieldErrors) {
            lista.add(new ErrorMessage(fieldError.getField(), fieldError.getDefaultMessage(), Severity.ERROR));
        }
        for (ObjectError objectError : objectErrors) {
            lista.add(new ErrorMessage(objectError.getObjectName(), objectError.getDefaultMessage(), Severity.ERROR));
        }
        return lista;
    }

}
