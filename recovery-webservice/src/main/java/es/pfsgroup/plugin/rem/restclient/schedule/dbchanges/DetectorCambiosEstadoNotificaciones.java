package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorCambiosEstadoNotificaciones extends DetectorCambiosBD<NotificacionDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_RESP_NOTIF_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.NWH_RESP_NOTIF_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_NOTIFICACION_REM";
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
