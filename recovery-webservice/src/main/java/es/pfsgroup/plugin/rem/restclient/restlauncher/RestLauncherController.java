package es.pfsgroup.plugin.rem.restclient.restlauncher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;

@Controller
public class RestLauncherController {

	@Autowired
	private RestLauncher launcher;

	@RequestMapping
	public String enviarStockWebcom() throws ErrorServicioWebcom {
		launcher.enviarStockWebcom();
		return "default";
	}
	
	@RequestMapping
	public String enviarUsuariosWebcom() throws ErrorServicioWebcom {
		launcher.enviarUsuariosWebcom();
		return "default";
	}
	
	@RequestMapping
	public String enviarProveedoresWebcom() throws ErrorServicioWebcom {
		launcher.enviarProveedoresWebcom();
		return "default";
	}
	
	@RequestMapping
	public String enviarCambiosActivosObraNuevaWebcom() throws ErrorServicioWebcom {
		launcher.enviarCambiosActivosObrasNuevas();
		return "default";
	}
	
	@RequestMapping
	public String enviarCambiosCabecerasObrasNuevas() throws ErrorServicioWebcom {
		launcher.enviarCambiosCabecerasObrasNuevas();
		return "default";
	}
	
	@RequestMapping
	public String enviarCambiosEstadosInformeMediador() throws ErrorServicioWebcom {
		launcher.enviarCambiosEstadosInformeMediador();
		return "default";
	}
	
	@RequestMapping
	public String enviarCambiosEstadoNotificacion() throws ErrorServicioWebcom {
		launcher.enviarCambiosEstadoNotificacion();
		return "default";
	}

}
