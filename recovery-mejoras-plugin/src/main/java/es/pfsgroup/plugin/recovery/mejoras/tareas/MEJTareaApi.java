package es.pfsgroup.plugin.recovery.mejoras.tareas;

import java.util.List;

import es.capgemini.devon.web.DynamicElement;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

public interface MEJTareaApi {

	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_TAREAS_PTES_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsTareasPendientesRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_TAREAS_PTES_BUTTONS_LEFT)
	List<DynamicElement> getButtonsTareasPendientesLeft();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_PANEL_TAREAS_BUTTONS_LEFT)
	List<DynamicElement> getButtonsPanelTareasLeft();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_TAREAS_PTES_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsPanelTareasRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_TAR_ESPERA_BUTTONS_LEFT)
	List<DynamicElement> getButtonsTareasEsperaLeft();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_TAR_ESPERA_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsTareasEsperaRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_NOTIFICACION_BUTTONS_LEFT)
	List<DynamicElement> getButtonsNotificacionLeft();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_NOTIFICACION_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsNotificacionRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_ALERTAS_BUTTONS_LEFT)
	List<DynamicElement> getButtonsAlertasLeft();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_ALERTAS_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsAlertasRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.BO_EVENTO_BORRAR_TAREA_ASUNTO)
    public void borrarTareaAsunto(Long idTraza);
}
