package es.pfsgroup.plugin.rem.restclient.httpclient;

public class HttpClientException extends Exception {

	private Integer responseCode;

	public HttpClientException(String errorMsg, Integer responseCode, Exception e) {
		super(errorMsg, e);
		this.responseCode = responseCode;
	}

	public Integer getResponseCode() {
		return responseCode;
	}

}
