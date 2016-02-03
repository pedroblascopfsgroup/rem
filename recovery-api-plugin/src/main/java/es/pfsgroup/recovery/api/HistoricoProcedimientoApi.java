package es.pfsgroup.recovery.api;

import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * BO de recovery para la gestión del histórico del procedimiento
 * @author bruno
 *
 */
public interface HistoricoProcedimientoApi {
	
	/**
     * getListByProcedimiento.
     * @param idProcedimiento idProcedimiento
     * @return HistoricoProcedimiento
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO)
    public List<HistoricoProcedimiento> getListByProcedimiento(Long idProcedimiento);

}
