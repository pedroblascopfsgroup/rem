package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class RequestDto implements Serializable {
	private static final long serialVersionUID = -4554019055402743449L;
	
	@JsonProperty(required = true)
	private String id;
	@JsonProperty(required = false)
	private String workingcode;
	


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getWorkingcode() {
		return workingcode;
	}

	public void setWorkingcode(String workingcode) {
		this.workingcode = workingcode;
	}

}
