package es.pfsgroup.recovery.cajamar.gestorDocumental.dto;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

public class AdjuntoGridAssembler {

	public static List<AdjuntoGridDto> outputDtoToAdjuntoGridDto (GestorDocumentalOutputDto outputDto) {

		if (outputDto == null) {
			return null;
		}
		SimpleDateFormat frmt = new SimpleDateFormat("ddMMyyyy");
		List<AdjuntoGridDto> list = new ArrayList<AdjuntoGridDto>();
		for(GestorDocumentalOutputListDto olDto : outputDto.getLbListadoDocumentos()) {
			AdjuntoGridDto dto = new AdjuntoGridDto();
			dto.setId(Long.parseLong(olDto.getIdDocumento()));
			dto.setNombre(olDto.getDescripcion()+"."+olDto.getExtFichero());
			dto.setContentType(olDto.getNombreTipoDoc());
			dto.setDescripcion(olDto.getDescripcion());
			dto.setLength("");
			dto.setFicheroBase64(outputDto.getFicheroBase64());
			dto.setTipo(olDto.getTipoDoc());
			try {
				dto.setAuditoria(new Auditoria());
				dto.getAuditoria().setFechaCrear(frmt.parse(olDto.getAltaVersion()));
			} catch (ParseException e) {
			}
			//TODO cual es el num Actuacion???
			dto.setNumActuacion(null);
			if (Checks.esNulo(olDto.getRefCentera())) {
				dto.setRefCentera(null);
			}else{
				dto.setRefCentera(olDto.getRefCentera());
			}
			dto.setDescripcionEntidad(olDto.getClaveRelacion());
			dto.setExtFichero(olDto.getExtFichero());
			list.add(dto);
		}

		return list;
	}
	
}
