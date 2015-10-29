package es.pfsgroup.plugin.recovery.mejoras.recurso.dto;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

/**
 * Hace uso de MEJRecurso en lugar de Recurso
 *
 */
public class MEJDtoRecurso extends WebDto {

    private static final long serialVersionUID = 1L;
    private Long idProcedimiento;
    private MEJRecurso recurso;

    /**
	 * @return the idProcedimiento
	 */
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	/**
	 * @param idProcedimiento the idProcedimiento to set
	 */
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	/**
	 * @return the recurso
	 */
	public MEJRecurso getRecurso() {
		return recurso;
	}

	/**
	 * @param recurso the recurso to set
	 */
	public void setRecurso(MEJRecurso recurso) {
		this.recurso = recurso;
	}

	/**
	 * poner javadoc FO.
	 * @param messageContext message
	 */
	public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();

        if ((recurso.getConfirmarVista() != null && recurso.getConfirmarVista()) && recurso.getFechaVista() == null) {
            messageContext.addMessage(new MessageBuilder().code("recursos.error.fechaVistaNula").error().source("").defaultText(
                    "**Debe introducir la fecha de la vista para el recurso.").build());
            //throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        if ((recurso.getConfirmarImpugnacion() != null && recurso.getConfirmarImpugnacion()) && recurso.getFechaImpugnacion() == null) {
            messageContext.addMessage(new MessageBuilder().code("recursos.error.fechaImpugnacionNula").error().source("").defaultText(
                    "**Debe introducir la fecha de la impugnación para el recurso.").build());
            //throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        if (recurso.getFechaResolucion() != null && recurso.getResultadoResolucion() == null) {
            messageContext.addMessage(new MessageBuilder().code("recursos.error.resultadoResolucionNulo").error().source("").defaultText(
                    "**Debe seleccionar un resultado para la resolución del recurso.").build());
            //throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        if (recurso.getFechaResolucion() == null && recurso.getResultadoResolucion() != null) {
            messageContext.addMessage(new MessageBuilder().code("recursos.error.fechaResolucionNula").error().source("").defaultText(
                    "**Debe seleccionar una fecha para la resolución del recurso.").build());
            //throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        addValidation(recurso, messageContext, "recurso").addValidation(this, messageContext).validate();
    }

}
