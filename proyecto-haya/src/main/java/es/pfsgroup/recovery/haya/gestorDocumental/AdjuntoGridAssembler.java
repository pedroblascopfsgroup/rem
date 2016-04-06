package es.pfsgroup.recovery.haya.gestorDocumental;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.gestorDocumental.model.documentos.IdentificacionDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

public class AdjuntoGridAssembler {
	
	private static final Log logger = LogFactory.getLog(AdjuntoGridAssembler.class);
	
	public static List<AdjuntoGridDto> outputDtoToAdjuntoGridDto (RespuestaDocumentosExpedientes documentosExp) {

		if (documentosExp == null) {
			return null;
		}
		List<AdjuntoGridDto> list = new ArrayList<AdjuntoGridDto>();
		for(IdentificacionDocumento olDto : documentosExp.getDocumentos()) {
			AdjuntoGridDto dto = new AdjuntoGridDto();
			dto.setId(new Long(olDto.getIdentificadorNodo()));
			list.add(dto);
		}

		return list;
	}
	
}
