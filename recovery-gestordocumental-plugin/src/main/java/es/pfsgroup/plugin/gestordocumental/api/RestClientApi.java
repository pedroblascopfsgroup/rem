package es.pfsgroup.plugin.gestordocumental.api;

import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;

public interface RestClientApi {

	
	Object getResponse(ServerRequest serverRequest);
	
}
