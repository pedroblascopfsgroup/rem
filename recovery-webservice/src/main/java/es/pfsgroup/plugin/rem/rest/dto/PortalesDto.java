package es.pfsgroup.plugin.rem.rest.dto;

import java.util.Date;

public class PortalesDto {
	
	private Date fechaAccion;
	private Long idUsuarioRemAccion;
	private Long idActivoHaya;
	private Boolean publicado;
				
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public Long getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public Boolean getPublicado() {
		return publicado;
	}
	public void setPublicado(Boolean publicado) {
		this.publicado = publicado;
	}

}
