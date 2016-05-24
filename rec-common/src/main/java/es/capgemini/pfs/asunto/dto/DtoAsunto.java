package es.capgemini.pfs.asunto.dto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.pfsgroup.commons.utils.Checks;

/**
 * Dto para asuntos.
 * 
 * @author pamuller
 *
 */
public class DtoAsunto extends WebDto {

    private static final long serialVersionUID = -5683288543951729381L;

    private static final String ID_GESTOR_NULO = "altaAsunto.gestor.nulo";
    private static final String NOMBRE_ASUNTO_NULO = "altaAsunto.nombreAsunto.nulo";
    private static final String ID_SUPERVISOR_NULO = "altaAsunto.supervisor.nulo";
    //private static final String OBSERVACIONES_NULO = "altaAsunto.observaciones.nulo";

    private Long idAsunto;

    private Long idGestor;

    private String nombreAsunto;

    private Long idExpediente;

    private Long idSupervisor;

    private String observaciones;

    private Long idProcurador;
    
    private String codigoEstadoAsunto;
    
    private Long tipoDeAsunto;

	/**
     * @return the idGestor
     */
    public Long getIdGestor() {
        return idGestor;
    }

    /**
     * @param idGestor the idGestor to set
     */
    public void setIdGestor(Long idGestor) {
        this.idGestor = idGestor;
    }

    /**
     * Valida los parámetros.
     * @param context el contexto.
     */
    public void validateSaveAsunto(MessageContext context) {
        context.clearMessages();
        
        /*
        if (idGestor == null || idGestor.longValue() == 0) {
            //ErrorMessage error = new ErrorMessage(this, ID_GESTOR_NULO,Severity.ERROR);
            context.addMessage(new MessageBuilder().code(ID_GESTOR_NULO).error().source("altaAsunto.gestor.nulo").defaultText(
                    "**Debe seleccionar un gestor.").build());
        }
        if (idSupervisor == null || idSupervisor.longValue() == 0) {
            //ErrorMessage error = new ErrorMessage(this, ID_GESTOR_NULO,Severity.ERROR);
            context.addMessage(new MessageBuilder().code(ID_SUPERVISOR_NULO).error().source("altaAsunto.supervisor.nulo").defaultText(
                    "**Debe seleccionar un supervisor.").build());
        }
        if (nombreAsunto == null || "".equals(nombreAsunto.trim())) {
            //ErrorMessage error = new ErrorMessage(this, ID_GESTOR_NULO,Severity.ERROR);
            context.addMessage(new MessageBuilder().code(NOMBRE_ASUNTO_NULO).error().source("altaAsunto.nombreAsunto.nulo").defaultText(
                    "**Debe ingresar un nombre para el asunto.").build());
        }
        */
        /*
        if (observaciones==null || "".equals(observaciones.trim())){
        	//ErrorMessage error = new ErrorMessage(this, ID_GESTOR_NULO,Severity.ERROR);
        	context.addMessage(new MessageBuilder().code(OBSERVACIONES_NULO).error()
        	    .source("altaAsunto.observaciones.nulo").defaultText("**Debe ingresar observaciones.").build());
        }
        */

        if (nombreAsunto != null && nombreAsunto.length() > 50) {
            context.addMessage(new MessageBuilder().code("altaAsunto.nombreAsunto.limite").error().source("").defaultText(
                    "**El nombre del asunto no debe exceder de 50 carácteres.").build());
        }
        
        if (observaciones != null && observaciones.length() > 1000) {
            context.addMessage(new MessageBuilder().code("altaAsunto.observaciones.limite").error().source("").defaultText(
                    "**Las observaciones del asunto no deben exceder de 1000 carácteres.").build());
        }
        
        if(Checks.esNulo(tipoDeAsunto)){
        	context.addMessage(new MessageBuilder().code("altaAsunto.tipoAsunto.requerido").error().source("").defaultText(
                    "**Debe indicar el tipo de asunto.").build());
        }

        if (context.getAllMessages().length > 0) { throw new ValidationException(ErrorMessageUtils.convertMessages(context.getAllMessages())); }

    }

    /**
     * @return the nombreAsunto
     */
    public String getNombreAsunto() {
        return nombreAsunto;
    }

    /**
     * @param nombreAsunto the nombreAsunto to set
     */
    public void setNombreAsunto(String nombreAsunto) {
        this.nombreAsunto = nombreAsunto;
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
     * @return the idSupervisor
     */
    public Long getIdSupervisor() {
        return idSupervisor;
    }

    /**
     * @param idSupervisor the idSupervisor to set
     */
    public void setIdSupervisor(Long idSupervisor) {
        this.idSupervisor = idSupervisor;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    /**
     * @return the idAsunto
     */
    public Long getIdAsunto() {
        return idAsunto;
    }

    /**
     * @param idAsunto the idAsunto to set
     */
    public void setIdAsunto(Long idAsunto) {
        this.idAsunto = idAsunto;
    }

    public Long getIdProcurador() {
        return idProcurador;
    }

    public void setIdProcurador(Long idProcurador) {
        this.idProcurador = idProcurador;
    }

	public String getCodigoEstadoAsunto() {
		return codigoEstadoAsunto;
	}

	public void setCodigoEstadoAsunto(String codigoEstadoAsunto) {
		this.codigoEstadoAsunto = codigoEstadoAsunto;
	}
	
	public Long getTipoDeAsunto() {
		return tipoDeAsunto;
	}

	public void setTipoDeAsunto(Long tipoDeAsunto) {
		this.tipoDeAsunto = tipoDeAsunto;
	}
}
