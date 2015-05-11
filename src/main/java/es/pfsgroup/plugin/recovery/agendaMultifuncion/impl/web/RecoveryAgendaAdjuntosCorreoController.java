package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.recovery.api.ExpedienteApi;

@Controller
public class RecoveryAgendaAdjuntosCorreoController {
	
	 public static final String PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO_ENTIDAD = "plugin/agendaMultifuncion/json/consultaAdjuntosPorEntidadJSON";
	 public static final String PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO = "plugin/agendaMultifuncion/json/consultaAdjuntosJSON";
	 
	 
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	 public String consultaAdjuntos(Long id, ModelMap model) {
	        
			Asunto asunto=proxyFactory.proxy(AsuntoApi.class).get(id);
			model.put("entity", asunto);
			
	        return PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO;
	    }
	
	
	@RequestMapping
	 public String consultaAdjuntosPersona(Long id, ModelMap model) {
	        
			List<Persona> personasAsunto = proxyFactory.proxy(AsuntoApi.class).obtenerPersonasDeUnAsunto(id);
			List<Persona> personasConAdjunto=new ArrayList<Persona>();
			for (Persona p : personasAsunto){
				if (!Checks.esNulo(p.getAdjuntosAsList()) && !Checks.estaVacio(p.getAdjuntosAsList())){
					personasConAdjunto.add(p);
				}
			}
			model.put("entities", personasConAdjunto);
			
	        return PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO_ENTIDAD;
	    }
	
	@RequestMapping
	 public String consultaAdjuntosExpedientes(Long id, ModelMap model) {
	        
			List<Expediente> expedienteAsunto = proxyFactory.proxy(AsuntoApi.class).getExpedienteAsList(id);
			List<Expediente> expedientesConAdjuntos=new ArrayList<Expediente>();
			for(Expediente exp : expedienteAsunto){
				if (!Checks.esNulo(exp.getAdjuntosAsList()) && !Checks.estaVacio(exp.getAdjuntosAsList())){
					expedientesConAdjuntos.add(exp);
				}
			}
			model.put("entities", expedientesConAdjuntos);
			
	        return PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO_ENTIDAD;
	    }
	
	@RequestMapping
	 public String consultaAdjuntosContratos(Long id, ModelMap model) {
			Asunto asunto=proxyFactory.proxy(AsuntoApi.class).get(id);
		
			Set<Contrato> contratosAsunto =asunto.getContratos();
			List<Contrato> contratosConAdjuntos=new ArrayList<Contrato>();
			for(Contrato c : contratosAsunto){
				if (!Checks.esNulo(c.getAdjuntosAsList()) && !Checks.estaVacio(c.getAdjuntosAsList())){
					contratosConAdjuntos.add(c);
				}
			}
			model.put("entities", contratosConAdjuntos);
			
	        return PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO_ENTIDAD;
	    }
	
	@RequestMapping
	 public String consultaAdjuntosCliente(Long id, ModelMap model) {
	        
			Persona persona=proxyFactory.proxy(PersonaApi.class).get(id);
			model.put("entity", persona);
			
	        return PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO;
	    }
	
	@RequestMapping
	 public String consultaAdjuntosDelExpediente(Long id, ModelMap model) {
	        
			Expediente expediente=proxyFactory.proxy(ExpedienteApi.class).getExpediente(id);
			model.put("entity", expediente);
			
	        return PLUGIN_AGENDA_MULTIFUNCION_JSON_ADJUNTO;
	    }
	
	

}
