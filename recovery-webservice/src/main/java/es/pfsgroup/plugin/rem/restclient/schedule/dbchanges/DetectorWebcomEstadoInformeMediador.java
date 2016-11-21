package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomEstadoInformeMediador  extends DetectorCambiosBD<InformeMediadorDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_INFORME_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.IWH_INFORME_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_INFORME_COMERCIAL";
	}

	@Override
	protected InformeMediadorDto createDtoInstance() {
		return new InformeMediadorDto();
	}

	@Override
	public void invocaServicio(List<InformeMediadorDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestEstadoInformeMediador(data, registro);
		
	}

	@Override
	protected Integer getWeight() {
		return 9990;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

}
