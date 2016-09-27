package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoNotificacion;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteStock;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteVentasYComisiones;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoNotificacionConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoOfertaConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.VentasYComisionesConstantes;

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
	private ClienteStock stockService;

	@Override
	public void enviaActualizacionEstadoTrabajo(List<EstadoTrabajoDto> estadoTrabajo) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Estado Trabajo");

		ParamsList paramsList = createParamsList(estadoTrabajo, EstadoTrabajoConstantes.ID_TRABAJO_REM,
				EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, EstadoTrabajoConstantes.COD_ESTADO_TRABAJO);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoTrabajoService);
		} else {
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}
	}

	@Override
	public void enviaActualizacionEstadoOferta(List<EstadoOfertaDto> estadoOferta) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Estado Oferta");

		ParamsList paramsList = createParamsList(estadoOferta, EstadoOfertaConstantes.ID_OFERTA_WEBCOM,
				EstadoOfertaConstantes.ID_OFERTA_REM, EstadoOfertaConstantes.COD_ESTADO_OFERTA);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoOfertaService);
		} else {
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}

	}

	@Override
	public void enviarStock(List<StockDto> stock) throws ErrorServicioWebcom {
		logger.info("Invocando servicio Webcom: Stock");

		ParamsList paramsList = createParamsList(stock);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, stockService);
		} else {
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}

	}

	@Override
	public void estadoNotificacion(List<NotificacionDto> notificaciones) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Estado notificaciones");

		ParamsList paramsList = createParamsList(notificaciones, EstadoNotificacionConstantes.ID_NOTIFICACION_REM,
				EstadoNotificacionConstantes.ID_ACTIVO_HAYA);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoNotificacionService);
		} else {
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}

	}

	@Override
	public void ventasYcomisiones(List<ComisionesDto> comisiones) throws ErrorServicioWebcom{
		logger.info("Invocando servicio Webcom: Ventas y Comisiones");

		ParamsList paramsList = createParamsList(comisiones, VentasYComisionesConstantes.ID_OFERTA_REM,
				VentasYComisionesConstantes.ID_OFERTA_WEBCOM, VentasYComisionesConstantes.ID_PROVEEDOR_REM,
				VentasYComisionesConstantes.ES_PRESCRIPCION, VentasYComisionesConstantes.ES_COLABORACION,
				VentasYComisionesConstantes.ES_RESPONSABLE, VentasYComisionesConstantes.ES_FDV,
				VentasYComisionesConstantes.ES_DOBLE_PRESCRIPCION, VentasYComisionesConstantes.IMPORTE,
				VentasYComisionesConstantes.PORCENTAJE);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, ventasYcomsionesService);
		} else {
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}

	}

	public void setWebServiceClients(ClienteEstadoTrabajo estadoTrabajoService, ClienteEstadoOferta estadoOfertaService,
			ClienteStock stockService) {
		this.estadoTrabajoService = estadoTrabajoService;
		this.estadoOfertaService = estadoOfertaService;
		this.stockService = stockService;

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
	private <T extends WebcomRESTDto> ParamsList createParamsList(List<T> dtoList, String... camposObligatorios) {
		ParamsList paramsList = new ParamsList();
		if (dtoList != null) {
			logger.debug("Convirtiendo dtoList -> ParamsList");
			for (WebcomRESTDto dto : dtoList) {
				HashMap<String, Object> params = createParametersMap(dto);
				params.putAll(Converter.dtoToMap(dto));
				compruebaObligatorios(params, camposObligatorios);
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
