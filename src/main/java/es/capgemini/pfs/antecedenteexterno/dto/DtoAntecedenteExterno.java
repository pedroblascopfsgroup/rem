package es.capgemini.pfs.antecedenteexterno.dto;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.antecedenteexterno.model.AntecedenteExterno;

/**
 * DTO para antecedentes y antecedentes externos.
 * @author Mariano Ruiz
 */
public class DtoAntecedenteExterno extends WebDto {

    private static final long serialVersionUID = 2142860382977601187L;

    private AntecedenteExterno antecedenteExterno;

    /**
     * @return the antecedente
     */
    public AntecedenteExterno getAntecedenteExterno() {
        return antecedenteExterno;
    }

    /**
     * @param antecedenteExterno the antecedente to set.
     */
    public void setAntecedenteExterno(AntecedenteExterno antecedenteExterno) {
        this.antecedenteExterno = antecedenteExterno;
    }

    /**
     * Validar formulario.
     * @param messageContext messageContext
     */
    public void validateFormularioNuevo(MessageContext messageContext) {
        validar(messageContext);
    }

    /**
     * Validar formulario.
     * @param messageContext messageContext
     */
    public void validateFormularioEditar(MessageContext messageContext) {
        validar(messageContext);
    }

    private void validar(MessageContext messageContext) {
        messageContext.clearMessages();
        if (antecedenteExterno.getFechaImpagos() == null && antecedenteExterno.getNumImpagos() != null) {
            messageContext.addMessage(new MessageBuilder().code("antecedenteexterno.error.fechaimpago").error().source("").defaultText(
                    "**Se debe ingresar la fecha del impago para poder ingresar el número de impagos.").build());
        }
        if (antecedenteExterno.getFechaIncidenciaJudicial() == null && antecedenteExterno.getNumIncidenciasJudiciales() != null) {
            messageContext.addMessage(new MessageBuilder().code("antecedenteexterno.error.fechaincidencias").error().source("").defaultText(
                    "**Se debe ingresar la fecha de incidencias para poder ingresar el número de incidencias.").build());
        }
        if (antecedenteExterno.getFechaIncidenciaJudicial() == null && antecedenteExterno.getFechaImpagos() == null) {
            messageContext.addMessage(new MessageBuilder().code("antecedenteexterno.error.carga").error().source("").defaultText(
                    "**Ninguna de las fechas de verificación están cargadas.").build());
        }

        //Comprobación eliminada por el cliente
        /*
        if (antecedenteExterno.getNumIncidenciasJudiciales() ==null ||
        	(antecedenteExterno.getNumIncidenciasJudiciales() !=null&& antecedenteExterno.getNumIncidenciasJudiciales()<1)){
            messageContext.addMessage(new MessageBuilder().code("antecedenteexterno.error.numeroincidencias").error().source("").defaultText(
                  "**El número de incidencias debe ser mayor a cero.").build());
        }
        if (antecedenteExterno.getNumImpagos() ==null ||
            	(antecedenteExterno.getNumImpagos() !=null&& antecedenteExterno.getNumImpagos()<1)){
            messageContext.addMessage(new MessageBuilder().code("antecedenteexterno.error.numeroimpagos").error().source("").defaultText(
                  "**El número de impagos debe ser mayor a cero.").build());
        }
        */
        addValidation(antecedenteExterno, messageContext, "antecedenteExterno").addValidation(this, messageContext).validate();
    }

}
