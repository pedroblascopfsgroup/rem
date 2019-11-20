package es.pfsgroup.plugin.rem.restclient.httpsclient;

public class HttpsClientInternalError extends RuntimeException {

	private static final long serialVersionUID = 7956776432423751563L;
	
	public HttpsClientInternalError(String string) {
		super(string);
	}

	public HttpsClientInternalError(String string, Exception e) {
		super(string, e);
	}

	

}
