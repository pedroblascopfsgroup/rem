package es.pfsgroup.plugin.rem.trabajo.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


public class DtoAgendaTrabajo extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idAgenda;
	private Long idTrabajo;
	private String gestorAgenda;
	private String proveedorAgenda;
	private Date fechaAgenda;
	private String tipoGestion;
	private String observacionesAgenda;
	
	public Long getIdAgenda() {
		return idAgenda;
	}
	public void setIdAgenda(Long idAgenda) {
		this.idAgenda = idAgenda;
	}
	public Long getIdTrabajo() {
		return idTrabajo;
	}
	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}
	public String getGestorAgenda() {
		return gestorAgenda;
	}
	public void setGestorAgenda(String gestorAgenda) {
		this.gestorAgenda = gestorAgenda;
	}
	public Date getFechaAgenda() {
		return fechaAgenda;
	}
	public void setFechaAgenda(Date fechaAgenda) {
		this.fechaAgenda = fechaAgenda;
	}
	public String getTipoGestion() {
		return tipoGestion;
	}
	public void setTipoGestion(String tipoGestion) {
		this.tipoGestion = tipoGestion;
	}
	public String getObservacionesAgenda() {
		return observacionesAgenda;
	}
	public void setObservacionesAgenda(String observacionesAgenda) {
		this.observacionesAgenda = observacionesAgenda;
	}
	public String getProveedorAgenda() {
		return proveedorAgenda;
	}
	public void setProveedorAgenda(String proveedorAgenda) {
		this.proveedorAgenda = proveedorAgenda;
	}
	
}