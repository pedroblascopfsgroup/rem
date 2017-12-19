package es.pfsgroup.plugin.rem.api.services.webcom;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;

public class ErrorServicioEnEjecucion extends Exception {

	private static final long serialVersionUID = 4198653272997446083L;
	
	private String errorWebcom;
	
	

	public ErrorServicioEnEjecucion(HttpClientException e) {
		super(e);		
	}
	
	
	public ErrorServicioEnEjecucion(String error){
		super(error);
		this.errorWebcom = error;
	}
	

	public String getErrorWebcom() {
		return this.errorWebcom;
	}

}
