package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DetectorCambiosEstadoPeticionTrabajo extends DetectorCambiosBD<EstadoTrabajoDto>{
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	protected EstadoTrabajoDto createDtoInstance() {
		return new EstadoTrabajoDto();
	}

	@Override
	public void invocaServicio(List<EstadoTrabajoDto> data) {
		this.serviciosWebcom.enviaActualizacionEstadoTrabajo(data);
		
	}

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.REM_WEBCOM_TRABAJO_ACTUAL";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.REM_WEBCOM_TRABAJO_HISTORICO";
	}

	@Override
	public String clavePrimaria() {
		return "ID_TRABAJO_REM";
	}

}
