package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DetectorCambiosEstadoOferta  extends DetectorCambiosBD<EstadoOfertaDto>{
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "AAA";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "BBB";
	}

	@Override
	public String clavePrimaria() {
		return "CCC";
	}

	@Override
	protected EstadoOfertaDto createDtoInstance() {
		return new EstadoOfertaDto();
	}

	@Override
	public void invocaServicio(List<EstadoOfertaDto> data) {
		serviciosWebcom.enviaActualizacionEstadoOferta(data);
	}

}
