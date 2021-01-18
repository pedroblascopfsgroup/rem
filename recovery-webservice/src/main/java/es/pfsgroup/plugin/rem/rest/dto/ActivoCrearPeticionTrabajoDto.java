package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;


public class ActivoCrearPeticionTrabajoDto implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private Long activoId;
	private Long numActivo;
	private String descripcion;
	private String tipoActivo;
	private String tipoActivoCodigo;
	private String subtipoActivo;
	private String subtipoActivoCodigo;
	public Long getActivoId() {
		return activoId;
	}
	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}
	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public String getSubtipoActivo() {
		return subtipoActivo;
	}
	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	
	
}
