package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class ResponseDto implements Serializable {

	private static final long serialVersionUID = -5915553543371631622L;
	
	private String id;
	private String error;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}


}
