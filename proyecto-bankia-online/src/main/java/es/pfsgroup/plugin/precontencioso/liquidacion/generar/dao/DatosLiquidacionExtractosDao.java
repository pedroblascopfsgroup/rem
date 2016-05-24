package es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.CabeceraExpedienteLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.CabeceraLiquidacionLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.MovimientoLiquidacionLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;

public interface DatosLiquidacionExtractosDao {

	/**
	 * 113 - Cabecera expediente
	 * 	
	 * @param idLiquidacion
	 * @return
	 */
	public List<CabeceraExpedienteLiqVO> getCabeceraExpedienteLiquidacion(Long idLiquidacion);

	/**
	 * 115 - Cabecera liquidacion liquidacion
	 * 
	 * @param idLiquidacion
	 * @return
	 */
	public List<CabeceraLiquidacionLiqVO> getCabeceraLiquidacion(Long idLiquidacion);

	/**
	 * 117 - Movimientos liquidacion
	 * 
	 * @param idLiquidacion
	 * @return
	 */
	public List<MovimientoLiquidacionLiqVO> getMovimientoLiquidacion(Long idLiquidacion);

}
