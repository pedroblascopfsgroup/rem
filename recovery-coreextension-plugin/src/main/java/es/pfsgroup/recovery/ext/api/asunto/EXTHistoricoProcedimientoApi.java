package es.pfsgroup.recovery.ext.api.asunto;

import java.util.List;

import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EXTHistoricoProcedimientoApi {

	
	String BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO_EXT = "es.pfsgroup.plugin.recovery.coreextension.api.historicoProcedimiento.getListByProcedimientoEXT";

	/**
     * getListByProcedimiento.
     * @param idProcedimiento idProcedimiento
     * @return HistoricoProcedimiento
     */
    @BusinessOperationDefinition(BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO_EXT)
    public List<EXTHistoricoProcedimiento> getListByProcedimientoEXT(Long idProcedimiento);
}
