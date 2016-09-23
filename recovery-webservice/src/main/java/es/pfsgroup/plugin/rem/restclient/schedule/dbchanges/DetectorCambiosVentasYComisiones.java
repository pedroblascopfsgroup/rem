package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DetectorCambiosVentasYComisiones extends DetectorCambiosBD<ComisionesDto>{
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "AAAA";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "BBBBB";
	}

	@Override
	public String clavePrimaria() {
		return "CCCCC";
	}

	@Override
	protected ComisionesDto createDtoInstance() {
		return new ComisionesDto();
	}

	@Override
	public void invocaServicio(List<ComisionesDto> data) {
		this.serviciosWebcom.ventasYcomisiones(data);
		
	}

}
