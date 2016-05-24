package es.pfsgroup.plugin.precontencioso.observacion.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.precontencioso.obervacion.model.ObservacionPCO;

public interface ObservacionDao extends AbstractDao<ObservacionPCO, Long> {
	
	/**
	 * Obtiene las Observaciones de un procedimientoPCO
	 * @param idProcedimientoPCO
	 * @return
	 */
	List<ObservacionPCO> getObservacionesPorIdProcedimientoPCO(Long idProcedimientoPCO);

}
