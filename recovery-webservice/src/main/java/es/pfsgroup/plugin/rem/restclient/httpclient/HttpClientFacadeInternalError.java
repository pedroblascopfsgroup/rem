package es.pfsgroup.plugin.rem.restclient.httpclient;

public class HttpClientFacadeInternalError extends RuntimeException {

	private static final long serialVersionUID = 7956776432423751563L;
	
	public HttpClientFacadeInternalError(String string) {
		super(string);
	}

	public HttpClientFacadeInternalError(String string, Exception e) {
		super(string, e);
	}

	

}
