package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoActualizacionRenta {

	private Long id;
	private Date fechaActualizacion;
	private String tipoActualizacionCodigo;
	private Double importeActualizacion;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getFechaActualizacion() {
		return fechaActualizacion;
	}
	public void setFechaActualizacion(Date fechaActualizacion) {
		this.fechaActualizacion = fechaActualizacion;
	}
	public String getTipoActualizacionCodigo() {
		return tipoActualizacionCodigo;
	}
	public void setTipoActualizacionCodigo(String tipoActualizacionCodigo) {
		this.tipoActualizacionCodigo = tipoActualizacionCodigo;
	}
	public Double getImporteActualizacion() {
		return importeActualizacion;
	}
	public void setImporteActualizacion(Double importeActualizacion) {
		this.importeActualizacion = importeActualizacion;
	}
	
	
	
}