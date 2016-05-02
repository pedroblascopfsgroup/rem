package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.InputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.OutputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.ProcessEventResponseType;


public class GestorDocumentalOutputAssembler {

	public static OutputDto outputToDto(ProcessEventResponseType output) {

		if (output == null) {
			return null;
		}

		OutputDto dto = new OutputDto();
		dto.setResultCode(output.getResultCode());
		dto.setResultDescription(output.getResultDescription());
		
		if(output.getParameters() != null) {
			for(KeyValuePair param : output.getParameters().getParameter()) {
				if(InputDto.ID_ACTIVO_HAYA.equals(param.getCode())) {
					dto.setIdActivoHaya(param.getValue());
				}else if(InputDto.ID_ACTIVO_ORIGEN.equals(param.getCode())) {
					dto.setIdActivoOrigen(param.getValue());
				}
			}
		}
		
		return dto;
	}

}
