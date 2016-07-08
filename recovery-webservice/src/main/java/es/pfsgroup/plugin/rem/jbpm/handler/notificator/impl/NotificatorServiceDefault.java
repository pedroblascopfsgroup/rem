package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class NotificatorServiceDefault implements NotificatorService {

	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{DEFAULT_SERVICE_BEAN_KEY};
	}
	
	@Override
	public void notificator(ActivoTramite tramite) {
	}


}
