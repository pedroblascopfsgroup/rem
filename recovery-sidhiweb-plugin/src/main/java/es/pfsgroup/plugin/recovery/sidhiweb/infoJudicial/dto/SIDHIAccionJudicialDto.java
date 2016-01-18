package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto;

public class SIDHIAccionJudicialDto {

	private String tipoJuicio;
	private Long estadoProcesal;
	private Long subestadoProcesal;
	private String codInterfaz;
	
	// Getters and Setters
	public String getTipoJuicio() {
		return tipoJuicio;
	}
	public void setTipoJuicio(String tipoJuicio) {
		this.tipoJuicio = tipoJuicio;
	}
	public Long getEstadoProcesal() {
		return estadoProcesal;
	}
	public void setEstadoProcesal(Long estadoProcesal) {
		this.estadoProcesal = estadoProcesal;
	}
	public String getCodInterfaz() {
		return codInterfaz;
	}
	public void setCodInterfaz(String codInterfaz) {
		this.codInterfaz = codInterfaz;
	}
	public Long getSubestadoProcesal() {
		return subestadoProcesal;
	}
	public void setSubestadoProcesal(Long subestadoProcesal) {
		this.subestadoProcesal = subestadoProcesal;
	}
	
	
}
