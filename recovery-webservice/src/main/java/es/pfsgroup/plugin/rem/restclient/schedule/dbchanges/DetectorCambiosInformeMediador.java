package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DetectorCambiosInformeMediador  extends DetectorCambiosBD<InformeMediadorDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "VISTA DESCONOCIDA";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "TABLA DESCONOCIDA";
	}

	@Override
	public String clavePrimaria() {
		return "CLAVE_PRIMARIA_DESCONCIDA";
	}

	@Override
	protected InformeMediadorDto createDtoInstance() {
		return new InformeMediadorDto();
	}

	@Override
	public void invocaServicio(List<InformeMediadorDto> data) throws ErrorServicioWebcom {
		this.serviciosWebcom.enviarEstadoInformeMediador(data);
		
	}

}
