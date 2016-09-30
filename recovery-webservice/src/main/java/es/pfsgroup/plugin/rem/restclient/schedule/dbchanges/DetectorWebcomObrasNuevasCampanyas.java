package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ActivoObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CampanyaObrasNuevasDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DetectorWebcomObrasNuevasCampanyas  extends DetectorCambiosBD<CampanyaObrasNuevasDto> {

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
	protected CampanyaObrasNuevasDto createDtoInstance() {
		return new CampanyaObrasNuevasDto();
	}

	@Override
	public void invocaServicio(List<CampanyaObrasNuevasDto> data) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestObrasNuevasCampanyas(data);
		
	}

}
