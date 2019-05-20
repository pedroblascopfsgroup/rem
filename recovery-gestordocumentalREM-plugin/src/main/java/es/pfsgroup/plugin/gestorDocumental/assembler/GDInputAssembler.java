package es.pfsgroup.plugin.gestorDocumental.assembler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.ProcessEventRequestType;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.ProcessEventRequestType.Parameters;

/**
 * Clase que se encarga de ensablar liquidacionPCO entity a DTO.
 * 
 * @author jmartin
 */
public class GDInputAssembler {
	
	protected final static Log logger = LogFactory.getLog(GDInputAssembler.class);
	
	public static ProcessEventRequestType dtoToInput(Object inputDto) {
		if (inputDto == null) {
			return null;
		}
		ProcessEventRequestType input = new ProcessEventRequestType();
		
		if (inputDto instanceof PersonaInputDto) {
			inputDto = (PersonaInputDto)inputDto;
			input.setEventName(((PersonaInputDto) inputDto).getEvent());
			if(!Checks.esNulo(((PersonaInputDto) inputDto).getIdMotivoOperacion()) && !Checks.esNulo(((PersonaInputDto) inputDto).getFechaOperacion()) 
			&& !Checks.esNulo(((PersonaInputDto) inputDto).getIdTipoIdentificador()) && !Checks.esNulo(((PersonaInputDto) inputDto).getIdRol())
			&& !Checks.esNulo(((PersonaInputDto) inputDto).getIdCliente()) && !Checks.esNulo(((PersonaInputDto) inputDto).getIdPersonaOrigen()) 
			&& !Checks.esNulo(((PersonaInputDto) inputDto).getIdOrigen())) {
				input.setParameters(getParametersCrearPersona(((PersonaInputDto) inputDto)));
			} else {
				input.setParameters(getParametersPersona(((PersonaInputDto) inputDto)));
			}
		}else if (inputDto instanceof ActivoInputDto) {
			input.setEventName(((ActivoInputDto) inputDto).getEvent());
			input.setParameters(getParametersActivo(((ActivoInputDto) inputDto)));
		}

		
		return input;
	}
	
	
	
	
	
	//PARAMETROS MAESTRO PERSONAS
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
			parameters.getParameter().add(getCliente(inputDto.getIdCliente()));
			parameters.getParameter().add(getIdPersonaOrigen(inputDto.getIdPersonaOrigen()));
			parameters.getParameter().add(getMotivoOperation(inputDto.getIdMotivoOperacion()));
			parameters.getParameter().add(getOrigen(inputDto.getIdOrigen()));
			parameters.getParameter().add(getFechaOperation(inputDto.getFechaOperacion()));
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
	
	
	
	
	//PARAMETROS MAESTRO DE ACTIVOS
	private static Parameters getParametersActivo(ActivoInputDto inputDto) {
		ProcessEventRequestType.Parameters parameters = new Parameters();
		if(ActivoInputDto.EVENTO_ALTA_ACTIVOS.equals(inputDto.getEvent())) {
			parameters.getParameter().add(getIdHayaActivoMatriz(inputDto.getIdActivoMatriz()));
			parameters.getParameter().add(getnumRemActivoMatriz(inputDto.getNumRemActivoMatriz()));
			parameters.getParameter().add(getIdCliente(inputDto.getIdCliente()));
			parameters.getParameter().add(getIdUnidadAlquilable(inputDto.getIdUnidadAlquilable()));
			parameters.getParameter().add(getFechaOperacion(inputDto.getFechaOperacion()));
			parameters.getParameter().add(getTipoActivo(inputDto.getTipoActivo()));
			parameters.getParameter().add(getIdOrigen(inputDto.getOrigen()));
			parameters.getParameter().add(getFlagMultiplicidad(inputDto.getFlagMultiplicidad()));
			parameters.getParameter().add(getMotivoOperacion(inputDto.getMotivoOperacion()));
			parameters.getParameter().add(getClaseActivo(null));
			parameters.getParameter().add(getIdActivoCliente(null));
			parameters.getParameter().add(getIdActivoOrigenReds(null));
			parameters.getParameter().add(getIdActivoOrigenCols(null));
			parameters.getParameter().add(getEntidadCedente(null));
		}
		return parameters;
	}	
	
	private static KeyValuePair getIdHayaActivoMatriz(String idActivoMatriz) {
		KeyValuePair activoMatriz = new KeyValuePair();
		activoMatriz.setCode(ActivoInputDto.ID_HAYA_ACTIVO_MATRIZ);
		activoMatriz.setFormat(ActivoInputDto.FORMATO_STRING);
		activoMatriz.setValue(idActivoMatriz);
		return activoMatriz;
	}
	
	private static KeyValuePair getnumRemActivoMatriz(String numRemActivoMatriz) {
		KeyValuePair numActivoMatriz = new KeyValuePair();
		numActivoMatriz.setCode(ActivoInputDto.ID_REM_ACTIVO_MATRIZ);
		numActivoMatriz.setFormat(ActivoInputDto.FORMATO_STRING);
		numActivoMatriz.setValue(numRemActivoMatriz);
		return numActivoMatriz;
	}
	
	private static KeyValuePair getCliente(String idCliente) {
		KeyValuePair cliente = new KeyValuePair();
		cliente.setCode(ActivoInputDto.ID_CLIENTE_ACTIVO_MATRIZ);
		cliente.setFormat(ActivoInputDto.FORMATO_STRING);
		cliente.setValue(idCliente);
		return cliente;
	}
	
	private static KeyValuePair getIdUnidadAlquilable(String idUnidadAlquilable) {
		KeyValuePair numUnidadAlquilable = new KeyValuePair();
		numUnidadAlquilable.setCode(ActivoInputDto.ID_REM_UNIDAD_ALQUILABLE);
		numUnidadAlquilable.setFormat(ActivoInputDto.FORMATO_STRING);
		numUnidadAlquilable.setValue(idUnidadAlquilable);
		return numUnidadAlquilable;
	}
	
	private static KeyValuePair getFechaOperation(String fecha) {
		KeyValuePair fechaOperacion = new KeyValuePair();
		fechaOperacion.setCode(ActivoInputDto.FC_ALTA);
		fechaOperacion.setFormat(ActivoInputDto.FORMATO_STRING);
		fechaOperacion.setValue(fecha);
		return fechaOperacion;
	}
	
	private static KeyValuePair getTipoActivo(String tipoActivo) {
		KeyValuePair activo = new KeyValuePair();
		activo.setCode(ActivoInputDto.UNIDAD_ALQUILABLE);
		activo.setFormat(ActivoInputDto.FORMATO_STRING);
		activo.setValue(tipoActivo);
		return activo;
	}
	
	
	private static KeyValuePair getOrigen(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(ActivoInputDto.REM);
		origen.setFormat(ActivoInputDto.FORMATO_STRING);
		origen.setValue(idOrigen);
		return origen;
	}
	private static KeyValuePair getEntidadCedente(String entidadCedente) {
		KeyValuePair entidad = new KeyValuePair();
		entidad.setCode(ActivoInputDto.ENTIDAD_CEDENTE);
		entidad.setFormat(ActivoInputDto.FORMATO_STRING);
		entidad.setValue(entidadCedente);
		return entidad;
	}
	private static KeyValuePair getFlagMultiplicidad(String flag) {
		KeyValuePair multiplicidad = new KeyValuePair();
		multiplicidad.setCode(ActivoInputDto.FLAGMULTIPLICIDAD);
		multiplicidad.setFormat(ActivoInputDto.FORMATO_STRING);
		multiplicidad.setValue(flag);
		return multiplicidad;
	}
	
	private static KeyValuePair getMotivoOperation(String motivo) {
		KeyValuePair operacion = new KeyValuePair();
		operacion.setCode(ActivoInputDto.MOTIVO_OPERACION);
		operacion.setFormat(ActivoInputDto.FORMATO_STRING);
		operacion.setValue(motivo);
		return operacion;
	}
	
	private static KeyValuePair getClaseActivo(String clase) {
		KeyValuePair activo = new KeyValuePair();
		activo.setCode(ActivoInputDto.CLASE_ACTIVO);
		activo.setFormat(ActivoInputDto.FORMATO_STRING);
		activo.setValue(clase);
		return activo;
	}
	
	private static KeyValuePair getIdActivoCliente(String idActivoCliente) {
		KeyValuePair fechaOperacion = new KeyValuePair();
		fechaOperacion.setCode(ActivoInputDto.ACTIVO_CLIENTE);
		fechaOperacion.setFormat(ActivoInputDto.FORMATO_STRING);
		fechaOperacion.setValue(idActivoCliente);
		return fechaOperacion;
	}
	
	private static KeyValuePair getIdActivoOrigenReds(String idActivoOrigenReds) {
		KeyValuePair activo = new KeyValuePair();
		activo.setCode(ActivoInputDto.ACTIVO_ORIGEN_REDS);
		activo.setFormat(ActivoInputDto.FORMATO_STRING);
		activo.setValue(idActivoOrigenReds);
		return activo;
	}
	private static KeyValuePair getIdActivoOrigenCols(String idActivoOrigenCols) {
		KeyValuePair activo = new KeyValuePair();
		activo.setCode(ActivoInputDto.ACTIVO_ORIGEN_COLS);
		activo.setFormat(ActivoInputDto.FORMATO_STRING);
		activo.setValue(idActivoOrigenCols);
		return activo;
	}
}
