package es.pfsgroup.plugin.precontencioso.liquidacion.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;

public interface LiquidacionDao extends AbstractDao<LiquidacionPCO, Long> {
	
	/**
	 * Obtiene las liquidaciones de un procedimientoPCO
	 * @param idProcedimientoPCO
	 * @return
	 */
	List<LiquidacionPCO> getLiquidacionesPorIdProcedimientoPCO(Long idProcedimientoPCO);
	
	/**
	 * Obtiene la liquidacion de un contrato
	 * @param idContrato
	 * @return
	 */
	LiquidacionPCO getLiquidacionDelContrato(Long idContrato, Long idProcPco);

}
