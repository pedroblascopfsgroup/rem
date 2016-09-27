package es.pfsgroup.plugin.rem.restclient.httpclient;

public class HttpClientException extends Exception {

	private static final long serialVersionUID = 8137852228408636977L;
	
	
	private Integer responseCode;
	
	public HttpClientException(String errorMsg, Integer responseCode) {
		super(errorMsg);
		this.responseCode = responseCode;
	}

	public HttpClientException(String errorMsg, Integer responseCode, Exception e) {
		super(errorMsg, e);
		this.responseCode = responseCode;
	}

	public Integer getResponseCode() {
		return responseCode;
	}

	@Override
	public String getMessage() {
		return super.getMessage() + "[errCode= " + responseCode + "]";
	}

}
