package es.pfsgroup.plugin.recovery.procuradores.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface PCDProcesadoRecordatoriosApi {
	
	public static final String PCD_BO_CREAR_TAREAS_DE_RECORDATORIO = "es.pfsgroup.plugin.recovery.procuradores.recordatorios.api.crearTareaRecordatorios";
	
	@BusinessOperationDefinition(PCD_BO_CREAR_TAREAS_DE_RECORDATORIO)
    public void crearTareaRecordatorios(long idRecordatorio, String[] dias);
		

}
