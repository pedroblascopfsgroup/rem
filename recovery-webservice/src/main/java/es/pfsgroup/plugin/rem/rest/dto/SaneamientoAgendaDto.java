package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class SaneamientoAgendaDto implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idSan;
	private Long idActivo;
	private String tipologiaCod;
	private String tipologiaDesc;
	private String subtipologiacod;
	private String subtipologiaDesc;
	private String observaciones;
	private String usuariocrear;
	private String fechaCrear;
	
	public Long getIdSan() {
		return idSan;
	}
	public void setIdSan(Long idSan) {
		this.idSan = idSan;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getTipologiaCod() {
		return tipologiaCod;
	}
	public void setTipologiaCod(String tipologiaCod) {
		this.tipologiaCod = tipologiaCod;
	}
	public String getTipologiaDesc() {
		return tipologiaDesc;
	}
	public void setTipologiaDesc(String tipologiaDesc) {
		this.tipologiaDesc = tipologiaDesc;
	}
	public String getSubtipologiacod() {
		return subtipologiacod;
	}
	public void setSubtipologiacod(String subtipologiacod) {
		this.subtipologiacod = subtipologiacod;
	}
	public String getSubtipologiaDesc() {
		return subtipologiaDesc;
	}
	public void setSubtipologiaDesc(String subtipologiaDesc) {
		this.subtipologiaDesc = subtipologiaDesc;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getUsuariocrear() {
		return usuariocrear;
	}
	public void setUsuariocrear(String usuariocrear) {
		this.usuariocrear = usuariocrear;
	}
	public String getFechaCrear() {
		return fechaCrear;
	}
	public void setFechaCrear(String fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
	
}
