package es.pfsgroup.plugin.rem.restclient.webcom.clients;

public class WebcomEndpoint {
	
	private WebcomEndpoint(){};
	
	public static WebcomEndpoint estadoTrabajo() {
		return new WebcomEndpoint();
	}
	
	public static WebcomEndpoint estadoOferta() {
		return new WebcomEndpoint();
	}
	
	
	public String getCharset() {
		return "UTF-8";
	}

	public int getTimeout() {
		return 10;
	}

	public String getHttpMethod() {
		return "POST";
	}

	public String getEndpointUrl() {
		return "http://test/test";
	}

	public String getApiKey() {
		return "0123456789";
	}
}
