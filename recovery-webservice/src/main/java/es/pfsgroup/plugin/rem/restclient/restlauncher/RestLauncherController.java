package es.pfsgroup.plugin.rem.restclient.restlauncher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;

@Controller
public class RestLauncherController {

	@Autowired
	private RestLauncher launcher;

	@Autowired
	private GenericAdapter genericAdapter;

	/*
	 * ACTUALIZAR VISTAS MATERIALIZADAS
	 */

	@RequestMapping
	public String actualizarVistasMaterializadas() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.actualizarVistasMaterializadas();
		}

		return "default";
	}

	/*
	 * 
	 * TODOS LOS CAMBIOS
	 * 
	 * 
	 */

	@RequestMapping
	public String enviarCambiosWebcom() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCambios();
		}

		return "default";
	}

	/*
	 * 
	 * 
	 * STOCK
	 * 
	 */

	@RequestMapping
	public String enviarCompletoStockWebcom() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoStockWebcom();
		}

		return "default";
	}

	@RequestMapping
	public String enviarStockWebcom() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarStockWebcom();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoUsuariosWebcom();
		}

		return "default";
	}

	@RequestMapping
	public String enviarUsuariosWebcom() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarUsuariosWebcom();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoProveedoresWebcom();
		}

		return "default";
	}

	@RequestMapping
	public String enviarProveedoresWebcom() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarProveedoresWebcom();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoActivosObrasNuevas();
		}

		return "default";
	}

	@RequestMapping
	public String enviarActivosObrasNuevas() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarActivosObrasNuevas();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoCabecerasObrasNuevas();
		}

		return "default";
	}

	@RequestMapping
	public String enviarCabecerasObrasNuevas() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCabecerasObrasNuevas();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoEstadosInformeMediador();
		}

		return "default";
	}

	@RequestMapping
	public String enviarEstadosInformeMediador() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarEstadosInformeMediador();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoEstadoNotificacion();
		}

		return "default";
	}

	@RequestMapping
	public String enviarEstadoNotificacion() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarEstadoNotificacion();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoEstadoOferta();
		}

		return "default";
	}

	@RequestMapping
	public String enviarEstadoOferta() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarEstadoOferta();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoPeticionTrabajo();
		}

		return "default";
	}

	@RequestMapping
	public String enviarPeticionTrabajo() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarPeticionTrabajo();
		}

		return "default";
	}

	/*
	 * 
	 * 
	 * OBRAS NUEVAS CAMPANYAS
	 * 
	 */

	@RequestMapping
	public String enviarCompletoObrasNuevasCampanyas() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoObrasNuevasCampanyas();
		}

		return "default";
	}

	@RequestMapping
	public String enviarObrasNuevasCampanyas() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarObrasNuevasCampanyas();
		}

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
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarCompletoVentasYcomisiones();
		}

		return "default";
	}

	@RequestMapping
	public String enviarVentasYcomisiones() throws ErrorServicioWebcom {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			launcher.enviarVentasYcomisiones();
		}

		return "default";
	}

}
