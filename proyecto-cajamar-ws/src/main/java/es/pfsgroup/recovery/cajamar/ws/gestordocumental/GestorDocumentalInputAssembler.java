package es.pfsgroup.recovery.cajamar.ws.gestordocumental;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.INPUT;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalInputDto;

/**
 * Clase que se encarga de ensablar liquidacionPCO entity a DTO.
 * 
 * @author jmartin
 */
public class GestorDocumentalInputAssembler {

	/**
	 * Convierte varias entidades liquidacionPCO a un listado de DTO
	 * 
	 * @param List<liquidacionesPCO> entity
	 * @return List<liquidacionDTO> DTO
	 */
	public static List<INPUT> dtoToInput(List<GestorDocumentalInputDto> inputDto) {
		List<INPUT> inputs = new ArrayList<INPUT>();

		for (GestorDocumentalInputDto liquidacionPCO : inputDto) {
			inputs.add(dtoToInput(liquidacionPCO));
		}

		return inputs;
	}

	/**
	 * Convierte una entidad liquidacionPCO a un DTO
	 * 
	 * @param liquidacionesPCO entity
	 * @return liquidacionDTO DTO
	 */
	public static INPUT dtoToInput (GestorDocumentalInputDto inputDto) {

		if (inputDto == null) {
			return null;
		}

		SimpleDateFormat frmt = new SimpleDateFormat("ddMMyyyy");
		INPUT input = new INPUT();
		input.setAPLICACION(GestorDocumentalInputDto.APLICACION);
		input.setCLAVEASOCIACION(inputDto.getClaveAsociacion());
		input.setCLAVEASOCIACION2(inputDto.getClaveAsociacion2());
		input.setCLAVEASOCIACION3(inputDto.getClaveAsociacion3());
		input.setDESCRIPCION(inputDto.getDescripcion());
		input.setEXTENSIONFICHERO(inputDto.getExtensionFichero());
		if(!Checks.esNulo(inputDto.getFechaVigencia())) {
			input.setFECHAVIGENCIA(frmt.format(inputDto.getFechaVigencia()));			
		}
	    input.setFICHEROBASE64(inputDto.getFicheroBase64());
	    input.setLOCALIZADOR(inputDto.getLocalizador());
	    input.setOPERACION(inputDto.getOperacion());
		input.setORIGEN(inputDto.getOrigen());
		input.setRUTAFICHEROREMOTO(inputDto.getRutaFicheroRemoto());
		input.setTIPOASOCIACION(inputDto.getTipoAsociacion());
		input.setTIPOASOCIACION2(inputDto.getTipoAsociacion2());
		input.setTIPOASOCIACION3(inputDto.getTipoAsociacion3());
		input.setTIPODOCUMENTO(inputDto.getTipoDocumento());
	    
		return input;
	}
}
