package es.pfsgroup.plugin.gestorDocumental.dto;

import java.io.Serializable;

public class ActivoOutputDto implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String resultCode;
	private String resultDescription;
	private String numActivoUnidadAlquilable;

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}

	public String getResultDescription() {
		return resultDescription;
	}

	public void setResultDescription(String resultDescription) {
		this.resultDescription = resultDescription;
	}
	public String getNumActivoUnidadAlquilable() {
		return numActivoUnidadAlquilable;
	}

	public void setNumActivoUnidadAlquilable(String numActivoUnidadAlquilable) {
		this.numActivoUnidadAlquilable = numActivoUnidadAlquilable;
	}

}
