package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ProveedorDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomProveedores extends DetectorCambiosBD<ProveedorDto> {
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_PROVEEDOR_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.PWH_PROVEEDOR_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_PROV_DELEGACION";
	}

	@Override
	protected ProveedorDto createDtoInstance() {
		return new ProveedorDto();
	}

	@Override
	public void invocaServicio(List<ProveedorDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		serviciosWebcom.webcomRestProveedores(data, registro);
		
	}
	

}
