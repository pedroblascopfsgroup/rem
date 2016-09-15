package es.pfsgroup.plugin.rem.jbpm.handler.notificator;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

public interface NotificatorService extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	
	public String[] getCodigoTarea();

	/**
	 * Notificación llamada desde el EnterHandler del bpm
	 * @param tramite
	 */
	public void notificator(ActivoTramite tramite);
	
	/**
	 * Notificación llamada desde el LeaveHandler del bpm
	 * Tiene en cuenta los valores introducidos en la tarea.
	 * @param tramite
	 * @param valores
	 */
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores);

}
