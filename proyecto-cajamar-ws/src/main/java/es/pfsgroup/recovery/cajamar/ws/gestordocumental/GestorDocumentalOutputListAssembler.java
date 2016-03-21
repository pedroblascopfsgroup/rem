package es.pfsgroup.recovery.cajamar.ws.gestordocumental;

import java.util.ArrayList;
import java.util.List;

import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.OUTPUT;

import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputListDto;

public class GestorDocumentalOutputListAssembler {

	public static List<OUTPUT.LBLISTADODOCUMENTOS.Element> dtoToOutputList(List<GestorDocumentalOutputListDto> outputListDto) {
		List<OUTPUT.LBLISTADODOCUMENTOS.Element> outputs = new ArrayList<OUTPUT.LBLISTADODOCUMENTOS.Element>();

		for (GestorDocumentalOutputListDto dto : outputListDto) {
			outputs.add(dtoToOutputList(dto));
		}

		return outputs;
	}
	
	public static List<GestorDocumentalOutputListDto> outputListToDtoList(List<OUTPUT.LBLISTADODOCUMENTOS.Element> outputList) {
		List<GestorDocumentalOutputListDto> dto = new ArrayList<GestorDocumentalOutputListDto>();

		for (OUTPUT.LBLISTADODOCUMENTOS.Element output : outputList) {
			dto.add(outputListToDto(output));
		}

		return dto;
	}

	public static OUTPUT.LBLISTADODOCUMENTOS.Element dtoToOutputList (GestorDocumentalOutputListDto outputListDto) {

		if (outputListDto == null) {
			return null;
		}

		OUTPUT.LBLISTADODOCUMENTOS.Element outputElement = new OUTPUT.LBLISTADODOCUMENTOS.Element();
		outputElement.setTIPODOC(outputListDto.getTipoDoc());
		outputElement.setNOMBRETIPODOC(outputListDto.getNombreTipoDoc());
		outputElement.setDESCRIPCION(outputListDto.getDescripcion());
		outputElement.setALTAVERSION(outputListDto.getAltaVersion());
		outputElement.setVERSION(outputListDto.getVersion());
		outputElement.setALTARELACION(outputListDto.getAltaRelacion());
		outputElement.setENTIDAD(outputListDto.getEntidad());
		outputElement.setCENTRO(outputListDto.getCentro());
		outputElement.setMAESTRO(outputListDto.getMaestro());
		outputElement.setCLAVERELACION(outputListDto.getClaveRelacion());
		outputElement.setPERMACT(outputListDto.getPermact());
		outputElement.setFECHAVIG(outputListDto.getFechaVig());
		outputElement.setHIST(outputListDto.getHist());
		outputElement.setIDDOCUMENTO(outputListDto.getIdDocumento());
		outputElement.setCONSULTABILIDAD(outputListDto.getConsultabilidad());
		outputElement.setRETENIDO(outputListDto.getRetenido());
		outputElement.setEXTFICHERO(outputListDto.getExtFichero());
		outputElement.setESTADOSFD(outputListDto.getEstadosFd());
		outputElement.setREFCENTERA(outputListDto.getRefCentera());
	    
		return outputElement;
	}
	
	public static GestorDocumentalOutputListDto outputListToDto (OUTPUT.LBLISTADODOCUMENTOS.Element output) {

		if (output == null) {
			return null;
		}

		GestorDocumentalOutputListDto dto = new GestorDocumentalOutputListDto();
		dto.setTipoDoc(output.getTIPODOC());
		dto.setNombreTipoDoc(output.getNOMBRETIPODOC());
		dto.setDescripcion(output.getDESCRIPCION());
		dto.setAltaVersion(output.getALTAVERSION());
		dto.setVersion(output.getVERSION());
		dto.setAltaRelacion(output.getALTARELACION());
		dto.setEntidad(output.getENTIDAD());
		dto.setCentro(output.getCENTRO());
		dto.setMaestro(output.getMAESTRO());
		dto.setClaveRelacion(output.getCLAVERELACION());
		dto.setPermact(output.getPERMACT());
		dto.setFechaVig(output.getFECHAVIG());
		dto.setHist(output.getHIST());
		dto.setIdDocumento(output.getIDDOCUMENTO());
		dto.setConsultabilidad(output.getCONSULTABILIDAD());
		dto.setRetenido(output.getRETENIDO());
		dto.setExtFichero(output.getEXTFICHERO().toLowerCase());
		dto.setEstadosFd(output.getESTADOSFD());
		dto.setRefCentera(output.getREFCENTERA());
	    
		return dto;
	}
}
