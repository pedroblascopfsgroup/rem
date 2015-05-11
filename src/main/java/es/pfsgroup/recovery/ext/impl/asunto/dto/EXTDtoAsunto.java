package es.pfsgroup.recovery.ext.impl.asunto.dto;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import com.sun.org.apache.xpath.internal.operations.Bool;

import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.PluginCoreextensionConstantes;
import es.capgemini.pfs.asunto.dto.DtoAsunto;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;

public class EXTDtoAsunto extends DtoAsunto{

	private static final long serialVersionUID = 3436085572440249212L;	
	
	private static final String ID_GESTOR_CONF_EXP_NULO = "altaAsunto.gestor_conf_exp.nulo";    //TODO: Hay que llevarlo al app.messages
    private static final String ID_SUPERVISOR_CONF_EXP_NULO_NULO = "altaAsunto.supervisor_conf_exp.nulo";

	private Long idGestorConfeccionExpediente;
	private Long idSupervisorConfeccionExpediente;
	private String tipoDespacho;
	
	public void setIdGestorConfeccionExpediente(
			Long idGestorConfeccionExpediente) {
		this.idGestorConfeccionExpediente = idGestorConfeccionExpediente;
	}
	public Long getIdGestorConfeccionExpediente() {
		return idGestorConfeccionExpediente;
	}
	public void setIdSupervisorConfeccionExpediente(
			Long idSupervisorConfeccionExpediente) {
		this.idSupervisorConfeccionExpediente = idSupervisorConfeccionExpediente;
	}
	public Long getIdSupervisorConfeccionExpediente() {
		return idSupervisorConfeccionExpediente;
	}
	
	public void setTipoDespacho(String tipoDespacho) {
		this.tipoDespacho = tipoDespacho;
	}
	public String getTipoDespacho() {
		return tipoDespacho;
	}
	
	/**
     * Valida los parámetros.
     * @param context el contexto.
     */
    public void validateSaveAsunto(MessageContext context) {
        context.clearMessages();
       
        if(getTipoDespacho().equals(DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO))
        	validateSaveAsuntoEXT(context);
        else
        	if(getTipoDespacho().equals( PluginCoreextensionConstantes.CODIGO_DESPACHO_CONFECCION_EXPEDIENTE))	
        		validateSaveAsuntoCEXP(context);
        	else  // COMITE
        	{
        		validateSaveAsuntoEXT(context);
        		//validateSaveAsuntoCEXP(context);
        	}
    }	
    
    private void validateSaveAsuntoEXT(MessageContext context)
    {
    	super.validateSaveAsunto(context);
    }
    
    private void validateSaveAsuntoCEXP(MessageContext context)
    {
    	if (idGestorConfeccionExpediente == null || idGestorConfeccionExpediente.longValue() == 0) {            
            context.addMessage(new MessageBuilder().code(ID_GESTOR_CONF_EXP_NULO).error().source("altaAsunto.gestor_conf_exp.nulo").defaultText(
                    "**Debe seleccionar un gestor de confección de expediente.").build());
        }
        if (idSupervisorConfeccionExpediente == null || idSupervisorConfeccionExpediente.longValue() == 0) {
            context.addMessage(new MessageBuilder().code(ID_SUPERVISOR_CONF_EXP_NULO_NULO).error().source("altaAsunto.supervisor_conf_exp.nulo").defaultText(
                    "**Debe seleccionar un supervisor de confección de expediente.").build());
        }        

        if (context.getAllMessages().length > 0) { throw new ValidationException(ErrorMessageUtils.convertMessages(context.getAllMessages())); }
    }

}