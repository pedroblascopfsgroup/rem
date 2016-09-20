package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
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

	@Autowired(required = false)
	private MessageBroker messageBroker;

	@Autowired
	private ClienteEstadoTrabajo estadoTrabajoService;

	@Autowired
	private ClienteEstadoOferta estadoOfertaService;

	@Autowired
	private ClienteStock stockService;

	@Override
	public void enviaActualizacionEstadoTrabajo(List<EstadoTrabajoDto> estadoTrabajo) {
		logger.info("Invocando servicio Webcom: Estado Trabajo");

		ParamsList paramsList = new ParamsList();
		if (estadoTrabajo != null) {
			logger.debug("Convirtiendo EstadoTrabajoDto -> ParamsList");
			for (EstadoTrabajoDto dto : estadoTrabajo) {
				HashMap<String, Object> params = createParametersMap(dto);
				params.putAll(Converter.dtoToMap(dto));
				compruebaObligatorios(params, EstadoTrabajoConstantes.ID_TRABAJO_REM,
						EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, EstadoTrabajoConstantes.COD_ESTADO_TRABAJO);
				paramsList.add(params);
			}
		}else{
			logger.debug("La lista de EstadoTrabajoDto es NULL");
		}
		
		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoTrabajoService);
		}else{
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}
	}

	@Override
	public void enviaActualizacionEstadoOferta(List<EstadoOfertaDto> estadoOferta) {
		logger.info("Invocando servicio Webcom: Estado Oferta");
	
		ParamsList paramsList = new ParamsList();
		
		if (estadoOferta != null){
			logger.debug("Convirtiendo EstadoOfertaDto -> ParamsList");
			for (EstadoOfertaDto dto : estadoOferta){
				HashMap<String, Object> params = createParametersMap(dto);
				params.putAll(Converter.dtoToMap(dto));
				compruebaObligatorios(params, EstadoOfertaConstantes.ID_OFERTA_WEBCOM, EstadoOfertaConstantes.ID_OFERTA_REM,
						EstadoOfertaConstantes.COD_ESTADO_OFERTA);
				paramsList.add(params);
				
			}
			
		}else{
			logger.debug("La lista de EstadoOfertaDto es NULL");
		}
		
		
		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, estadoOfertaService);
		}else{
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}
		

	}

	@Override
	public void enviarStock(List<StockDto> stock) {
		logger.info("Invocando servicio Webcom: Stock");

		ParamsList paramsList = new ParamsList();
		logger.debug("Convirtiendo StockDto -> ParamsList");
		if (stock != null) {
			for (StockDto dto : stock) {
				HashMap<String, Object> params = createParametersMap(dto);
				compruebaObligatorios(params);
				params.putAll(Converter.dtoToMap(dto));
				paramsList.add(params);
			}
		}else{
			logger.debug("La lista de StockDto es NULL");
		}
		
		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(paramsList, stockService);
		}else{
			logger.debug("ParamsList vacío. Nada qeu enviar");
		}

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
