package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class OperationResult implements Serializable {

	private static final long serialVersionUID = -1239707939595202785L;
	private boolean success;

	public boolean getSuccess() {
		return success;
	}

	public void setSuccess(boolean succes) {
		this.success = succes;
	}

}