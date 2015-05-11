package es.capgemini.pfs.expediente.dto;

import java.util.regex.PatternSyntaxException;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;

/**
 * Dto para la inclusión y exclusión de contratos en un expediente.
 * @author marruiz
 */
public class DtoInclusionExclusionContratoExpediente extends WebDto {

	private static final long serialVersionUID = 8013156050334081644L;

	private Long idExpediente;
	private String contratos;


    /**
     * Valida el formulario.
     * @param messageContext MessageContext
     */
    public void validateBusquedaContrato(MessageContext messageContext) {
        messageContext.clearMessages();
        if((contratos==null || contratos.equals(""))) {
        	mensajeError(messageContext);
        }
        try {
        	String[] idsContratos = contratos.split(",");
        	if(idsContratos.length==0) {
        		mensajeError(messageContext);
        	}
        } catch(PatternSyntaxException e) {
        	mensajeError(messageContext);
        }
    }

    private void mensajeError(MessageContext messageContext) {
        messageContext.addMessage(new MessageBuilder().code("inclusionContratos.error.contratosNulos").error().source("").defaultText(
        "**Debe seleccionar al menos un contrato.").build());
        addValidation("", messageContext, "contratos").addValidation(this, messageContext).validate();
        throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
    }

	/**
	 * @return the idExpediente
	 */
	public Long getIdExpediente() {
		return idExpediente;
	}
	/**
	 * @param idExpediente the idExpediente to set
	 */
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	/**
	 * @return the contratos
	 */
	public String getContratos() {
		return contratos;
	}
	/**
	 * @param contratos the contratos to set
	 */
	public void setContratos(String contratos) {
		this.contratos = contratos;
	}
}
