package es.pfsgroup.plugin.recovery.masivo.dto;

public class MSVAltaCargaDocDto {

	private Long idProceso;
	private Long idEstadoProceso;
	private String descripcion;
	private String codigoEstadoProceso;
	private Long token;
	
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}

	public Long getIdProceso() {
		return idProceso;
	}

	public void setIdEstadoProceso(Long idEstadoProceso) {
		this.idEstadoProceso = idEstadoProceso;
	}

	public Long getIdEstadoProceso() {
		return idEstadoProceso;
	}

	public void setCodigoEstadoProceso(String codigoEstadoProceso) {
		this.codigoEstadoProceso = codigoEstadoProceso;
	}

	public String getCodigoEstadoProceso() {
		return codigoEstadoProceso;
	}

	public Long getToken() {
		return token;
	}

	public void setToken(Long token) {
		this.token = token;
	}
}
