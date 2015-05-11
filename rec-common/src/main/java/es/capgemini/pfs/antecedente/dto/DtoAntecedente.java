package es.capgemini.pfs.antecedente.dto;

import java.util.Date;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.antecedente.model.Antecedente;

/**
 * DTO para antecedentes y antecedentes.
 * @author Mariano Ruiz
 */
public class DtoAntecedente extends WebDto {

    private static final long serialVersionUID = 2142860382977602987L;

    private Antecedente antecedente;

    /**
     * @return the antecedente
     */
    public Antecedente getAntecedente() {
        return antecedente;
    }

    /**
     * @param antecedente the antecedente to set
     */
    public void setAntecedente(Antecedente antecedente) {
        this.antecedente = antecedente;
    }

    /**
     * Este método lo llamará automáticamente webflow cuando usemos el dto e intentemos
     * salir del estado con id="formulario".<br>
     * Se valida en dos partes:
     * <ul>
     * <li> los campos de este dto</li>
     * <li> los campos del objeto embebido 'antecedente'</li>
     * </ul>
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if (antecedente.getFechaVerificacion() == null) {
            messageContext.addMessage(new MessageBuilder().code("antecedente.error.carga").error().source("").defaultText(
                    "**Se deben completar todos los campos.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        if (antecedente.getFechaVerificacion().compareTo(new Date()) > 0) {
            messageContext.addMessage(new MessageBuilder().code("antecedente.error.fechaverif").error().source("").defaultText(
                    "**La fecha de verificación no puede ser mayor a la fecha actual.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        if (antecedente.getObservaciones() != null && antecedente.getObservaciones().length() > 250) {
            messageContext.addMessage(new MessageBuilder().code("error.limiteCaracteres.250").error().source("").defaultText(
                    "**No se puede guardar más de 250 carácteres para el campo de descripción/observación.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        addValidation(antecedente, messageContext, "antecedente").addValidation(this, messageContext).validate();
    }
}
