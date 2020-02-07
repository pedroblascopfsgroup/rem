package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import net.sf.json.JSONObject;

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
		return "ID_COMISION_REM";
	}

	@Override
	protected ComisionesDto createDtoInstance() {
		return new ComisionesDto();
	}

	@Override
	public JSONObject invocaServicio(List<ComisionesDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		return this.serviciosWebcom.webcomRestVentasYcomisiones(data, registro);
		
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
		return "ID_COMISION_REM";
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
