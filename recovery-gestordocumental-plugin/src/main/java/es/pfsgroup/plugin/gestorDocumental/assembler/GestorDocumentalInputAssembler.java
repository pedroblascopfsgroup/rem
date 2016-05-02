package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.InputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.ProcessEventRequestType;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.ProcessEventRequestType.Parameters;


/**
 * Clase que se encarga de ensablar liquidacionPCO entity a DTO.
 * 
 * @author jmartin
 */
public class GestorDocumentalInputAssembler {

	/**
	 * Convierte una entidad liquidacionPCO a un DTO
	 * 
	 * @param liquidacionesPCO entity
	 * @return liquidacionDTO DTO
	 */
	public static ProcessEventRequestType dtoToInput (InputDto inputDto) {

		if (inputDto == null) {
			return null;
		}

		ProcessEventRequestType input = new ProcessEventRequestType();
		input.setEventName(inputDto.getEvent());
		input.setParameters(getParameters(inputDto));
		
		return input;
	}
	
	private static Parameters getParameters(InputDto inputDto) {
		ProcessEventRequestType.Parameters parameters = new Parameters();
		if(InputDto.EVENTO_IDENTIFICADOR_ACTIVO_ORIGEN.equals(inputDto.getEvent())) {
			parameters.getParameter().add(getActivoOrigen(inputDto.getIdActivoOrigen()));
			parameters.getParameter().add(getOrigen(inputDto.getIdOrigen()));
		}
//		parameters.getParameter().add(getActivoHaya(inputDto.getIdActivoHaya()));
		return parameters;
	}
	
	private static KeyValuePair getActivoOrigen(String idActivoOrigen) {
		KeyValuePair activoOrigen = new KeyValuePair();
		activoOrigen.setCode(InputDto.ID_ACTIVO_ORIGEN);
		activoOrigen.setFormat(InputDto.FORMATO_STRING);
		activoOrigen.setValue(idActivoOrigen);
		return activoOrigen;
	}
	
	private static KeyValuePair getOrigen(String idOrigen) {
		KeyValuePair origen = new KeyValuePair();
		origen.setCode(InputDto.ID_ORIGEN);
		origen.setFormat(InputDto.FORMATO_STRING);
		origen.setValue(idOrigen);
		return origen;
	}
	
	private static KeyValuePair getActivoHaya(String idActivoHaya) {
		KeyValuePair activoHaya = new KeyValuePair();
		activoHaya.setCode(InputDto.ID_ACTIVO_HAYA);
		activoHaya.setFormat(InputDto.FORMATO_STRING);
		activoHaya.setValue(idActivoHaya);
		return activoHaya;
	}
}
