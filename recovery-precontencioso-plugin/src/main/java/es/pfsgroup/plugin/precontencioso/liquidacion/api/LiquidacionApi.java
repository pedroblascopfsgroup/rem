package es.pfsgroup.plugin.precontencioso.liquidacion.api;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.InclusionLiquidacionProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

public interface LiquidacionApi {

	public static final String PRECONTENCIOSO_BO_PRC_INCLUIR_LIQUIDACION_AL_PROCEDIMIENTO = "es.pfsgroup.recovery.precontencioso.liquidacion.api.incluirLiquidacionAlProcedimiento";
	public static final String LIQUIDACION_PRECONTENCIOSO_BY_ID = "es.pfsgroup.recovery.precontencioso.liquidacion.api.getLiquidacionPCOById";

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
	 * Confirma una liquidacion por id
	 * 
	 * <ul>
	 * <li>Cambia el estado de una liquidacion a confirmada.
	 * </ul>
	 * 
	 * @param idProcedimientoPCO
	 */
	void confirmar(LiquidacionDTO liquidacionDto);

	/**
	 * Descarta una liquidacion por id
	 * 
	 * <ul>
	 * <li>Cambia el estado de una liquidacion a descartada.
	 * </ul>
	 * 
	 * @param liquidacionDTO
	 */
	void descartar(LiquidacionDTO liquidacionDto);

	/**
	 * Solicita una liquidacion por id
	 * 
	 * <ul>
	 * <li>Cambia el estado de una liquidacion a solicitada.
	 * </ul>
	 * 
	 * @param liquidacionDTO
	 */
	void solicitar(LiquidacionDTO liquidacionDto);

	/**
	 * Edita una liquidacion
	 * 
	 * @param liquidacionDTO
	 */
	void editarValoresCalculados(LiquidacionDTO liquidacionDto);
	
	/**
     * Incluye los contratos al expediente.
     * @param dto DtoExclusionContratoExpediente
     */
    @BusinessOperationDefinition(PRECONTENCIOSO_BO_PRC_INCLUIR_LIQUIDACION_AL_PROCEDIMIENTO)
    @Transactional(readOnly = false)
    public void incluirLiquidacionAlProcedimiento(InclusionLiquidacionProcedimientoDTO dto);
    
    @BusinessOperationDefinition(LIQUIDACION_PRECONTENCIOSO_BY_ID)
    LiquidacionPCO getLiquidacionPCOById(Long id);

    /**
     * Modifica el estado de la liquidación a visada y guarda la fecha de visado de la liquidación
     * 
     * @param liquidacionDto
     */
	void visar(LiquidacionDTO liquidacionDto);
	
	/**
	 * Obtiene el total de las liquidaciones PCO a partir del siguiente trámite al PCO
	 * 
	 * @param idProcedimiento
	 *            
	 * @return BigDecimal
	 */
	BigDecimal getTotalLiquidacion(Long idProcedimiento);
	
	/**
	 * Obtiene el total de la suma de las liquidaciones de un procedimientos precontencioso.
	 * 
	 * @param idProcedimiento
	 *            
	 * @return BigDecimal
	 */
	BigDecimal getTotalLiquidacionPCO(Long idProcedimientoPCO);

	/**
	 * Obtiene la liquidación de un contrato
	 * 
	 * @param cntId
	 * @return
	 */
	LiquidacionPCO getLiquidacionByCnt(Long cntId);

}
