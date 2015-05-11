package es.capgemini.pfs.registro;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.registro.dao.HistoricoProcedimientoDao;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

/**
 * FALTA JAVADOC FO.
 * @author fo
 *
 */
@Service
public class HistoricoProcedimientoManager {
    @Autowired
    private HistoricoProcedimientoDao historicoProcedimientoDao;

    /**
     * getListByProcedimiento.
     * @param idProcedimiento idProcedimiento
     * @return HistoricoProcedimiento
     */
    @BusinessOperation(ExternaBusinessOperation.BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO)
    public List<HistoricoProcedimiento> getListByProcedimiento(Long idProcedimiento) {
        return historicoProcedimientoDao.getListByProcedimiento(idProcedimiento);
    }
}
