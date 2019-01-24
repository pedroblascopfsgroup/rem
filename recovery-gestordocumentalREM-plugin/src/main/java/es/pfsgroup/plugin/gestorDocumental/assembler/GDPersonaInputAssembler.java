package es.pfsgroup.plugin.gestorDocumental.assembler;

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
	
	public static ProcessEventRequestType dtoToInputPersona (PersonaInputDto inputDto) {

		if (inputDto == null) {
			return null;
		}

		ProcessEventRequestType input = new ProcessEventRequestType();
		input.setEventName(inputDto.getEvent());
		
		if(!Checks.esNulo(inputDto.getIdMotivoOperacion()) || !Checks.esNulo(inputDto.getFechaOperacion()) ||
				!Checks.esNulo(inputDto.getIdTipoIdentificador()) || !Checks.esNulo(inputDto.getIdRol()) ||
				!Checks.esNulo(inputDto.getIdCliente()) || !Checks.esNulo(inputDto.getIdPersonaOrigen()) ||
				!Checks.esNulo(inputDto.getIdOrigen())) {
			input.setParameters(getParametersCrearPersona(inputDto));
		} else {
			input.setParameters(getParametersPersona(inputDto));
		}
		
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
			parameters.getParameter().add(getIdEntidadCedente(inputDto.getIdEntidadCedente()));
			parameters.getParameter().add(getPersonaCliente(inputDto.getIdPersonaCliente()));
			parameters.getParameter().add(getIdPersonaOrigen(inputDto.getIdPersonaOrigen()));
			parameters.getParameter().add(getMotivoOperacion(inputDto.getIdMotivoOperacion()));
			parameters.getParameter().add(getIdOrigen(inputDto.getIdOrigen()));
			parameters.getParameter().add(getIdTipoOrigen(inputDto.getIdTipoOrigen()));
			parameters.getParameter().add(getFechaOperacion(inputDto.getFechaOperacion()));
			parameters.getParameter().add(getTipoIdentificador(inputDto.getIdTipoIdentificador()));
			parameters.getParameter().add(getidPersonaHaya(inputDto.getIdPersonaHaya()));
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
	
	private static KeyValuePair getIdEntidadCedente(String idEntidadCedente) {
		KeyValuePair entidadCedente = new KeyValuePair();
		entidadCedente.setCode(PersonaInputDto.ID_ENTIDAD_CEDENTE);
		entidadCedente.setFormat(PersonaInputDto.FORMATO_STRING);
		entidadCedente.setValue(idEntidadCedente);
		return entidadCedente;
	}
	
	private static KeyValuePair getPersonaCliente(String persona_Cliente) {
		KeyValuePair personaCliente = new KeyValuePair();
		personaCliente.setCode(PersonaInputDto.ID_PERSONA_CLIENTE_ALTA);
		personaCliente.setFormat(PersonaInputDto.FORMATO_STRING);
		personaCliente.setValue(persona_Cliente);
		return personaCliente;
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
	
	private static KeyValuePair getIdTipoOrigen(String idTipoOrigen) {
		KeyValuePair tipoOrigen = new KeyValuePair();
		tipoOrigen.setCode(PersonaInputDto.ID_TIPO_ORIGEN);
		tipoOrigen.setFormat(PersonaInputDto.FORMATO_STRING);
		tipoOrigen.setValue(idTipoOrigen);
		return tipoOrigen;
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
	
	private static KeyValuePair getidPersonaHaya(String idPersonaHaya) {
		KeyValuePair personaHaya = new KeyValuePair();
		personaHaya.setCode(PersonaInputDto.ID_PERSONA_HAYA);
		personaHaya.setFormat(PersonaInputDto.FORMATO_STRING);
		personaHaya.setValue(idPersonaHaya);
		return personaHaya;
	}
	
	private static KeyValuePair getRol(String idRol) {
		KeyValuePair rol = new KeyValuePair();
		rol.setCode(PersonaInputDto.ID_ROL);
		rol.setFormat(PersonaInputDto.FORMATO_STRING);
		rol.setValue(idRol);
		return rol;
	}	
}
