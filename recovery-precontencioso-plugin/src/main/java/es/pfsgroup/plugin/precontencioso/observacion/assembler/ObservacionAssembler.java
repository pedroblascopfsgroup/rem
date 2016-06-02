package es.pfsgroup.plugin.precontencioso.observacion.assembler;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.obervacion.model.ObservacionPCO;
import es.pfsgroup.plugin.precontencioso.observacion.dto.ObservacionDTO;

/**
 * Clase que se encarga de ensablar observacionPCO entity a DTO.
 * 
 * @author jros
 */
public class ObservacionAssembler {

	/**
	 * Convierte varias entidades observacionPCO a un listado de DTO
	 * 
	 * @param List<observacionesPCO> entity
	 * @return List<observacionDTO> DTO
	 */
	public static List<ObservacionDTO> entityToDto(List<ObservacionPCO> listObservaciones) {
		
		List<ObservacionDTO> listObservacionesDto = new ArrayList<ObservacionDTO>();
		
		for(ObservacionPCO observacion : listObservaciones) {
			listObservacionesDto.add(entityToDto(observacion));
		}
		
		return listObservacionesDto;
	}
	
	/**
	 * Convierte una entidad ObservacionPCO a un DTO
	 * 
	 * @param ObservacionPCO entity
	 * @return observacionDto DTO
	 */
	public static ObservacionDTO entityToDto(ObservacionPCO observacion) {
	
		if(Checks.esNulo(observacion)) {
			return null;
		}
		
		ObservacionDTO observacionDto = new ObservacionDTO();
		
		observacionDto.setId(observacion.getId());
		observacionDto.setFechaAnotacion(observacion.getFechaAnotacion());
		observacionDto.setTextoAnotacion(observacion.getTextoAnotacion());
		observacionDto.setSecuenciaAnotacion(observacion.getSecuenciaAnotacion());
		
		//ProcedimientoPCO
		if(!Checks.esNulo(observacion.getProcedimientoPCO())) {
			observacionDto.setIdProcedimientoPCO(observacion.getProcedimientoPCO().getId());
		}
		
		//Usuario
		if(!Checks.esNulo(observacion.getUsuario())) {
			observacionDto.setIdUsuario(observacion.getUsuario().getId());
			observacionDto.setUsername(observacion.getUsuario().getUsername());
		}
		
		return observacionDto;
	}
	
}
