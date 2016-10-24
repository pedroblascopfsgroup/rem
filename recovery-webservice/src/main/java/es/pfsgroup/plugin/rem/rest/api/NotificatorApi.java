package es.pfsgroup.plugin.rem.rest.api;

import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;

public interface NotificatorApi extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	
	public String[] getCodigoTarea();

	/**
	 * Notificación llamada desde el EnterHandler del bpm
	 * @param tramite
	 */
	public void notificator(ResolucionComiteBankia resol, Notificacion notif);
	

}
