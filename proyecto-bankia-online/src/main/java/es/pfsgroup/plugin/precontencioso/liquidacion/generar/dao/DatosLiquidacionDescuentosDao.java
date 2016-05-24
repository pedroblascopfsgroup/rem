package es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.EfectosLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.EntregasLiqVO;

public interface DatosLiquidacionDescuentosDao {

	/**
	 * LQ05 - Documentos efectos liquidacion
	 * 	
	 * @param idLiquidacion
	 * @return
	 */
	public List<EfectosLiqVO> getEfectosLiquidacion(Long idLiquidacion, String condicion);

	/**
	 * LQ06 - Entregas cuentas liquidacion
	 * 
	 * @param idLiquidacion
	 * @return
	 */
	public List<EntregasLiqVO> getEntregasCuentasLiquidacion(Long idLiquidacion);

}
