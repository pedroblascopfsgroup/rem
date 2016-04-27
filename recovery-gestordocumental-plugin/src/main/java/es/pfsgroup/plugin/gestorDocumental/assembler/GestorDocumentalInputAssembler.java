package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.InputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.INPUT;

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
	public static INPUT dtoToInput (InputDto inputDto) {

		if (inputDto == null) {
			return null;
		}

		INPUT input = new INPUT();
		input.setIdActivoOrigen(inputDto.getIdActivoOrigen());
		input.setIdOrigen(inputDto.getIdOrigen());
		input.setIdActivoHaya(inputDto.getIdActivoHaya());
	    
		return input;
	}
}
