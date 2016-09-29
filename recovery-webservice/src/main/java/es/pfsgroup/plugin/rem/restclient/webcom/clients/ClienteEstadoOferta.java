package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

@Component
public class ClienteEstadoOferta extends ClienteWebcomBase{
	
	
	@Autowired
	private HttpClientFacade httpClient;
	
	@Resource
	private Properties appProperties;
	
	@Override
	@AsyncRequestHandler
	public Map<String, Object> enviaPeticion(ParamsList paramsList, RestLlamada registroLlamada) throws ErrorServicioWebcom {
		return this.send(httpClient, WebcomEndpoint.estadoOferta(appProperties), paramsList, registroLlamada);
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
