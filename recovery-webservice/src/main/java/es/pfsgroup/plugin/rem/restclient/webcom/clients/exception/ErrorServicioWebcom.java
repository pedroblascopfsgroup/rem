package es.pfsgroup.plugin.rem.restclient.webcom.clients.exception;

import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;

public class ErrorServicioWebcom extends Exception {

	private static final long serialVersionUID = 4198653272997446083L;
	
	public static final String INVALID_SIGNATURE = "INVALID_SIGNATURE";
	public static final String REPEATED_REQUEST = "REPEATED_REQUEST";
	public static final String MISSING_REQUIRED_FIELDS = "MISSING_REQUIRED_FIELDS";
	public static final String UNKNOWN_KEY = "UNKNOWN_KEY";
	
	public static final String HTTP_ERROR = "HTTP_ERROR (code=%code%)";
	public static final String UNKNOWN_ERROR = "UNKNOWN_ERROR";

	private String errorWebcom;
	
	private boolean httpError = false;
	
	private boolean reintentable;
	

	public ErrorServicioWebcom(HttpClientException e) {
		super(e);
		if (e.getResponseCode() != null){
			this.errorWebcom = HTTP_ERROR.replaceAll("%code%", e.getResponseCode().toString());
		}
		httpError = true;
	}
	
	
	public ErrorServicioWebcom(String error){
		super(error);
		this.errorWebcom = error;
	}
	

	public String getErrorWebcom() {
		return this.errorWebcom;
	}


	public boolean isHttpError() {
		return httpError;
	}


	public boolean isReintentable() {
		return reintentable;
	}


	public void setReintentable(boolean reintentable) {
		this.reintentable = reintentable;
	}

}
