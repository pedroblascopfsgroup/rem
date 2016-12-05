package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class AuthtokenRequest implements Serializable {

	private static final long serialVersionUID = -4025784384532591264L;
	private String app_id;
	private String app_secret;

	public String getApp_id() {
		return app_id;
	}

	public void setApp_id(String app_id) {
		this.app_id = app_id;
	}

	public String getApp_secret() {
		return app_secret;
	}

	public void setApp_secret(String app_secret) {
		this.app_secret = app_secret;
	}

}
