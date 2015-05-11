package es.capgemini.pfs.cobropago.dto;

import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.cobropago.model.CobroPago;

/**
 * Dto para CobroPago.
 * @author: Lisandro Medrano
 */
public class DtoCobroPago extends WebDto {

    private static final long serialVersionUID = 3727063960841411564L;
    private CobroPago cobroPago;
    private Long procedimiento;

    /**
     * Valida el dto para el estado formulario.
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        //TODO realizar validaciones
        addValidation(cobroPago, messageContext, "cobroPago").addValidation(this, messageContext).validate();
    }

    /**
     * @return the cobroPago
     */
    public CobroPago getCobroPago() {
        return cobroPago;
    }

    /**
     * @param cobroPago the cobroPago to set
     */
    public void setCobroPago(CobroPago cobroPago) {
        this.cobroPago = cobroPago;
    }

    /**
     * @return the procedimiento
     */
    public Long getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Long procedimiento) {
        this.procedimiento = procedimiento;
    }

}
