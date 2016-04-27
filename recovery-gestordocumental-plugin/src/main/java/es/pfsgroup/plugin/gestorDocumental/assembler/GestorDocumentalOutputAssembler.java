package es.pfsgroup.plugin.gestorDocumental.assembler;

import es.pfsgroup.plugin.gestorDocumental.dto.OutputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.OUTPUT;

public class GestorDocumentalOutputAssembler {

	public static OutputDto outputToDto(OUTPUT output) {

		if (output == null) {
			return null;
		}

		OutputDto dto = new OutputDto();
		dto.setResultCode(output.getResultCode());
		dto.setResultDescription(output.getResultDescription());

		return dto;
	}

}
