package es.pfsgroup.plugin.recovery.configuracionEmails.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface ConfiguracionEmailsApi {
	
	/**
	 * Realiza el envío automático de emails asociados a la tarea
	 * @param tareaExterna
	 */
    public void enviarEmailsTarea(TareaExterna tareaExterna);
}
