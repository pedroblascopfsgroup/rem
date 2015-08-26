package es.pfsgroup.plugin.recovery.configuracionEmails.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ConfiguracionEmailsApi {
	
	public static final String BO_CONFIGURACION_EMAILS_ENVIO_EMAILS = "configuracionEmailsManager.enviarEmailsTarea";
	
	/**
	 * Realiza el envío automático de emails asociados a la tarea
	 * @param tareaExterna
	 */
	@BusinessOperationDefinition(BO_CONFIGURACION_EMAILS_ENVIO_EMAILS)
    public void enviarEmailsTarea(TareaExterna tareaExterna);
}
