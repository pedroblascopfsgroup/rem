package es.capgemini.pfs.decisionProcedimiento.dto;

import java.util.List;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.util.AutoPopulatingList;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;

/**
 * Creado el Mon Jan 12 15:48:55 CET 2009.
 *
 * @author: Lisandro Medrano
 */
public class DtoDecisionProcedimiento extends WebDto {
    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -390516773716052924L;
    private DecisionProcedimiento decisionProcedimiento;
    private Long idProcedimiento;
    private String causaDecision;
    private String strEstadoDecision;
    private List<DtoProcedimientoDerivado> procedimientosDerivados;
    private Boolean finalizar;
    private Boolean paralizar;

    /**
     * constructor.
     */
    public DtoDecisionProcedimiento() {
        procedimientosDerivados = new AutoPopulatingList(DtoProcedimientoDerivado.class);
        paralizar = false;
        finalizar = false;
    }

    /**
     * Valida el form.
     *
     * @param messageContext
     *            messageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();

        if (paralizar || finalizar) {
            if (causaDecision == null || "".equals(causaDecision)) {
                messageContext.addMessage(new MessageBuilder().code("decisionProcedimiento.errores.causaNula").error().source("").defaultText(
                        "**Debe seleccionar una causa para la decisión.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }
        }

        // Causa = Paralizar y fecha null
        //if (DDCausaDecision.PARALIZAR.equals(causaDecision)) {
        if (paralizar) {
            if (decisionProcedimiento.getFechaParalizacion() == null) {
                messageContext.addMessage(new MessageBuilder().code("decisionProcedimiento.errores.fechaNula").error().source("").defaultText(
                        "**Debe seleccionar una fecha de fin de paralización.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }

        }
        // validar que haya al menos un procedimiento derivado
        // int counter = 0;
        for (DtoProcedimientoDerivado dtoP : procedimientosDerivados) {
            if (dtoP.getProcedimientoPadre() == null) {
                continue;
            }
            // counter++;
        }
        /*
         * if (counter == 0) { messageContext.addMessage(new
         * MessageBuilder().code
         * ("decisionProcedimiento.errores.procedimientosDerivados"
         * ).error().source("")
         * .defaultText("**Debe agregar al menos un procedimiento derivado."
         * ).build()); throw new
         * ValidationException(ErrorMessageUtils.convertMessages
         * (messageContext.getAllMessages())); }
         */
    }

    /**
     * @return the decisionProcedimiento
     */
    public DecisionProcedimiento getDecisionProcedimiento() {
        return decisionProcedimiento;
    }

    /**
     * @param decisionProcedimiento
     *            the decisionProcedimiento to set
     */
    public void setDecisionProcedimiento(DecisionProcedimiento decisionProcedimiento) {
        this.decisionProcedimiento = decisionProcedimiento;
    }

    /**
     * @return the idProcedimiento
     */
    public Long getIdProcedimiento() {
        return idProcedimiento;
    }

    /**
     * @param idProcedimiento
     *            the idProcedimiento to set
     */
    public void setIdProcedimiento(Long idProcedimiento) {
        this.idProcedimiento = idProcedimiento;
    }

    /**
     * @return the causaDecision
     */
    public String getCausaDecision() {
        return causaDecision;
    }

    /**
     * @param causaDecision
     *            the causaDecision to set
     */
    public void setCausaDecision(String causaDecision) {
        this.causaDecision = causaDecision;
    }

    /**
     * @return the procedimientosDerivados
     */
    public List<DtoProcedimientoDerivado> getProcedimientosDerivados() {
        return procedimientosDerivados;
    }

    /**
     * @param procedimientosDerivados
     *            the procedimientosDerivados to set
     */
    public void setProcedimientosDerivados(List<DtoProcedimientoDerivado> procedimientosDerivados) {
        this.procedimientosDerivados = procedimientosDerivados;
    }

    /**
     * @return the strEstadoDecision
     */
    public String getStrEstadoDecision() {
        return strEstadoDecision;
    }

    /**
     * @param strEstadoDecision the strEstadoDecision to set
     */
    public void setStrEstadoDecision(String strEstadoDecision) {
        this.strEstadoDecision = strEstadoDecision;
    }

    /**
     * @param finalizar the finalizar to set
     */
    public void setFinalizar(Boolean finalizar) {
        this.finalizar = finalizar;
    }

    /**
     * @return the finalizar
     */
    public Boolean getFinalizar() {
        return finalizar;
    }

    /**
     * @param paralizar the paralizar to set
     */
    public void setParalizar(Boolean paralizar) {
        this.paralizar = paralizar;
    }

    /**
     * @return the paralizar
     */
    public Boolean getParalizar() {
        return paralizar;
    }

}
