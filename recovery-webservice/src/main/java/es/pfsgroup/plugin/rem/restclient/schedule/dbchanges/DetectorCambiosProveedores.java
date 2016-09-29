package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DetectorCambiosProveedores extends DetectorCambiosBD<NotificacionDto> {
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;
	

}
