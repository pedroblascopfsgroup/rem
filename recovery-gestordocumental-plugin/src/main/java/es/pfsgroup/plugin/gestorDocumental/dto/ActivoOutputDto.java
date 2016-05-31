package es.pfsgroup.plugin.gestorDocumental.dto;

public class ActivoOutputDto {

	private String resultCode;
	private String resultDescription;
	private String idActivoHaya;
	private String idActivoOrigen;

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
	
	public String getIdActivoHaya() {
		return idActivoHaya;
	}
	
	public void setIdActivoHaya(String idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	
	public String getIdActivoOrigen() {
		return idActivoOrigen;
	}
	
	public void setIdActivoOrigen(String idActivoOrigen) {
		this.idActivoOrigen = idActivoOrigen;
	}

}
