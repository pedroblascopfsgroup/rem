package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

@Component
public class ClienteEstadoTrabajo extends ClienteWebcomBase implements ClienteWebcom {
	
	@Autowired
	private HttpClientFacade httpClient;

	public ClienteEstadoTrabajo() {
		this.setEndpoint(WebcomEndpoint.estadoTrabajo());
		this.setHttpClient(httpClient);
	}

	@Override
	@AsyncRequestHandler
	public Map<String, Object> enviaPeticion(Map<String, Object> params) throws ErrorServicioWebcom {
		return send(params);
	}
	
	@Override
	@AsyncResponseHandler
	public void procesaRespuesta(Map<String, Object> respuesta) {
		this.receive(respuesta);
		
	}

}
