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
		parameters.getParameter().add(getPersonaOrigen(inputDto.getIdPersonaOrigen()));
		parameters.getParameter().add(getOrigen(inputDto.getIdOrigen()));
		parameters.getParameter().add(getCliente(inputDto.getIdCliente()));
		parameters.getParameter().add(getIdPersonaHaya(inputDto.getIdPersonaHaya()));
		return parameters;
	}
	
	private static KeyValuePair getPersonaOrigen(String idPersonaOrigen) {
		KeyValuePair personaOrigen = new KeyValuePair();
		personaOrigen.setCode(PersonaInputDto.ID_PERSONA_ORIGEN);
		personaOrigen.setFormat(PersonaInputDto.FORMATO_STRING);
		personaOrigen.setValue(idPersonaOrigen);
		return personaOrigen;
	}
	
	private static KeyValuePair getOrigen(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(PersonaInputDto.ID_ORIGEN);
		origen.setFormat(PersonaInputDto.FORMATO_STRING);
		origen.setValue(idOrigen);
		return origen;
	}
	
	private static KeyValuePair getCliente(String idCliente) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(PersonaInputDto.ID_CLIENTE);
		origen.setFormat(PersonaInputDto.FORMATO_STRING);
		origen.setValue(idCliente);
		return origen;
	}
	
	private static KeyValuePair getIdPersonaHaya(String idPersonaHaya) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(PersonaInputDto.ID_PERSONA_HAYA);
		origen.setFormat(PersonaInputDto.FORMATO_STRING);
		origen.setValue(idPersonaHaya);
		return origen;
	}
	
}
