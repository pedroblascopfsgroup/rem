package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CabeceraObrasNuevasDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

/** Cabeceras/subdivisiones **/
public class DetectorWebcomCabecerasObrasNuevas  extends DetectorCambiosBD<CabeceraObrasNuevasDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_SUBDIVISION_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.SWH_SUBDIV_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID";
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
