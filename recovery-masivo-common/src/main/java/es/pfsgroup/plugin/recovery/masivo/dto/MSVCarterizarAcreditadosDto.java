package es.pfsgroup.plugin.recovery.masivo.dto;

public class MSVCarterizarAcreditadosDto {
	
	private String acreditadoCif;
	private String gestorUsername;
	private Long procesoMasivoId;
	private String usuariocrear;
	
	
	public String getAcreditadoCif() {
		return acreditadoCif;
	}
	public void setAcreditadoCif(String acreditadoCif) {
		this.acreditadoCif = acreditadoCif;
	}
	public String getGestorUsername() {
		return gestorUsername;
	}
	public void setGestorUsername(String gestorUsername) {
		this.gestorUsername = gestorUsername;
	}
	public Long getProcesoMasivoId() {
		return procesoMasivoId;
	}
	public void setProcesoMasivoId(Long procesoMasivoId) {
		this.procesoMasivoId = procesoMasivoId;
	}
	public String getUsuariocrear() {
		return usuariocrear;
	}
	public void setUsuariocrear(String usuariocrear) {
		this.usuariocrear = usuariocrear;
	}

}
