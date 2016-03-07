package es.pfsgroup.plugin.precontencioso.observacion.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.plugin.precontencioso.obervacion.model.ObservacionPCO;
import es.pfsgroup.plugin.precontencioso.observacion.dto.ObservacionDTO;


public interface ObservacionApi {
	
	/**
	 * Obtiene las Observaciones de un ProcedimientoPCO
	 * 
	 * @param idProcedimientoPCO
	 * @return
	 */
	List<ObservacionDTO> getObservacionesPorIdProcedimientoPCO(Long idProcedimientoPCO);
	
	/**
	 * Guarda una observacion de un PCO
	 * @param dto
	 */
	@Transactional(readOnly = false)
	void guardarObservacion(ObservacionDTO dto);
	
	/**
	 * Devuelve una observacion por su id.
	 * @param idObservacionPCO
	 * @return
	 */
	ObservacionPCO getObservacionPCOById(Long idObservacionPCO);
	
	/**
	 * Borra una observacion desde su id.
	 * @param idObservacion
	 */
	@Transactional(readOnly = false)
	void borrarObservacion(Long idObservacion);

}
