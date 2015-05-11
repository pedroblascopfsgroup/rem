package es.pfsgroup.plugin.recovery.masivo.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Esta interfaz servirá para publicar en JMX el MBean que ejecutará la búsqueda
 * y procesado de los impulsos automáticos definidos
 * 
 * @author pedro
 * 
 */
public interface MSVProcesoImpulsoAutomaticoApi {

	String BO_BUSQUEDA_IMPULSOS_AUTOMATICOS = "es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoImpulsoAutomaticoApi.procesadoPeriodico";

	/**
	 * Búsqueda e inicio del procesado automático de impulsos
	 * 
	 */
	@BusinessOperationDefinition(BO_BUSQUEDA_IMPULSOS_AUTOMATICOS)
	void procesadoPeriodico();

}
