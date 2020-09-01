package es.pfsgroup.plugin.rem.trabajo.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


public class DtoHistorificadorCampos extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idTrabajo;
	private Long idHistorico;
	private String campo;
	private String usuarioModificacion;
	private Date fechaModificacion;
	private String valorAnterior;
	private String valorNuevo;
	



	public String getCampo() {
		return campo;
	}
	public void setCampo(String campo) {
		this.campo = campo;
	}
	public String getUsuarioModificacion() {
		return usuarioModificacion;
	}
	public void setUsuarioModificacion(String usuarioModificacion) {
		this.usuarioModificacion = usuarioModificacion;
	}
	public Date getFechaModificacion() {
		return fechaModificacion;
	}
	public void setFechaModificacion(Date fechaModificacion) {
		this.fechaModificacion = fechaModificacion;
	}
	public String getValorAnterior() {
		return valorAnterior;
	}
	public void setValorAnterior(String valorAnterior) {
		this.valorAnterior = valorAnterior;
	}
	public String getValorNuevo() {
		return valorNuevo;
	}
	public void setValorNuevo(String valorNuevo) {
		this.valorNuevo = valorNuevo;
	}
	public Long getIdTrabajo() {
		return idTrabajo;
	}
	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}
	public Long getIdHistorico() {
		return idHistorico;
	}
	public void setIdHistorico(Long idHistorico) {
		this.idHistorico = idHistorico;
	}

	
	
	
	
	
	
}