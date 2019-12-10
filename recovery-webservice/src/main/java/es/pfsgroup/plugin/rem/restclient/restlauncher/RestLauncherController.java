package es.pfsgroup.plugin.rem.restclient.restlauncher;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

@Controller
public class RestLauncherController {

	@Autowired
	private RestLauncher launcher;

	@Autowired
	private RestApi restApi;

	private final Log logger = LogFactory.getLog(getClass());

	/*
	 * ACTUALIZAR VISTAS MATERIALIZADAS
	 */

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void actualizarVistasMaterializadas(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.actualizarVistasMaterializadas();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * TODOS LOS CAMBIOS
	 * 
	 * 
	 */

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCambiosWebcom(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {

		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCambios();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCambiosNoOptimizados(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {

		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCambiosHandlersOptimizados();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * PROVEEDORES (9999)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoProveedoresWebcom(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoProveedoresWebcom();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarProveedoresWebcom(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarProveedoresWebcom();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * USUARIOS (9998)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoUsuariosWebcom(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoUsuariosWebcom();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarUsuariosWebcom(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarUsuariosWebcom();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * OBRAS NUEVAS CAMPANYAS (9997)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoObrasNuevasCampanyas(HttpServletRequest req, ModelMap model,
			HttpServletResponse response) throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoObrasNuevasCampanyas();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarObrasNuevasCampanyas(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarObrasNuevasCampanyas();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * CABECERAS (9996)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoCabecerasObrasNuevas(HttpServletRequest req, ModelMap model,
			HttpServletResponse response) throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoCabecerasObrasNuevas();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCabecerasObrasNuevas(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCabecerasObrasNuevas();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * STOCK (9995)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoStockWebcom(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoStockWebcom();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarStockWebcom(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarStockWebcom();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarStockWebcomNoOptimizado(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarStockWebcomNoOpt();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarStockWebcomOptimizado(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarStockWebcomOpt();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * ACTIVOS AGRUPACIONES CABECERAS (9994)
	 * 
	 */

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoActivosObrasNuevas(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoActivosObrasNuevas();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarActivosObrasNuevas(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarActivosObrasNuevas();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}

		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * NOTIFICACIONES (9993)
	 * 
	 */

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoEstadoNotificacion(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoEstadoNotificacion();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarEstadoNotificacion(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarEstadoNotificacion();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * PETICION TRABAJO (9992)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoPeticionTrabajo(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoPeticionTrabajo();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarPeticionTrabajo(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarPeticionTrabajo();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * ESTADO OFERTA (9991)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoEstadoOferta(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoEstadoOferta();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarEstadoOferta(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarEstadoOferta();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * INFORME MEDIADOR (9990)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoEstadosInformeMediador(HttpServletRequest req, ModelMap model,
			HttpServletResponse response) throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoEstadosInformeMediador();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarEstadosInformeMediador(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarEstadosInformeMediador();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	/*
	 * 
	 * 
	 * VENTAS Y COMISIONES (9989)
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarCompletoVentasYcomisiones(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarCompletoVentasYcomisiones();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void enviarVentasYcomisiones(HttpServletRequest req, ModelMap model, HttpServletResponse response)
			throws ErrorServicioWebcom {
		try {
			restApi.simulateRestFilter(req);
			launcher.enviarVentasYcomisiones();
			model.put("result", "Servicio ejecutado correctamente");
		} catch (Exception e) {
			model.put("result", e.getMessage());
			logger.error("Error en restLauncher", e);
			SecurityContextHolder.clearContext();
		}
		restApi.sendResponse(response, model, null);
	}

}
