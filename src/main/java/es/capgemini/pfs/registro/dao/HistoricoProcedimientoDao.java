package es.capgemini.pfs.registro.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

/**
 * FALTA JAVADOC FO.
 * @author FO
 *
 */
public interface HistoricoProcedimientoDao extends AbstractDao<HistoricoProcedimiento, Long> {
    /**
     * FALTA JAVADOC FO.
     * @param idProcedimiento idProcedimiento
     * @return HistoricoProcedimiento
     */
    List<HistoricoProcedimiento> getListByProcedimiento(Long idProcedimiento);
}
