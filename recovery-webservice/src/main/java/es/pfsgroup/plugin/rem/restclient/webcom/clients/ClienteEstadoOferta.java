package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

@Component
public class ClienteEstadoOferta extends ClienteWebcomBase implements ClienteWebcom{
	
	@Autowired
	private HttpClientFacade httpClient;
	
	public ClienteEstadoOferta(){
		this.setEndpoint(WebcomEndpoint.estadoOferta());
		this.setHttpClient(httpClient);
	}
	

	@Override
	public Map<String, Object> enviaPeticion(Map<String, Object> params) throws ErrorServicioWebcom {
		return this.send(params);
	}

	@Override
	public void procesaRespuesta(Map<String, Object> respuesta) {
		this.receive(respuesta);
		
	}

}
