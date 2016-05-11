package es.pfsgroup.plugin.gestorDocumental.manager;

import java.util.Properties;

import javax.annotation.Resource;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.media.multipart.MultiPartFeature;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;


@Service
public class RestClientManager implements RestClientApi {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	public static final String METHOD_GET = "GET";
	public static final String METHOD_POST = "POST";
	public static final String METHOD_PUT = "PUT";
	public static final String METHOD_DELETE = "DELETE";
	
	@Resource
	private Properties appProperties;

	@Override
	public Object getResponse(ServerRequest serverRequest) {
		
		String restClientUrl = appProperties.getProperty(serverRequest.getRestClientUrl());
		
		final Client client = ClientBuilder.newBuilder().register(MultiPartFeature.class).register(JacksonFeature.class).build();
		String url = restClientUrl + serverRequest.getPath();
		WebTarget webTarget = client.target(url);
		Response response = null;
		
		if (METHOD_GET.equals(serverRequest.getMethod())) {			
			response = webTarget.request().get();
		} else if (METHOD_POST.equals(serverRequest.getMethod())) {
			response = webTarget.request().post(Entity.entity(serverRequest.getMultipart(), serverRequest.getMultipart().getMediaType()));
		} else if (METHOD_PUT.equals(serverRequest.getMethod())) {			
			response = webTarget.request().put(Entity.entity(serverRequest.getMultipart(), serverRequest.getMultipart().getMediaType()));	
		} else if (METHOD_DELETE.equals(serverRequest.getMethod())) {			
			//response = webTarget.request().delete();			
		}
	    
		if (response == null) return null;
		return response.readEntity(serverRequest.getResponseClass());
	}
	
	
}
