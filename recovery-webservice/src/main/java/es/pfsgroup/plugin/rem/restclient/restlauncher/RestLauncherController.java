package es.pfsgroup.plugin.rem.restclient.restlauncher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;

@Controller
public class RestLauncherController {

	@Autowired
	private RestLauncher launcher;

	/*
	 * 
	 * 
	 * STOCK
	 * 
	 */

	@RequestMapping
	public String enviarCompletoStockWebcom() throws ErrorServicioWebcom {
		launcher.enviarCompletoStockWebcom();
		return "default";
	}

	@RequestMapping
	public String enviarStockWebcom() throws ErrorServicioWebcom {
		launcher.enviarStockWebcom();
		return "default";
	}

	/*
	 * 
	 * 
	 * USUARIOS
	 * 
	 */

	@RequestMapping
	public String enviarCompletoUsuariosWebcom() throws ErrorServicioWebcom {
		launcher.enviarCompletoUsuariosWebcom();
		return "default";
	}

	@RequestMapping
	public String enviarUsuariosWebcom() throws ErrorServicioWebcom {
		launcher.enviarUsuariosWebcom();
		return "default";
	}

	/*
	 * 
	 * 
	 * PROVEEDORES
	 * 
	 */
	@RequestMapping
	public String enviarCompletoProveedoresWebcom() throws ErrorServicioWebcom {
		launcher.enviarCompletoProveedoresWebcom();
		return "default";
	}

	@RequestMapping
	public String enviarProveedoresWebcom() throws ErrorServicioWebcom {
		launcher.enviarProveedoresWebcom();
		return "default";
	}

	/*
	 * 
	 * 
	 * OBRAS NUEVAS
	 * 
	 */

	@RequestMapping
	public String enviarCompletoActivosObrasNuevas() throws ErrorServicioWebcom {
		launcher.enviarCompletoActivosObrasNuevas();
		return "default";
	}

	@RequestMapping
	public String enviarActivosObrasNuevas() throws ErrorServicioWebcom {
		launcher.enviarActivosObrasNuevas();
		return "default";
	}

	/*
	 * 
	 * 
	 * CABECERAS
	 * 
	 */

	@RequestMapping
	public String enviarCompletoCabecerasObrasNuevas() throws ErrorServicioWebcom {
		launcher.enviarCompletoCabecerasObrasNuevas();
		return "default";
	}

	@RequestMapping
	public String enviarCabecerasObrasNuevas() throws ErrorServicioWebcom {
		launcher.enviarCabecerasObrasNuevas();
		return "default";
	}

	/*
	 * 
	 * 
	 * INFORME MEDIADOR
	 * 
	 */

	@RequestMapping
	public String enviarCompletoEstadosInformeMediador() throws ErrorServicioWebcom {
		launcher.enviarCompletoEstadosInformeMediador();
		return "default";
	}

	@RequestMapping
	public String enviarEstadosInformeMediador() throws ErrorServicioWebcom {
		launcher.enviarEstadosInformeMediador();
		return "default";
	}

	/*
	 * 
	 * 
	 * NOTIFICACIONES
	 * 
	 */

	@RequestMapping
	public String enviarCompletoEstadoNotificacion() throws ErrorServicioWebcom {
		launcher.enviarCompletoEstadoNotificacion();
		return "default";
	}

	@RequestMapping
	public String enviarEstadoNotificacion() throws ErrorServicioWebcom {
		launcher.enviarEstadoNotificacion();
		return "default";
	}

	/*
	 * 
	 * 
	 * ESTADO OFERTA
	 * 
	 */

	@RequestMapping
	public String enviarCompletoEstadoOferta() throws ErrorServicioWebcom {
		launcher.enviarCompletoEstadoOferta();
		return "default";
	}

	@RequestMapping
	public String enviarEstadoOferta() throws ErrorServicioWebcom {
		launcher.enviarEstadoOferta();
		return "default";
	}

	/*
	 * 
	 * 
	 * PETICION TRABAJO
	 * 
	 */

	@RequestMapping
	public String enviarCompletoPeticionTrabajo() throws ErrorServicioWebcom {
		launcher.enviarCompletoPeticionTrabajo();
		return "default";
	}

	@RequestMapping
	public String enviarPeticionTrabajo() throws ErrorServicioWebcom {
		launcher.enviarPeticionTrabajo();
		return "default";
	}
	
	/*
	 * 
	 * 
	 *	OBRAS NUEVAS CAMPANYAS 
	 * 
	 */
	
	@RequestMapping
	public String enviarCompletoObrasNuevasCampanyas() throws ErrorServicioWebcom {
		launcher.enviarCompletoObrasNuevasCampanyas();
		return "default";
	}

	@RequestMapping
	public String enviarObrasNuevasCampanyas() throws ErrorServicioWebcom {
		launcher.enviarObrasNuevasCampanyas();
		return "default";
	}
	
	/*
	 * 
	 * 
	 * VENTAS Y COMISIONES 
	 * 
	 */
	
	@RequestMapping
	public String enviarCompletoVentasYcomisiones() throws ErrorServicioWebcom {
		launcher.enviarCompletoVentasYcomisiones();
		return "default";
	}

	@RequestMapping
	public String enviarVentasYcomisiones() throws ErrorServicioWebcom {
		launcher.enviarVentasYcomisiones();
		return "default";
	}
	
	

}
