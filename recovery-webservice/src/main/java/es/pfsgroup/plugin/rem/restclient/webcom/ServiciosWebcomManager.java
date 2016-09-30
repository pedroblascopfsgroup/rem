package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ActivoObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CabeceraObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CampanyaObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ProveedorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.UsuarioDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomActivosObrasNuevas;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomCabecerasObrasNuevas;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomEstadoInformeMediador;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomEstadoNotificacion;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomEstadoPeticionTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomObrasNuevasCampanyas;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomProveedores;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomStock;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomUsuarios;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomVentasYcomisiones;

@Service
public class ServiciosWebcomManager extends ServiciosWebcomBaseManager implements ServiciosWebcomApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RegistroLlamadasManager registroLlamadas;

	@Autowired
	private ClienteWebcomEstadoPeticionTrabajo estadoTrabajoService;

	@Autowired
	private ClienteWebcomEstadoOferta estadoOfertaService;

	@Autowired
	private ClienteWebcomEstadoNotificacion estadoNotificacionService;

	@Autowired
	private ClienteWebcomVentasYcomisiones ventasYcomsionesService;

	@Autowired
	private ClienteWebcomProveedores proveedoresService;

	@Autowired
	private ClienteWebcomEstadoInformeMediador informeMediadorService;
	
	@Autowired
	private ClienteWebcomCabecerasObrasNuevas cabecerasObrasNuevasService;
	
	@Autowired
	private ClienteWebcomActivosObrasNuevas activosObrasNuevasService;
	
	@Autowired
	private ClienteWebcomObrasNuevasCampanyas obrasNuevasCampanyasService;
	
	@Autowired
	private ClienteWebcomUsuarios usuariosService;

	@Autowired
	private ClienteWebcomStock stockService;

	@Override
	public void webcomRestEstadoPeticionTrabajo(List<EstadoTrabajoDto> estadoTrabajo) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Estado Trabajo");

		ParamsList paramsList = createParamsList(estadoTrabajo);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoTrabajoService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}
	}

	@Override
	public void webcomRestEstadoOferta(List<EstadoOfertaDto> estadoOferta) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Estado Oferta");

		ParamsList paramsList = createParamsList(estadoOferta);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoOfertaService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestStock(List<StockDto> stock) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Stock");

		ParamsList paramsList = createParamsList(stock);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, stockService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestEstadoNotificacion(List<NotificacionDto> notificaciones) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Estado notificaciones");

		ParamsList paramsList = createParamsList(notificaciones);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoNotificacionService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestVentasYcomisiones(List<ComisionesDto> comisiones) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Ventas y Comisiones");

		ParamsList paramsList = createParamsList(comisiones);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, ventasYcomsionesService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestProveedores(List<ProveedorDto> proveedores) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio datos Proveedores");

		ParamsList paramsList = createParamsList(proveedores);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, proveedoresService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestEstadoInformeMediador(List<InformeMediadorDto> informes) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio cambios estado Informe Mediador");

		ParamsList paramsList = createParamsList(informes);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, informeMediadorService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestCabeceraObrasNuevas(List<CabeceraObrasNuevasDto> cabeceras) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio Cabeceras Obras Nuevas");

		ParamsList paramsList = createParamsList(cabeceras);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, cabecerasObrasNuevasService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestActivosObrasNuevas(List<ActivoObrasNuevasDto> activos) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio Activos Obras Nuevas");

		ParamsList paramsList = createParamsList(activos);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, activosObrasNuevasService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}
	
	@Override
	public void webcomRestUsuarios(List<UsuarioDto> usuarios) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio Usuarios");

		ParamsList paramsList = createParamsList(usuarios);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, usuariosService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}
		
	}
	
	@Override
	public void webcomRestObrasNuevasCampanyas(List<CampanyaObrasNuevasDto> campanyas) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio Obras Nuevas Campanyas");

		ParamsList paramsList = createParamsList(campanyas);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, obrasNuevasCampanyasService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}
	}

	public void setWebServiceClients(ClienteWebcomEstadoPeticionTrabajo estadoTrabajoService,
			ClienteWebcomEstadoOferta estadoOfertaService, ClienteWebcomStock stockService,
			ClienteWebcomProveedores proveedoresService, ClienteWebcomEstadoInformeMediador informeMediadorService) {
		// Este método sirve sólamente para que el test (JUnit) pueda inyectar mocks a la clase.
		this.estadoTrabajoService = estadoTrabajoService;
		this.estadoOfertaService = estadoOfertaService;
		this.stockService = stockService;
		this.proveedoresService = proveedoresService;
		this.informeMediadorService = informeMediadorService;

	}

	/**
	 * Crea un objeto ParamList para invocar al web service a partir de una
	 * lista de DTO's. Este método también hará una comprobación de que los
	 * campos obligatorios estén presentes.
	 * 
	 * @param dtoList
	 *            Lista de DTO's que queremos mandar al servicio
	 * @param camposObligatorios
	 *            Lista variable de campos obligatorios.
	 * @return
	 */
	private <T extends WebcomRESTDto> ParamsList createParamsList(List<T> dtoList) {
		ParamsList paramsList = new ParamsList();
		if (dtoList != null) {
			logger.debug("Convirtiendo dtoList -> ParamsList");
			for (WebcomRESTDto dto : dtoList) {
				HashMap<String, Object> params = createParametersMap(dto);
				params.putAll(Converter.dtoToMap(dto));
				compruebaObligatorios(dto.getClass(), params);
				paramsList.add(params);
			}
		} else {
			logger.debug("'dtoList' es NULL");
		}
		return paramsList;
	}

	@Override
	protected RegistroLlamadasManager getRegistroLlamadas() {
		return this.registroLlamadas;
	}

}
