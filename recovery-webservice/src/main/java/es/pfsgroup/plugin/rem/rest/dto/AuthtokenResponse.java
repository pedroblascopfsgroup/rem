package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class AuthtokenResponse implements Serializable {

	private static final long serialVersionUID = -4340432060296787187L;

	private String error;
	private Authtoken data;

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public Authtoken getData() {
		return data;
	}

	public void setData(Authtoken data) {
		this.data = data;
	}

}
