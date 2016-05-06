package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
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
		if(PersonaInputDto.EVENTO_IDENTIFICADOR_INTERVINIENTE_CLIENTE.equals(inputDto.getEvent())) {
			parameters.getParameter().add(getPersonaCliente(inputDto.getIdIntervinienteCliente()));
			parameters.getParameter().add(getPersonaCliente2(inputDto.getIdCliente()));
		}
		parameters.getParameter().add(getActivoHaya(inputDto.getIdIntervinienteHaya()));
		return parameters;
	}
	
	private static KeyValuePair getPersonaCliente(String idActivoOrigen) {
		KeyValuePair activoOrigen = new KeyValuePair();
		activoOrigen.setCode(PersonaInputDto.ID_PERSONA_CLIENTE);
		activoOrigen.setFormat(PersonaInputDto.FORMATO_STRING);
		activoOrigen.setValue(idActivoOrigen);
		return activoOrigen;
	}
	
	private static KeyValuePair getPersonaCliente2(String idActivoOrigen) {
		KeyValuePair activoOrigen = new KeyValuePair();
		activoOrigen.setCode(PersonaInputDto.ID_CLIENTE);
		activoOrigen.setFormat(PersonaInputDto.FORMATO_STRING);
		activoOrigen.setValue(idActivoOrigen);
		return activoOrigen;
	}
	
	private static KeyValuePair getActivoHaya(String idPersonaHaya) {
		KeyValuePair activoHaya = new KeyValuePair();
		activoHaya.setCode(ActivoInputDto.ID_ACTIVO_HAYA);
		activoHaya.setFormat(ActivoInputDto.FORMATO_STRING);
		activoHaya.setValue(idPersonaHaya);
		return activoHaya;
	}
}
