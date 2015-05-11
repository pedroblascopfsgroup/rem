package es.capgemini.pfs.asunto.dto;

import java.util.Date;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.asunto.model.Procedimiento;

/**
 * DTO para la recopilaci�n de la documentación del procedimiento.
 * @author marruiz
 */
public class DtoRecopilacionDocProcedimiento extends WebDto {

    private static final long serialVersionUID = 279749427545046390L;

    private Procedimiento procedimiento;


    /**
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }



    /**
     * Este m�todo lo llamar� autom�ticamente webflow cuando usemos el dto e intentemos
     * salir del estado con id="formulario".<br>
     * Se valida en dos partes:
     * <ul>
     * <li> los campos de este dto</li>
     * <li> los campos del objeto embebido 'procedimiento'</li>
     * </ul>
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if(procedimiento==null || procedimiento.getFechaRecopilacion()==null) {
            messageContext.addMessage(new MessageBuilder().code("procedimiento.documentacion.error.fechaRequerida").error().source("").defaultText(
                "**La fecha de recopilaci�n es requerida.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        } else if(procedimiento.getFechaRecopilacion().compareTo(new Date())>0) {
            messageContext.addMessage(new MessageBuilder().code("procedimiento.documentacion.error.fechaErronea").error().source("").defaultText(
                "**La fecha de recopilaci�n no puede ser mayor a la fecha actual.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
    }
}
