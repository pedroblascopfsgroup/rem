package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CampanyaObrasNuevasDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DetectorWebcomObrasNuevasCampanyas  extends DetectorCambiosBD<CampanyaObrasNuevasDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_OBRANUEVA_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.OWH_OBRANUEVA_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID";
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
