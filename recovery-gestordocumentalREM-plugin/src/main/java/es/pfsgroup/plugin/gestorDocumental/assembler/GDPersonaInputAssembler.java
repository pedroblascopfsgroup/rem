package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.ProcessEventRequestType;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.ProcessEventRequestType.Parameters;

/**
 * Clase que se encarga de ensablar liquidacionPCO entity a DTO.
 * 
 * @author jmartin
 */
public class GDPersonaInputAssembler {
	
	public static ProcessEventRequestType dtoToInputPersona (PersonaInputDto inputDto) {

		if (inputDto == null) {
			return null;
		}

		ProcessEventRequestType input = new ProcessEventRequestType();
		input.setEventName(inputDto.getEvent());
		input.setParameters(getParametersPersona(inputDto));
		
		return input;
	}
		
	private static Parameters getParametersPersona(PersonaInputDto inputDto) {
		ProcessEventRequestType.Parameters parameters = new Parameters();
		if(PersonaInputDto.EVENTO_IDENTIFICADOR_PERSONA_ORIGEN.equals(inputDto.getEvent())) {
			parameters.getParameter().add(getPersonaOrigen(inputDto.getIdPersonaOrigen()));
			parameters.getParameter().add(getPersonaCliente2(inputDto.getIdCliente()));
		}
		parameters.getParameter().add(getIntervinienteHaya(inputDto.getIdIntervinienteHaya()));
		return parameters;
	}
	
	private static KeyValuePair getPersonaOrigen(String idPersonaOrigen) {
		KeyValuePair personaOrigen = new KeyValuePair();
		personaOrigen.setCode(PersonaInputDto.ID_PERSONA_ORIGEN);
		personaOrigen.setFormat(PersonaInputDto.FORMATO_STRING);
		personaOrigen.setValue(idPersonaOrigen);
		return personaOrigen;
	}
	
	private static KeyValuePair getPersonaCliente2(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(PersonaInputDto.ID_CLIENTE);
		origen.setFormat(PersonaInputDto.FORMATO_STRING);
		origen.setValue(idOrigen);
		return origen;
	}
	
	private static KeyValuePair getIntervinienteHaya(String idIntervinienteHaya) {
		KeyValuePair intervinienteHaya = new KeyValuePair();
		intervinienteHaya.setCode(PersonaInputDto.ID_INTERVINIENTE_HAYA);
		intervinienteHaya.setFormat(PersonaInputDto.FORMATO_STRING);
		intervinienteHaya.setValue(idIntervinienteHaya);
		return intervinienteHaya;
	}
}
