package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import net.sf.json.JSONObject;

@Component
public class DetectorWebcomEstadoNotificacion extends DetectorCambiosBD<NotificacionDto> {

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
	public JSONObject invocaServicio(List<NotificacionDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		return this.serviciosWebcom.webcomRestEstadoNotificacion(data, registro);

	}

	@Override
	protected Integer getWeight() {
		return 9993;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_NOTIFICACION_REM";
	}

	@Override
	public List<String> vistasAuxiliares() {
		return null;
	}
	
	@Override
	public Boolean procesarSoloCambiosMarcados() {
		return false;
	}

}
