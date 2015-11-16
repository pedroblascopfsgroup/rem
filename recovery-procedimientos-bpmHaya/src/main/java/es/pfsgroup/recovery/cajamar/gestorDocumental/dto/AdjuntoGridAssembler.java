package es.pfsgroup.recovery.cajamar.gestorDocumental.dto;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

public class AdjuntoGridAssembler {

	public static List<AdjuntoGridDto> outputDtoToAdjuntoGridDto (GestorDocumentalOutputDto outputDto) {

		if (outputDto == null) {
			return null;
		}
		SimpleDateFormat frmt = new SimpleDateFormat("DDMMYYYY");
		List<AdjuntoGridDto> list = new ArrayList<AdjuntoGridDto>();
		for(GestorDocumentalOutputListDto olDto : outputDto.getLbListadoDocumentos()) {
			AdjuntoGridDto dto = new AdjuntoGridDto();
			dto.setIdAdjunto(Long.parseLong(olDto.getIdDocumento()));
			dto.setNombre(olDto.getClaveRelacion());
			dto.setTipoDocumento(olDto.getNombreTipoDoc());
			dto.setDescripcion(olDto.getDescripcion());
			dto.setTamanyo("");
			dto.setTipo(olDto.getTipoDoc());
			try {
				dto.setFechaSubida(frmt.parse(olDto.getAltaVersion()));
			} catch (ParseException e) {
			}
			//TODO cual es el num Actuacion???
			dto.setNumActuacion(null);
			dto.setRefCentera(olDto.getRefCentera());
			dto.setDescripcionEntidad(olDto.getClaveRelacion());
			list.add(dto);
		}

		return list;
	}
	
}
