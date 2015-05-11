package es.pfsgroup.plugin.recovery.masivo.api;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistItemResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoTareaAsuntoDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoTareaDto;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

public interface MSVHistoricoTareasApi {
	public static final String MSV_GET_HTCO_BY_TAR = "es.pfsgroup.plugin.recovery.masivo.api.getHistoricoPorTareas";
	public static final String MSV_GET_HTCO_BY_RES = "es.pfsgroup.plugin.recovery.masivo.api.getHistoricoPorResolucion";
	public static final String MSV_GET_HTCO_BY_TAR_ASU = "es.pfsgroup.plugin.recovery.masivo.api.getHistoricoPorTareasAsunto";
	public static final String MSV_GET_HTCO_BY_RES_ASU = "es.pfsgroup.plugin.recovery.masivo.api.getHistoricoPorResolucionAsunto";
	public static final String MSV_GET_TABS_HTCO_TAREAS_ASUNTO = "es.pfsgroup.plugin.recovery.masivo.api.getTabsAsunto";
	public static final String MSV_GET_TABS_HTCO_TAREAS_PROCEDIMIENTO = "es.pfsgroup.plugin.recovery.masivo.api.getTabsProcedimiento";
	public static final String MSV_GET_ITEMS_DETALLE_INPUT = "es.pfsgroup.plugin.recovery.masivo.api.getItemsDetalleInput";
		
	@BusinessOperationDefinition(MSV_GET_HTCO_BY_TAR)
	public List<MSVHistoricoTareaDto> getHistoricoPorTareas(Long idProcedimiento) throws IllegalAccessException, InvocationTargetException;
	
	@BusinessOperationDefinition(MSV_GET_HTCO_BY_RES)
	public List<MSVHistoricoResolucionDto> getHistoricoPorResolucion(Long idProcedimiento) throws IllegalAccessException, InvocationTargetException;
	
	@BusinessOperationDefinition(MSV_GET_HTCO_BY_TAR_ASU)
	public List<MSVHistoricoTareaAsuntoDto> getHistoricoPorTareasAsunto(Long idAsunto) throws IllegalAccessException, InvocationTargetException;
	
	@BusinessOperationDefinition(MSV_GET_HTCO_BY_RES_ASU)
	public List<MSVHistoricoResolucionDto> getHistoricoPorResolucionAsunto(Long idAsunto) throws IllegalAccessException, InvocationTargetException;
	
	@BusinessOperationDefinition(MSV_GET_ITEMS_DETALLE_INPUT)
    public List<MSVHistItemResolucionDto> getItemsDetalleInput(RecoveryBPMfwkInput input);

}
