package es.pfsgroup.plugin.gestorDocumental.assembler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.commons.utils.Checks;
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
	
	protected final static Log logger = LogFactory.getLog(GDPersonaInputAssembler.class);
	
	public static ProcessEventRequestType dtoToInputPersona (PersonaInputDto inputDto) {

		logger.error("Entrada en dtoToInputPersona");
		if (inputDto == null) {
			return null;
		}

		ProcessEventRequestType input = new ProcessEventRequestType();
		input.setEventName(inputDto.getEvent());
		
		if(!Checks.esNulo(inputDto.getIdMotivoOperacion()) && !Checks.esNulo(inputDto.getFechaOperacion()) &&
				!Checks.esNulo(inputDto.getIdTipoIdentificador()) && !Checks.esNulo(inputDto.getIdRol()) &&
				!Checks.esNulo(inputDto.getIdCliente()) && !Checks.esNulo(inputDto.getIdPersonaOrigen()) &&
				!Checks.esNulo(inputDto.getIdOrigen())) {
			logger.error("IF en dtoToInputPersona");
			input.setParameters(getParametersCrearPersona(inputDto));
		} else {
			input.setParameters(getParametersPersona(inputDto));
		}
		
		logger.error("RETURN:\n"+input);
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

	private static Parameters getParametersCrearPersona(PersonaInputDto inputDto) {
		ProcessEventRequestType.Parameters parameters = new Parameters();
		if(PersonaInputDto.EVENTO_ALTA_PERSONA.equals(inputDto.getEvent())) {
			parameters.getParameter().add(getIdCliente(inputDto.getIdCliente()));
			parameters.getParameter().add(getIdPersonaOrigen(inputDto.getIdPersonaOrigen()));
			parameters.getParameter().add(getMotivoOperacion(inputDto.getIdMotivoOperacion()));
			parameters.getParameter().add(getIdOrigen(inputDto.getIdOrigen()));
			parameters.getParameter().add(getFechaOperacion(inputDto.getFechaOperacion()));
			parameters.getParameter().add(getTipoIdentificador(inputDto.getIdTipoIdentificador()));
			parameters.getParameter().add(getRol(inputDto.getIdRol()));
		}
		return parameters;
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
	
	private static KeyValuePair getIdCliente(String idCliente) {
		KeyValuePair cliente = new KeyValuePair();
		cliente.setCode(PersonaInputDto.ID_CLIENTE);
		cliente.setFormat(PersonaInputDto.FORMATO_STRING);
		cliente.setValue(idCliente);
		return cliente;
	}
	
	private static KeyValuePair getIdPersonaOrigen(String idPersonaOrigen) {
		KeyValuePair personaOrigen = new KeyValuePair();
		personaOrigen.setCode(PersonaInputDto.ID_PERSONA_ORIGEN);
		personaOrigen.setFormat(PersonaInputDto.FORMATO_STRING);
		personaOrigen.setValue(idPersonaOrigen);
		return personaOrigen;
	}
	
	private static KeyValuePair getMotivoOperacion(String idMotivoOperacion) {
		KeyValuePair motivoOperacion = new KeyValuePair();
		motivoOperacion.setCode(PersonaInputDto.ID_MOTIVO_OPERACION);
		motivoOperacion.setFormat(PersonaInputDto.FORMATO_STRING);
		motivoOperacion.setValue(idMotivoOperacion);
		return motivoOperacion;
	}
	
	private static KeyValuePair getIdOrigen(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(PersonaInputDto.ID_ORIGEN_PERSONA);
		origen.setFormat(PersonaInputDto.FORMATO_STRING);
		origen.setValue(idOrigen);
		return origen;
	}
	
	private static KeyValuePair getFechaOperacion(String idFechaOperacion) {
		KeyValuePair fechaOperacion = new KeyValuePair();
		fechaOperacion.setCode(PersonaInputDto.FECHA_OPERACION);
		fechaOperacion.setFormat(PersonaInputDto.FORMATO_STRING);
		fechaOperacion.setValue(idFechaOperacion);
		return fechaOperacion;
	}
	
	private static KeyValuePair getTipoIdentificador(String idTipoIdentificador) {
		KeyValuePair tipoIdentificador = new KeyValuePair();
		tipoIdentificador.setCode(PersonaInputDto.ID_TIPO_IDENTIFICADOR);
		tipoIdentificador.setFormat(PersonaInputDto.FORMATO_STRING);
		tipoIdentificador.setValue(idTipoIdentificador);
		return tipoIdentificador;
	}
	
	private static KeyValuePair getRol(String idRol) {
		KeyValuePair rol = new KeyValuePair();
		rol.setCode(PersonaInputDto.ID_ROL);
		rol.setFormat(PersonaInputDto.FORMATO_STRING);
		rol.setValue(idRol);
		return rol;
	}	
}
