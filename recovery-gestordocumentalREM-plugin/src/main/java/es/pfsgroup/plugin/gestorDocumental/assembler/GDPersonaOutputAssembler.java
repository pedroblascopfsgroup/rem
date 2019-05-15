package es.pfsgroup.plugin.gestorDocumental.assembler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.KeyValuePair;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.ProcessEventResponseType;



public class GDPersonaOutputAssembler {
	
	private final static Log logger = LogFactory.getLog(GDPersonaOutputAssembler.class);
	public static PersonaOutputDto outputToDtoPersona(
			ProcessEventResponseType output) {

		if (output == null) {
			return null;
		}

		PersonaOutputDto dto = new PersonaOutputDto();
		dto.setResultCode(output.getResultCode());
		dto.setResultDescription(output.getResultDescription());

		if (output.getParameters() != null) {
			for (KeyValuePair param : output.getParameters().getParameter()) {
				if (PersonaInputDto.ID_INTERVINIENTE_HAYA.equals(param.getCode()) || PersonaInputDto.ID_PERSONA_HAYA.equals(param.getCode())) {
					dto.setIdIntervinienteHaya(param.getValue());
					break;
				} else {
					dto.setIdIntervinienteHaya(null);
				}
			}
		}

		return dto;
	}

}
