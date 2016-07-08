package es.pfsgroup.plugin.rem.jbpm.handler.notificator;

import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

public interface NotificatorService extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	
	public String[] getCodigoTarea();

	public void notificator(ActivoTramite tramite);

}
