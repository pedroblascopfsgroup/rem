package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomVentasYcomisiones extends DetectorCambiosBD<ComisionesDto>{
	
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
	public void invocaServicio(List<ComisionesDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestVentasYcomisiones(data, registro);
		
	}

	@Override
	protected Integer getWeight() {
		return 9989;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_OFERTA_REM";
	}

	@Override
	public List<String> vistasAuxiliares() {
		return null;
	}

}
