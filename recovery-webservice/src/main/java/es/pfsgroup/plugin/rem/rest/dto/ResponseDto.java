package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class ResponseDto implements Serializable {

	private static final long serialVersionUID = -5915553543371631622L;
	
	private String id;
	private DataDto data;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public DataDto getData() {
		return data;
	}
	public void setData(DataDto data) {
		this.data = data;
	}
	
	
	

}
