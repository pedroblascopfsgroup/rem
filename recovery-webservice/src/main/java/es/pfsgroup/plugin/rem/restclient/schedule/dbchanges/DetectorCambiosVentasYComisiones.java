package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

@Component
public class DetectorCambiosVentasYComisiones extends DetectorCambiosBD<ComisionesDto>{
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_COMISIONES_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.CWH_COMISIONES_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_HONORARIO_REM";
	}

	@Override
	protected ComisionesDto createDtoInstance() {
		return new ComisionesDto();
	}

	@Override
	public void invocaServicio(List<ComisionesDto> data) throws ErrorServicioWebcom {
		this.serviciosWebcom.ventasYcomisiones(data);
		
	}

}
