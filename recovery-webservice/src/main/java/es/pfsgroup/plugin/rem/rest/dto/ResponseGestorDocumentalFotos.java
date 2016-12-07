package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class ResponseGestorDocumentalFotos implements Serializable {

	private static final long serialVersionUID = -6212330981137393483L;

	public static String ACCESS_DENIED = "ACCESS_DENIED";
	public static String INVALID_JSON = "INVALID_JSON";
	public static String MISSING_REQUIRED_FIELDS = "MISSING_REQUIRED_FIELDS";
	public static String FILE_ERROR = "FILE_ERROR";
	public static String UNKNOWN_ID = "UNKNOWN_ID";

	private String error;
	private Serializable data;

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public Serializable getData() {
		return data;
	}

	public void setData(Serializable data) {
		this.data = data;
	}

}
