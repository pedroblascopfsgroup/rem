package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

public interface ProcedimientoPCODao extends AbstractDao<ProcedimientoPCO, Long> {
	
	ProcedimientoPCO getProcedimientoPcoPorIdProcedimiento(Long idProcedimiento);

}
