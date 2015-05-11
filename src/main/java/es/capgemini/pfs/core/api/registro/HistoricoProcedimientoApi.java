package es.capgemini.pfs.core.api.registro;

import java.util.List;

import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface HistoricoProcedimientoApi {
	
	public static final String TIPO_TAREA_PROCEDIMIENTO ="TareaProcedimiento";
	public static final String TIPO_PROPUESTA_DECISION = "PropuestaDecision";
	/**
     * getListByProcedimiento.
     * @param idProcedimiento idProcedimiento
     * @return HistoricoProcedimiento
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO)
    public List<HistoricoProcedimiento> getListByProcedimiento(Long idProcedimiento);

}
