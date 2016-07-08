package es.pfsgroup.plugin.gestorDocumental.manager;

import java.util.List;
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
import org.glassfish.jersey.media.multipart.BodyPart;
import org.glassfish.jersey.media.multipart.MultiPartFeature;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;


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
		
		logger.debug("--------------------------");
		logger.debug(" RestClient REQUEST");
		logger.debug("--------------------------");
		logger.debug("Method: "+serverRequest.getMethod());
		logger.debug("\nUrl = "+url);		
		if (serverRequest.getMultipart() != null) {
			List<BodyPart> parts = serverRequest.getMultipart().getBodyParts();
			if (parts != null) {
				logger.debug("Posted:");
				for (int i=0;i<parts.size();i++){
					BodyPart body = parts.get(i);
					logger.debug("\nBodypart["+i+"]: "+body.getContentDisposition().toString()+"="+body.getEntity().toString());
				}
			}
		}

		try {
			if (METHOD_GET.equals(serverRequest.getMethod())) {			
				response = webTarget.request().get();
			} else if (METHOD_POST.equals(serverRequest.getMethod())) {
				response = webTarget.request().post(Entity.entity(serverRequest.getMultipart(), serverRequest.getMultipart().getMediaType()));
			} else if (METHOD_PUT.equals(serverRequest.getMethod())) {			
				response = webTarget.request().put(Entity.entity(serverRequest.getMultipart(), serverRequest.getMultipart().getMediaType()));	
			} else if (METHOD_DELETE.equals(serverRequest.getMethod())) {			
				//response = webTarget.request().delete();			
			}
		} catch(Exception e) {			
			logger.warn("No se ha podido conectar con el servidor del gestor documental.");
			logger.warn("Cause: "+e.getCause());
		}
		
		logger.debug("--------------------------");
	    
		if (response == null) return null;
		return response.readEntity(serverRequest.getResponseClass());
	}
	
	
}
