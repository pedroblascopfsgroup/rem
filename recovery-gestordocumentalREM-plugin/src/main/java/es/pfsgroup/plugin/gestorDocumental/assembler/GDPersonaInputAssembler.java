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
		if(PersonaInputDto.EVENTO_IDENTIFICADOR_INTERVINIENTE_ORIGEN.equals(inputDto.getEvent())) {
			parameters.getParameter().add(getIntervinienteOrigen(inputDto.getIdIntervinienteOrigen()));
			parameters.getParameter().add(getPersonaCliente2(inputDto.getIdOrigen()));
		}
		parameters.getParameter().add(getIntervinienteHaya(inputDto.getIdIntervinienteHaya()));
		return parameters;
	}
	
	private static KeyValuePair getIntervinienteOrigen(String idIntervinienteOrigen) {
		KeyValuePair intervinienteOrigen = new KeyValuePair();
		intervinienteOrigen.setCode(PersonaInputDto.ID_INTERVINIENTE_ORIGEN);
		intervinienteOrigen.setFormat(PersonaInputDto.FORMATO_STRING);
		intervinienteOrigen.setValue(idIntervinienteOrigen);
		return intervinienteOrigen;
	}
	
	private static KeyValuePair getPersonaCliente2(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(PersonaInputDto.ID_ORIGEN);
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
