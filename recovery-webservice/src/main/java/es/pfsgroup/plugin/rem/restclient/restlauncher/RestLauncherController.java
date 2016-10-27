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
	public String enviarActivosObraNuevaWebcom() throws ErrorServicioWebcom {
		launcher.enviarActivosObrasNuevas();
		return "default";
	}
	
	@RequestMapping
	public String enviarCabecerasObrasNuevas() throws ErrorServicioWebcom {
		launcher.enviarCabecerasObrasNuevas();
		return "default";
	}
	
	@RequestMapping
	public String enviarEstadosInformeMediador() throws ErrorServicioWebcom {
		launcher.enviarEstadosInformeMediador();
		return "default";
	}
	
	@RequestMapping
	public String enviarEstadoNotificacion() throws ErrorServicioWebcom {
		launcher.enviarEstadoNotificacion();
		return "default";
	}

}
