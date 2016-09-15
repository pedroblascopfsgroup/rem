package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteStock;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoOfertaConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;

@Service
public class ServiciosWebcomManager extends ServiciosWebcomBaseManager implements ServiciosWebcomApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private HttpClientFacade httpClient;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired(required = false)
	private MessageBroker messageBroker;

	@Autowired
	private ClienteEstadoTrabajo estadoTrabajoService;

	@Autowired
	private ClienteEstadoOferta estadoOfertaService;

	@Autowired
	private ClienteStock stockService;

	@Override
	public void enviaActualizacionEstadoTrabajo(Long idRem, Long idWebcom, String codEstado, String motivoRechazo) {
		logger.info("Invocando servicio Webcom: Estado Trabajo");
		HashMap<String, Object> params = createParametersMap(proxyFactory);
		params.put(EstadoTrabajoConstantes.ID_TRABAJO_REM, idRem);
		params.put(EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, idWebcom);
		params.put(EstadoTrabajoConstantes.COD_ESTADO_TRABAJO, codEstado);

		compruebaObligatorios(params, EstadoTrabajoConstantes.ID_TRABAJO_REM, EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM,
				EstadoTrabajoConstantes.COD_ESTADO_TRABAJO);

		if (motivoRechazo != null && (!"".equals(motivoRechazo))) {
			params.put(EstadoTrabajoConstantes.MOTIVO_RECHAZO, motivoRechazo);
		}
		ParamsList paramsList = new ParamsList();
		paramsList.add(params);
		invocarServicioRestWebcom(paramsList, estadoTrabajoService);
	}

	@Override
	public void enviaActualizacionEstadoOferta(Long idRem, Long idWebcom, String codEstadoOferta, Long idActivoHaya,
			String codEstadoExpediente, Boolean vendido) {
		logger.info("Invocando servicio Webcom: Estado Oferta");
		HashMap<String, Object> params = createParametersMap(proxyFactory);

		params.put(EstadoOfertaConstantes.ID_OFERTA_WEBCOM, idWebcom);
		params.put(EstadoOfertaConstantes.ID_OFERTA_REM, idRem);
		params.put(EstadoOfertaConstantes.COD_ESTADO_OFERTA, codEstadoOferta);

		compruebaObligatorios(params, EstadoOfertaConstantes.ID_OFERTA_WEBCOM, EstadoOfertaConstantes.ID_OFERTA_REM,
				EstadoOfertaConstantes.COD_ESTADO_OFERTA);

		if (idActivoHaya != null) {
			params.put(EstadoOfertaConstantes.ID_ACTIVO_HAYA, idActivoHaya);
		}

		if (codEstadoExpediente != null) {
			params.put(EstadoOfertaConstantes.COD_ESTADO_EXPEDIENTE, codEstadoExpediente);
		}

		if (vendido != null) {
			params.put(EstadoOfertaConstantes.VENDIDO, vendido);
		}

		ParamsList paramsList = new ParamsList();
		paramsList.add(params);
		invocarServicioRestWebcom(paramsList, estadoOfertaService);

	}

	@Override
	public void enviarStock(List<StockDto> stock) {
		logger.info("Invocando servicio Webcom: Stock");

		ParamsList paramsList = new ParamsList();
		if (stock != null) {
			for (StockDto dto : stock) {
				HashMap<String, Object> params = createParametersMap(proxyFactory);
				params.putAll(Converter.dtoToMap(dto));
				paramsList.add(params);
			}
		}

		invocarServicioRestWebcom(paramsList, stockService);

	}

	public void setWebServiceClients(ClienteEstadoTrabajo estadoTrabajoService, ClienteEstadoOferta estadoOfertaService,
			ClienteStock stockService) {
		this.estadoTrabajoService = estadoTrabajoService;
		this.estadoOfertaService = estadoOfertaService;
		this.stockService = stockService;

	}

	@Override
	protected MessageBroker getMessageBroker() {
		return this.messageBroker;
	}

}
