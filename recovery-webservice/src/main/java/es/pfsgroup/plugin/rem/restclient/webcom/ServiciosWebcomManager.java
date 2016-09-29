package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ProveedorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEnvioProveedores;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoNotificacion;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteInformeMediador;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteStock;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteVentasYComisiones;

@Service
public class ServiciosWebcomManager extends ServiciosWebcomBaseManager implements ServiciosWebcomApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RegistroLlamadasManager registroLlamadas;

	@Autowired
	private ClienteEstadoTrabajo estadoTrabajoService;

	@Autowired
	private ClienteEstadoOferta estadoOfertaService;

	@Autowired
	private ClienteEstadoNotificacion estadoNotificacionService;

	@Autowired
	private ClienteVentasYComisiones ventasYcomsionesService;
	
	@Autowired
	private ClienteEnvioProveedores proveedoresService;
	
	@Autowired
	private ClienteInformeMediador informeMediadorService;

	@Autowired
	private ClienteStock stockService;

	@Override
	public void enviaActualizacionEstadoTrabajo(List<EstadoTrabajoDto> estadoTrabajo) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Estado Trabajo");

		ParamsList paramsList = createParamsList(estadoTrabajo);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoTrabajoService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}
	}

	@Override
	public void enviaActualizacionEstadoOferta(List<EstadoOfertaDto> estadoOferta) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Estado Oferta");

		ParamsList paramsList = createParamsList(estadoOferta);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoOfertaService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void enviarStock(List<StockDto> stock) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Stock");

		ParamsList paramsList = createParamsList(stock);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, stockService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void estadoNotificacion(List<NotificacionDto> notificaciones) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Estado notificaciones");

		ParamsList paramsList = createParamsList(notificaciones);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoNotificacionService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void ventasYcomisiones(List<ComisionesDto> comisiones) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Ventas y Comisiones");

		ParamsList paramsList = createParamsList(comisiones);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, ventasYcomsionesService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}

	}
	
	@Override
	public void enviaProveedores(List<ProveedorDto> proveedores) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio datos Proveedores");
		
		ParamsList paramsList = createParamsList(proveedores);
		
		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, proveedoresService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}
		
	}
	
	@Override
	public void enviarEstadoInformeMediador(List<InformeMediadorDto> informes) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Envio cambios estado Informe Mediador");
		
		ParamsList paramsList = createParamsList(informes);
		
		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, informeMediadorService);
		} else {
			logger.debug("ParamsList vacío. Nada que enviar");
		}
		
	}


	public void setWebServiceClients(ClienteEstadoTrabajo estadoTrabajoService, ClienteEstadoOferta estadoOfertaService,
			ClienteStock stockService, ClienteEnvioProveedores proveedoresService, ClienteInformeMediador informeMediadorService) {
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
