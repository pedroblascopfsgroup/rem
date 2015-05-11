package es.pfsgroup.plugin.recovery.masivo.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Esta interfaz servir� para publicar en JMX el MBean que ejecutar� la b�squeda
 * y procesado de los impulsos autom�ticos definidos
 * 
 * @author pedro
 * 
 */
public interface MSVProcesoImpulsoAutomaticoApi {

	String BO_BUSQUEDA_IMPULSOS_AUTOMATICOS = "es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoImpulsoAutomaticoApi.procesadoPeriodico";

	/**
	 * B�squeda e inicio del procesado autom�tico de impulsos
	 * 
	 */
	@BusinessOperationDefinition(BO_BUSQUEDA_IMPULSOS_AUTOMATICOS)
	void procesadoPeriodico();

}
