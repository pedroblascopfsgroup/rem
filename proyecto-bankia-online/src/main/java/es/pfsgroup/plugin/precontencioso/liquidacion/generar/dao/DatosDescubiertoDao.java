package es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DescubiertoLiqVO;

public interface DatosDescubiertoDao {

	/**
	 * EC05 - Captacion Extracto Liquidacion
	 * 	
	 * @param idLiquidacion
	 * @return
	 */
	public List<DescubiertoLiqVO> getDescubiertoLiquidacion(Long idLiquidacion);

}
