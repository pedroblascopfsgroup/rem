package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoOfertaConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;

@Service
public class ServiciosWebcomManager extends ServiciosWebcomBaseManager implements ServiciosWebcomApi {

	@Autowired
	private HttpClientFacade httpClient;

	@Autowired ApiProxyFactory proxyFactory;
	
	@Autowired ClienteEstadoTrabajo estadoTrabajoService; 
	
	@Autowired
	private ClienteEstadoOferta estadoOfertaService;
	

	@Override
	public void enviaActualizacionEstadoTrabajo(Long idRem, Long idWebcom, Long idEstado, String motivoRechazo) {
		HashMap<String, Object> params = createParametersMap(proxyFactory);
		params.put(EstadoTrabajoConstantes.ID_TRABAJO_REM, idRem);
		params.put(EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, idWebcom);
		params.put(EstadoTrabajoConstantes.ID_ESTADO_TRABAJO, idEstado);

		compruebaObligatorios(params, EstadoTrabajoConstantes.ID_TRABAJO_REM, EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM,
				EstadoTrabajoConstantes.ID_ESTADO_TRABAJO);

		if (motivoRechazo != null && (!"".equals(motivoRechazo))) {
			params.put(EstadoTrabajoConstantes.MOTIVO_RECHAZO, motivoRechazo);
		}

		invocarServicioRestWebcom(params, estadoTrabajoService);
	}


	@Override
	public void enviaActualizacionEstadoOferta(Long idRem, Long idWebcom, Long idEstadoOferta, Long idActivoHaya,
			Long idEstadoExpediente, Boolean vendido) {
		HashMap<String, Object> params = createParametersMap(proxyFactory);

		params.put(EstadoOfertaConstantes.ID_OFERTA_WEBCOM, idWebcom);
		params.put(EstadoOfertaConstantes.ID_OFERTA_REM, idRem);
		params.put(EstadoOfertaConstantes.ID_ESTADO_OFERTA, idEstadoOferta);

		compruebaObligatorios(params, EstadoOfertaConstantes.ID_OFERTA_WEBCOM, EstadoOfertaConstantes.ID_OFERTA_REM,
				EstadoOfertaConstantes.ID_ESTADO_OFERTA);

		if (idActivoHaya != null) {
			params.put(EstadoOfertaConstantes.ID_ACTIVO_HAYA, idActivoHaya);
		}

		if (idEstadoExpediente != null) {
			params.put(EstadoOfertaConstantes.ID_ESTADO_EXPEDIENTE, idEstadoExpediente);
		}

		if (vendido != null) {
			params.put(EstadoOfertaConstantes.VENDIDO, vendido);
		}
		
		invocarServicioRestWebcom(params, estadoOfertaService);

	}

	public void setWebServiceClients(ClienteEstadoTrabajo estadoTrabajoService, ClienteEstadoOferta estadoOfertaService) {
		this.estadoTrabajoService = estadoTrabajoService;
		this.estadoOfertaService = estadoOfertaService;
		
	}

}
