package es.pfsgroup.recovery.api;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ProcedimientoDerivadoApi {

	
	 /**
     * get.
     * @param id id
     * @return pd
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_DERIVADO_MGR_GET)
    public ProcedimientoDerivado get(Long id);
}
