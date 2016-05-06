package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.ProcessEventRequestType;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.ProcessEventRequestType.Parameters;


/**
 * Clase que se encarga de ensablar liquidacionPCO entity a DTO.
 * 
 * @author jmartin
 */
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
		if(ActivoInputDto.EVENTO_IDENTIFICADOR_ACTIVO_ORIGEN.equals(inputDto.getEvent())) {
			parameters.getParameter().add(getActivoOrigen(inputDto.getIdActivoOrigen()));
			parameters.getParameter().add(getOrigen(inputDto.getIdOrigen()));
		}
		parameters.getParameter().add(getActivoHaya(inputDto.getIdActivoHaya()));
		return parameters;
	}	
	
	private static KeyValuePair getActivoOrigen(String idActivoOrigen) {
		KeyValuePair activoOrigen = new KeyValuePair();
		activoOrigen.setCode(ActivoInputDto.ID_ACTIVO_ORIGEN);
		activoOrigen.setFormat(ActivoInputDto.FORMATO_STRING);
		activoOrigen.setValue(idActivoOrigen);
		return activoOrigen;
	}
	
	private static KeyValuePair getOrigen(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(ActivoInputDto.ID_ORIGEN);
		origen.setFormat(ActivoInputDto.FORMATO_STRING);
		origen.setValue(idOrigen);
		return origen;
	}
	
	private static KeyValuePair getActivoHaya(String idActivoHaya) {
		KeyValuePair activoHaya = new KeyValuePair();
		activoHaya.setCode(ActivoInputDto.ID_ACTIVO_HAYA);
		activoHaya.setFormat(ActivoInputDto.FORMATO_STRING);
		activoHaya.setValue(idActivoHaya);
		return activoHaya;
	}
}
