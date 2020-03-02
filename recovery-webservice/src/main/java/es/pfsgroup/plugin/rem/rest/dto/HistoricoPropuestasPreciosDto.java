package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class HistoricoPropuestasPreciosDto implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idPeticion;
	private Long idActivo;
	private String tipoFecha;
	private String fechaSolicitud;
	private String fechaSancion;
	private String observaciones;
	private String usuarioModificar;
	private Boolean esEditable;
	
	public Long getIdPeticion() {
		return idPeticion;
	}
	
	public void setIdPeticion(Long idPeticion) {
		this.idPeticion = idPeticion;
	}
	
	public Long getIdActivo() {
		return idActivo;
	}
	
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	
	public String getTipoFecha() {
		return tipoFecha;
	}
	
	public void setTipoFecha(String tipoFecha) {
		this.tipoFecha = tipoFecha;
	}
	
	public String getFechaSolicitud() {
		return fechaSolicitud;
	}
	
	public void setFechaSolicitud(String fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	
	public String getFechaSancion() {
		return fechaSancion;
	}
	
	public void setFechaSancion(String fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	
	public String getObservaciones() {
		return observaciones;
	}
	
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	public String getUsuarioModificar() {
		return usuarioModificar;
	}
	
	public void setUsuarioModificar(String usuarioModificar) {
		this.usuarioModificar = usuarioModificar;
	}
	
	public Boolean getEsEditable() {
		return esEditable;
	}
	
	public void setEsEditable(Boolean esEditable) {
		this.esEditable = esEditable;
	}
	
	
}
