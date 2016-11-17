package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CampanyaObrasNuevasDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomObrasNuevasCampanyas  extends DetectorCambiosBD<CampanyaObrasNuevasDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_AGRUP_ONV_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.AWH_AGRUP_ONV_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_AGRUPACION_REM";
	}

	@Override
	protected CampanyaObrasNuevasDto createDtoInstance() {
		return new CampanyaObrasNuevasDto();
	}

	@Override
	public void invocaServicio(List<CampanyaObrasNuevasDto> data , RestLlamada registro) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestObrasNuevasCampanyas(data, registro);
		
	}

	@Override
	protected Integer getWeight() {
		return 9997;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

}
