package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

@Component
public class ClienteEstadoTrabajo extends ClienteWebcomBase {
	
	
	@Autowired
	private HttpClientFacade httpClient;

	@Override
	@AsyncRequestHandler
	public Map<String, Object> enviaPeticion(ParamsList paramsList) throws ErrorServicioWebcom {
		return send(httpClient,WebcomEndpoint.estadoTrabajo(), paramsList);
	}
	
	@Override
	@AsyncResponseHandler
	public void procesaRespuesta(Map<String, Object> respuesta) {
		this.receive(respuesta);
		
	}

}
