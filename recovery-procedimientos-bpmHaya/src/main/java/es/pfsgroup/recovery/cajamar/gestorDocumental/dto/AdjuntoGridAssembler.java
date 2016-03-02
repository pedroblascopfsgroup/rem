package es.pfsgroup.recovery.cajamar.gestorDocumental.dto;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

public class AdjuntoGridAssembler {
	
	private static final Log logger = LogFactory.getLog(AdjuntoGridAssembler.class);
	
	public static List<AdjuntoGridDto> outputDtoToAdjuntoGridDto (GestorDocumentalOutputDto outputDto) {

		if (outputDto == null) {
			return null;
		}
		SimpleDateFormat frmt = new SimpleDateFormat("ddMMyyyy");
		List<AdjuntoGridDto> list = new ArrayList<AdjuntoGridDto>();
		for(GestorDocumentalOutputListDto olDto : outputDto.getLbListadoDocumentos()) {
			AdjuntoGridDto dto = new AdjuntoGridDto();
			dto.setId(Long.parseLong(olDto.getIdDocumento()));
			dto.setContentType(olDto.getContentType());
			
			if(!Checks.esNulo(olDto.getDescripcion())) {			
				dto.setNombre(olDto.getDescripcion()+"."+olDto.getExtFichero());
				dto.setDescripcion(olDto.getDescripcion());
			}
			else {
				logger.warn("Método outputDtoToAdjuntoGridDto, el campo descripción está vacío");
				dto.setNombre(olDto.getNombreTipoDoc()+"."+olDto.getExtFichero());
				dto.setDescripcion(olDto.getNombreTipoDoc());
			}
			
			dto.setLength("");
			dto.setFicheroBase64(outputDto.getFicheroBase64());
			dto.setTipo(olDto.getTipoDoc());
			dto.setNombreTipoDoc(olDto.getNombreTipoDoc());
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
