package es.pfsgroup.plugin.gestorDocumental.manager;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.config.ConfigManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.media.multipart.BodyPart;
import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.springframework.beans.factory.annotation.Autowired;

import javax.annotation.Resource;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Properties;


@Service
public class RestClientManager implements RestClientApi {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	public static final String METHOD_GET = "GET";
	public static final String METHOD_POST = "POST";
	public static final String METHOD_PUT = "PUT";
	public static final String METHOD_DELETE = "DELETE";
	public static final String APPLICATION_JSON = "application/json";
	
	private static final String PROPIEDAD_ACTIVAR_REST_CLIENT = "rest.client.gestor.documental.activar";
	
	@Autowired
	private ConfigManager configManager;
	@Resource
	private Properties appProperties;

	@Override
	public Object getResponse(ServerRequest serverRequest) {
		
		String restClientUrl = appProperties.getProperty(serverRequest.getRestClientUrl());
		
		final Client client = ClientBuilder.newBuilder().register(MultiPartFeature.class).register(JacksonFeature.class).build();
		String url = restClientUrl + serverRequest.getPath();
		url = url.replaceAll("%7B", "{");
		url = url.replaceAll("%7D", "}");
		url = url.replaceAll("\"", "%22");
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
					if(!Checks.esNulo(body)){
						logger.debug("\nBodypart["+i+"]: "+body.getContentDisposition().toString()+"="+body.getEntity().toString());
					}
				}
			}
		}

		try {
			if (METHOD_GET.equals(serverRequest.getMethod())) {			
				response = webTarget.request().get();
			} else if (METHOD_POST.equals(serverRequest.getMethod())) {
				response = webTarget.request().post(Entity.entity(serverRequest.getMultipart(), serverRequest.getMultipart().getMediaType()));
			} else if (METHOD_PUT.equals(serverRequest.getMethod())) {			
				response = webTarget.request().put(Entity.entity("{}", APPLICATION_JSON));	
			} else if (METHOD_DELETE.equals(serverRequest.getMethod())) {			
				//response = webTarget.request().delete();			
			}
		} catch(Exception e) {			
			logger.warn("No se ha podido conectar con el servidor del gestor documental.");
			logger.warn("Cause: "+e.getCause());
			e.printStackTrace();
		}
		
		logger.debug("--------------------------");
	    
		if (response == null) return null;
		return response.readEntity(serverRequest.getResponseClass());
	}
	

	@Override
	public boolean modoRestClientActivado() {
		Boolean activado = Boolean.valueOf(appProperties.getProperty(PROPIEDAD_ACTIVAR_REST_CLIENT));
		if (activado == null) {
			activado = false;
		}
		return activado;
	}
	
	@Override
	public Object getBinaryResponse(ServerRequest serverRequest) {
		String restClientUrl = appProperties.getProperty(serverRequest.getRestClientUrl());
		String limite = configManager.getConfigByKey("documentos.max.size").getValor();
		int limiteTotal = Integer.parseInt(limite);
		final Client client = ClientBuilder.newBuilder().register(MultiPartFeature.class).register(JacksonFeature.class).build();
		String url = restClientUrl + serverRequest.getPath();
		WebTarget webTarget = client.target(url);
		logger.info("URL: " + url);
		Object response = webTarget.request().get();
		
		if (response == null) return null;
		Response res = (Response) response;
		InputStream is = (InputStream)res.getEntity();
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		int nRead,totalLeido = 0;
	    byte[] data = new byte[1024];
	    try {
		    while ((nRead = is.read(data, 0, data.length)) != -1) {
		    	totalLeido += nRead;
		    	if(limiteTotal == 0 || totalLeido < limiteTotal*1024*1024) {
		    		buffer.write(data, 0, nRead);
		    	}else {
		    		logger.error("RestClientManager: No se puede descargar ficheros mayores a " + limiteTotal + "Mb");
		    		return (String)("No se puede descargar ficheros mayores a " + limiteTotal + "Mb");
		    	}
		    }
		 
		    buffer.flush();
			byte[] bytes = buffer.toByteArray();
			buffer.close();
			is.close();
			return bytes;
		} catch (IOException e) {
			logger.error("RestClientManager : Error al recoger bytes del archivo - " +e);
			return null;
		}
	}
	
}