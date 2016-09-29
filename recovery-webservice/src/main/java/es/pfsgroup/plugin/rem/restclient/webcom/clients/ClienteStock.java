package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;

@Component
public class ClienteStock extends ClienteWebcomBase{
	
	@Autowired
	private HttpClientFacade httpClient;
	
	@Resource
	private Properties appProperties;

	@Override
	@AsyncRequestHandler
	public Map<String, Object> enviaPeticion(ParamsList paramsList,  RestLlamada registroLlamada) throws ErrorServicioWebcom {
		return this.send(httpClient, WebcomEndpoint.stock(appProperties), paramsList, registroLlamada);
	}

	@Override
	@AsyncResponseHandler
	public void procesaRespuesta(Map<String, Object> respuesta) {
		this.receive(respuesta);
		
	}
	
	@Override
	protected Properties getAppProperties() {
		return appProperties;
	}

}
