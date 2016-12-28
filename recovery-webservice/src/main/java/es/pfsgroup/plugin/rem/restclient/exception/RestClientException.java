package es.pfsgroup.plugin.rem.restclient.exception;

public class RestClientException extends Exception {
	private static final long serialVersionUID = 777435050968060924L;

	public RestClientException(String mensaje) {
		super(mensaje);

	}
	
	public RestClientException() {
		super();

	}

}
