package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ActivoObrasNuevasDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;


public class DetectorWebcomActivosObrasNuevas  extends DetectorCambiosBD<ActivoObrasNuevasDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_ACTIVO_ONV_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.AWH_ACTIVO_ONV_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_AGRUP_ACTIVO";
	}

	@Override
	protected ActivoObrasNuevasDto createDtoInstance() {
		return new ActivoObrasNuevasDto();
	}

	@Override
	public void invocaServicio(List<ActivoObrasNuevasDto> data) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestActivosObrasNuevas(data);
		
	}

}
