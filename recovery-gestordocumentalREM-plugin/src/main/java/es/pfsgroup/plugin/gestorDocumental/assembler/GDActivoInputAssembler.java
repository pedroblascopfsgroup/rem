package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.ProcessEventRequestType;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.ProcessEventRequestType.Parameters;


public class GDActivoInputAssembler {
	public static ProcessEventRequestType dtoToInputActivo (ActivoInputDto inputDto) {
		if (inputDto == null) {
			return null;
		}

		ProcessEventRequestType input = new ProcessEventRequestType();
		input.setEventName(inputDto.getEvent());
		input.setParameters(getParameters(inputDto));
		
		return input;
	}
	private static Parameters getParameters(ActivoInputDto inputDto) {
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
	
	private static KeyValuePair getIdCliente(String idCliente) {
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
	
	private static KeyValuePair getFechaOperacion(String fecha) {
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
	
	
	private static KeyValuePair getIdOrigen(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(ActivoInputDto.REM);
		origen.setFormat(ActivoInputDto.FORMATO_STRING);
		origen.setValue(idOrigen);
		return origen;
	}
	
	private static KeyValuePair getFlagMultiplicidad(String flag) {
		KeyValuePair multiplicidad = new KeyValuePair();
		multiplicidad.setCode(ActivoInputDto.FLAGMULTIPLICIDAD);
		multiplicidad.setFormat(ActivoInputDto.FORMATO_STRING);
		multiplicidad.setValue(flag);
		return multiplicidad;
	}
	
	private static KeyValuePair getMotivoOperacion(String motivo) {
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
