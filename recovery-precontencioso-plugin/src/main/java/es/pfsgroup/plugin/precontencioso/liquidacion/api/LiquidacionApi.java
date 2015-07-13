package es.pfsgroup.plugin.precontencioso.liquidacion.api;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;

public interface LiquidacionApi {

	/**
	 * Obtiene las liquidaciones de un procedimientoPCO
	 * 
	 * @param idProcedimientoPCO
	 * @return
	 */
	List<LiquidacionDTO> getLiquidacionesPorIdProcedimientoPCO(Long idProcedimientoPCO);

	/**
	 * Obtiene una liquidacion por id
	 * 
	 * @param idProcedimientoPCO
	 * @return 
	 */
	LiquidacionDTO getLiquidacionPorId(Long id);

	/**
	 * Confirma una liquidacion
	 * - Cambia el estado de una liquidacion a confirmada.
	 * 
	 * @param idProcedimientoPCO
	 */
	void confirmar(LiquidacionDTO liquidacionDto);

	/**
	 * Descarta una liquidacion
	 * - Cambia el estado de una liquidacion a descartada.
	 * 
	 * @param liquidacionDTO
	 */
	void descartar(LiquidacionDTO liquidacionDto);

	/**
	 * Solicita una liquidacion
	 * - Cambia el estado de una liquidacion a solicitada.
	 * - Borra los datos antiguos de la solicitud
	 * - Establece la fecha de cierre pasada por parametro
	 * - Establece la fecha de solicitud
	 * 
	 * @param liquidacionDTO
	 */
	void solicitar(LiquidacionDTO liquidacionDto);

	/**
	 * Edita una liquidacion
	 * 
	 * @param liquidacionDTO
	 */
	void editar(LiquidacionDTO liquidacionDto);
}
