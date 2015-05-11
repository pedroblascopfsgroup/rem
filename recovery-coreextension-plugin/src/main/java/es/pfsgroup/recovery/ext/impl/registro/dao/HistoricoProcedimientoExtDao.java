package es.pfsgroup.recovery.ext.impl.registro.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;

public interface HistoricoProcedimientoExtDao extends AbstractDao<EXTHistoricoProcedimiento, Long>{
	/**
     * FALTA JAVADOC FO.
     * @param idProcedimiento idProcedimiento
     * @return HistoricoProcedimiento
     */
    List<EXTHistoricoProcedimiento> getListByProcedimiento(Long idProcedimiento);
}
