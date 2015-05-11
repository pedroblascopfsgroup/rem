package es.capgemini.pfs.persona.dto;

import java.util.Date;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.persona.model.Persona;

/**
 * @author Mariano Ruiz
 */
public class DtoSolvenciaPersona extends WebDto {

    private static final long serialVersionUID = 5555072711097336288L;

    private Persona persona;

    private Date fechaVerificacionAnterior;

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the fechaVerificacionAnterior
     */
    public Date getFechaVerificacionAnterior() {
        return fechaVerificacionAnterior;
    }

    /**
     * @param fechaVerificacionAnterior the fechaVerificacionAnterior to set
     */
    public void setFechaVerificacionAnterior(Date fechaVerificacionAnterior) {
        this.fechaVerificacionAnterior = fechaVerificacionAnterior;
    }

    /**
     * Este método lo llamará automáticamente webflow cuando usemos el dto e intentemos
     * salir del estado con id="formulario".<br>
     * Se valida en dos partes:
     * <ul>
     * <li> los campos de este dto</li>
     * <li> los campos del objeto embebido 'persona'</li>
     * </ul>
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if (persona.getFechaVerifSolvencia() == null
                || (persona.getFechaVerifSolvencia() != null && fechaVerificacionAnterior != null && persona.getFechaVerifSolvencia().compareTo(
                        fechaVerificacionAnterior) < 0)) {
            messageContext.addMessage(new MessageBuilder().code("solvencia.error.fechaverif").error().source("").defaultText(
                    "**La fecha de verificación no puede ser nula o menor a la cargada anteriormente.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        if (persona.getObservacionesSolvencia() != null && persona.getObservacionesSolvencia().length() > 100) {
            messageContext.addMessage(new MessageBuilder().code("solvencia.error.observaciones.limite").error().source("").defaultText(
                    "**Las observaciones de la solvencia no debe exceder de 100 carácteres.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        addValidation(persona, messageContext, "persona").addValidation(this, messageContext).validate();
    }
}
