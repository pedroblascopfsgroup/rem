package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ActivoObrasNuevasDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosList;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
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
	public void invocaServicio(List<ActivoObrasNuevasDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestActivosObrasNuevas(data, registro);
		
	}

	@Override
	protected Integer getWeight() {
		return 9994;
	}

	@Override
	public boolean isActivo() {
		return false;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_AGRUPACION_REM";
	}

	@Override
	public List<String> vistasAuxiliares() {
		return null;
	}

	@Override
	public Boolean procesarSoloCambiosMarcados() {
		return false;
	}

	@Override
	public void marcarComoEnviadosMarcadosEspecifico(CambiosList listPendientes) {
		// TODO Auto-generated method stub
		
	}

}
