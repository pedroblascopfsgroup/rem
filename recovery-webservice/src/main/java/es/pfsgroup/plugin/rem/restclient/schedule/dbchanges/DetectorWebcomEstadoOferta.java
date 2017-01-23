package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomEstadoOferta  extends DetectorCambiosBD<EstadoOfertaDto>{
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_OFERTAS_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.OWH_OFERTAS_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_OFERTA_REM";
	}

	@Override
	protected EstadoOfertaDto createDtoInstance() {
		return new EstadoOfertaDto();
	}

	@Override
	public void invocaServicio(List<EstadoOfertaDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		serviciosWebcom.webcomRestEstadoOferta(data, registro);
	}

	@Override
	protected Integer getWeight() {
		return 9991;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_OFERTA_REM";
	}

}
