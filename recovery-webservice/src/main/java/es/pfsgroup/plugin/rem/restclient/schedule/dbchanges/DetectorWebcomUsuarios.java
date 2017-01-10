package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.UsuarioDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomUsuarios  extends DetectorCambiosBD<UsuarioDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_USUARIOS_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.UWH_USUARIOS_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_USUARIO_CONTACTO";
	}

	@Override
	protected UsuarioDto createDtoInstance() {
		return new UsuarioDto();
	}

	@Override
	public void invocaServicio(List<UsuarioDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		this.serviciosWebcom.webcomRestUsuarios(data, registro);
		
	}

	@Override
	protected Integer getWeight() {
		return 9998;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

}
