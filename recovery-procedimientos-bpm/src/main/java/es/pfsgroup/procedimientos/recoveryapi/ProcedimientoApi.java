package es.pfsgroup.procedimientos.recoveryapi;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ProcedimientoApi {

	 /**
     * Devuelve un procedimiento a partir de su id.
     * @param idProcedimiento el id del proceimiento
     * @return el procedimiento
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO)
    public Procedimiento getProcedimiento(Long idProcedimiento);

}
