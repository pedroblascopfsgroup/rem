package es.pfsgroup.recovery.ext.impl.asunto.dto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.PluginCoreextensionConstantes;
import es.capgemini.pfs.asunto.dto.DtoAsunto;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.pfsgroup.commons.utils.Checks;

public class EXTDtoAsunto extends DtoAsunto{

	private static final long serialVersionUID = 3436085572440249212L;	
	
	private static final String ID_GESTOR_CONF_EXP_NULO = "altaAsunto.gestor_conf_exp.nulo";    //TODO: Hay que llevarlo al app.messages
    private static final String ID_SUPERVISOR_CONF_EXP_NULO_NULO = "altaAsunto.supervisor_conf_exp.nulo";
    private static final String ID_GESTORES_NO_AGREGADOS = "altaAsunto.gestores.vacio";

	private Long idGestorConfeccionExpediente;
	private Long idSupervisorConfeccionExpediente;
	private String tipoDespacho;
    private List<Map<String,Long>> listaGestoresId = new ArrayList<Map<String,Long>>();
    private String idGestorBorrado;
    private String idTipoGestorBorrado;
    
    
	
	

	public String getIdGestorBorrado() {
		return idGestorBorrado;
	}
	public void setIdGestorBorrado(String idGestorBorrado) {
		this.idGestorBorrado = idGestorBorrado;
	}
	public String getIdTipoGestorBorrado() {
		return idTipoGestorBorrado;
	}
	public void setIdTipoGestorBorrado(String idTipoGestorBorrado) {
		this.idTipoGestorBorrado = idTipoGestorBorrado;
	}
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
	
	public List<Map<String,Long>> getListaMapGestoresId() {
		return listaGestoresId;
	}
	
	public void setListaGestoresId(String listaGestoresId) {
		this.listaGestoresId.clear();
		listaGestoresId = listaGestoresId.replaceAll("\"", "");
		String[] gestores = listaGestoresId.split(";");
		
		for (String gestor : gestores) {
			if (!gestor.equals("")) {
				Map<String, Long> gestorIds = new HashMap<String, Long>();
				
				gestor = gestor.replaceAll("\\{", "").replaceAll("}", "");
				String[] ids = gestor.split(",");
				
				for (String id : ids) {
					String[] valores = id.split(":");
					
					gestorIds.put(valores[0], Long.parseLong(valores[1]));
				}
				
				this.listaGestoresId.add(gestorIds);
			}
		}
	}
	
	
	/**
     * Valida los par�metros.
     * @param context el contexto.
     */
    public void validateSaveAsunto(MessageContext context) {
        context.clearMessages();
       
        if (!Checks.esNulo(getTipoDespacho())) {
	        if(getTipoDespacho().equals(DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO)) {
	        	validateSaveAsuntoEXT(context);
	        } else {
	        	if(getTipoDespacho().equals( PluginCoreextensionConstantes.CODIGO_DESPACHO_CONFECCION_EXPEDIENTE))	{
	        		validateSaveAsuntoCEXP(context);
	        	} else {  // COMITE
	        		validateSaveAsuntoEXT(context);
	        		//validateSaveAsuntoCEXP(context);
	        	}
	        }	        
        } else {
        	validateSaveAsuntoEXT(context);
        }
        
        if (listaGestoresId.size() == 0) {
            context.addMessage(new MessageBuilder().code(ID_GESTORES_NO_AGREGADOS).error().source("altaAsunto.gestores.vacio").defaultText(
                    "**Debe agregar algún gestor para el asunto.").build());
        }
        
        
        if (context.getAllMessages().length > 0) { throw new ValidationException(ErrorMessageUtils.convertMessages(context.getAllMessages())); }
    }	
    
    private void validateSaveAsuntoEXT(MessageContext context)
    {
    	super.validateSaveAsunto(context);
    }
    
    private void validateSaveAsuntoCEXP(MessageContext context)
    {
    	if (idGestorConfeccionExpediente == null || idGestorConfeccionExpediente.longValue() == 0) {            
            context.addMessage(new MessageBuilder().code(ID_GESTOR_CONF_EXP_NULO).error().source("altaAsunto.gestor_conf_exp.nulo").defaultText(
                    "**Debe seleccionar un gestor de confecci�n de expediente.").build());
        }
        if (idSupervisorConfeccionExpediente == null || idSupervisorConfeccionExpediente.longValue() == 0) {
            context.addMessage(new MessageBuilder().code(ID_SUPERVISOR_CONF_EXP_NULO_NULO).error().source("altaAsunto.supervisor_conf_exp.nulo").defaultText(
                    "**Debe seleccionar un supervisor de confecci�n de expediente.").build());
        }        

        if (context.getAllMessages().length > 0) { throw new ValidationException(ErrorMessageUtils.convertMessages(context.getAllMessages())); }
    }

}