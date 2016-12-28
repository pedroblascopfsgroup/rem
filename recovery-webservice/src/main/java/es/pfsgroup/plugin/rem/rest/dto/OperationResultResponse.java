package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class OperationResultResponse implements Serializable{

	private static final long serialVersionUID = -4930578951680110911L;
	private String error;
	private OperationResult data;
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
	public OperationResult getData() {
		return data;
	}
	public void setData(OperationResult data) {
		this.data = data;
	}
	

}
