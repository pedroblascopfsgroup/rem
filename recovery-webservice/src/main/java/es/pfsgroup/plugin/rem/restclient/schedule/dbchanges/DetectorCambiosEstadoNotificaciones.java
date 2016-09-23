package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoNotificacionConstantes;

public class DetectorCambiosEstadoNotificaciones extends DetectorCambiosBD<NotificacionDto>{
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "AAAAa";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "BBBBB";
	}

	@Override
	public String clavePrimaria() {
		return "CCCCCC";
	}

	@Override
	protected NotificacionDto createDtoInstance() {
		return new NotificacionDto();
	}

	@Override
	public void invocaServicio(List<NotificacionDto> data) {
		this.serviciosWebcom.estadoNotificacion(data);
		
	}

}
