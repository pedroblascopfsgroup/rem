package es.pfsgroup.recovery.cajamar.ws.gestordocumental;

import java.util.ArrayList;
import java.util.List;

import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.OUTPUT;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputDto;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputListDto;

public class GestorDocumentalOutputAssembler {

	public static List<OUTPUT> dtoToOutput(List<GestorDocumentalOutputDto> outputDto) {
		List<OUTPUT> outputs = new ArrayList<OUTPUT>();

		for (GestorDocumentalOutputDto dto : outputDto) {
			outputs.add(dtoToOutput(dto));
		}

		return outputs;
	}

	public static OUTPUT dtoToOutput (GestorDocumentalOutputDto outputDto) {

		if (outputDto == null) {
			return null;
		}

		OUTPUT output = new OUTPUT();
		output.setDESCESTADO(outputDto.getDescEstado());
		output.setESTADO(outputDto.getEstado());
		output.setFICHEROBASE64(outputDto.getFicheroBase64());
		output.setIDDOCUMENTO(outputDto.getIdDocumento());
		output.setCODERROR(outputDto.getCodError());
		output.setTXTERROR(outputDto.getTxtError());
		
		OUTPUT.LBLISTADODOCUMENTOS listaDoc = new OUTPUT.LBLISTADODOCUMENTOS();
		List<OUTPUT.LBLISTADODOCUMENTOS.Element> listElements = GestorDocumentalOutputListAssembler.dtoToOutputList(outputDto.getLbListadoDocumentos());
		for(OUTPUT.LBLISTADODOCUMENTOS.Element element : listElements){
			listaDoc.getElement().add(element);
		}
		
		output.setLBLISTADODOCUMENTOS(listaDoc);
	    
		return output;
	}
	
	public static GestorDocumentalOutputDto outputToDto (OUTPUT output) {

		if (output == null) {
			return null;
		}

		GestorDocumentalOutputDto dto = new GestorDocumentalOutputDto();
		dto.setDescEstado(output.getDESCESTADO());
		dto.setEstado(output.getESTADO());
		dto.setFicheroBase64(output.getFICHEROBASE64());
		dto.setIdDocumento(output.getIDDOCUMENTO());
		dto.setCodError(output.getCODERROR());
		dto.setTxtError(Checks.esNulo(output.getTXTERROR()) ? null : output.getTXTERROR());
		dto.setLbListadoDocumentos(new ArrayList<GestorDocumentalOutputListDto>());
		List<GestorDocumentalOutputListDto> listDto = GestorDocumentalOutputListAssembler.outputListToDtoList(output.getLBLISTADODOCUMENTOS().getElement());
		for(GestorDocumentalOutputListDto dtoAss : listDto){
			dto.getLbListadoDocumentos().add(dtoAss);
		}
		
		return dto;
	}
	
	
}
