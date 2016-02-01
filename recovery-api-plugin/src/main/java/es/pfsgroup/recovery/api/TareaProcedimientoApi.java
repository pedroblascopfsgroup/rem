package es.pfsgroup.recovery.api;

import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
public interface TareaProcedimientoApi {

	
	 /**
     * PONER JAVADOC FO.
     * @param idTipoProcedimiento id
     * @param codigoTarea codigo
     * @return tp
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_PROC_MGR_GET_BY_COD_TAREA_TIPO_PROC)
    public TareaProcedimiento getByCodigoTareaIdTipoProcedimiento(Long idTipoProcedimiento, String codigoTarea);
}
