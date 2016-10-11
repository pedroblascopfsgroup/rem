package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CabeceraObrasNuevasDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomCabecerasObrasNuevas  extends DetectorCambiosBD<CabeceraObrasNuevasDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_CABEC_ONV_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.CWH_CABEC_ONV_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_SUBDIVISION_REM";
	}

	@Override
	protected CabeceraObrasNuevasDto createDtoInstance() {
		return new CabeceraObrasNuevasDto();
	}

	@Override
	public void invocaServicio(List<CabeceraObrasNuevasDto> data) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestCabeceraObrasNuevas(data);
		
	}

}
