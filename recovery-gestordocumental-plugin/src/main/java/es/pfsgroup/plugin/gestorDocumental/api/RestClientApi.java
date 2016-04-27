package es.pfsgroup.plugin.gestorDocumental.api;

import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;

public interface RestClientApi {

	
	Object getResponse(ServerRequest serverRequest);
	
}
