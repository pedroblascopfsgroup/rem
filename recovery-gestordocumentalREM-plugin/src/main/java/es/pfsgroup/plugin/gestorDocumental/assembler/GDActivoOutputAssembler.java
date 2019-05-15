package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.ProcessEventResponseType;


public class GDActivoOutputAssembler {

	public static ActivoOutputDto outputToDtoActivo(ProcessEventResponseType output) {

		if (output == null) {
			return null;
		}

		ActivoOutputDto dto = new ActivoOutputDto();
		dto.setResultCode(output.getResultCode());
		dto.setResultDescription(output.getResultDescription());
		if(output.getParameters() != null) {
			for(KeyValuePair param : output.getParameters().getParameter()) {
				if(ActivoInputDto.ID_ACTIVO_HAYA.equals(param.getCode())) {
					dto.setNumActivoUnidadAlquilable(String.valueOf(param.getValue()));
				}
			}
		}
		
		return dto;
	}
}
