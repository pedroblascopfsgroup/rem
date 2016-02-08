package es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;

public interface DatosLiquidacionDao {

	/**
	 * LQ04 - Recibos liquidacion
	 * 	
	 * @param idLiquidacion
	 * @return
	 */
	public List<RecibosLiqVO> getRecibosLiquidacion(Long idLiquidacion);

	/**
	 * LQ03 - Datos generales contrato
	 * 
	 * @param idLiquidacion
	 * @return
	 */
	public List<DatosGeneralesLiqVO> getDatosGeneralesContratoLiquidacion(Long idLiquidacion);

	/**
	 * LQ07 - Intereses contrato liquidacion
	 * 
	 * @param idLiquidacion
	 * @return
	 */
	public List<InteresesContratoLiqVO> getInteresesContratoLiquidacion(Long idLiquidacion);

}
