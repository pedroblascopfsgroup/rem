package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import net.sf.json.JSONObject;

@Component
public class DetectorWebcomEstadoPeticionTrabajo extends DetectorCambiosBD<EstadoTrabajoDto>{
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	protected EstadoTrabajoDto createDtoInstance() {
		return new EstadoTrabajoDto();
	}

	@Override
	public JSONObject invocaServicio(List<EstadoTrabajoDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		return this.serviciosWebcom.webcomRestEstadoPeticionTrabajo(data, registro);
		
	}

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_TRABAJOS_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.TWH_TRABAJOS_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_TRABAJO_REM";
	}

	@Override
	protected Integer getWeight() {
		return 9992;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_TRABAJO_REM";
	}

	@Override
	public List<String> vistasAuxiliares() {
		return null;
	}
	
	@Override
	public Boolean procesarSoloCambiosMarcados() {
		return false;
	}

}
