package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoActualizacionRenta {

	private Long id;
	private Date fechaAplicacion;
	private String tipoActualizacionCodigo;
	private Double incrementoRenta;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getFechaAplicacion() {
		return fechaAplicacion;
	}
	public void setFechaAplicacion(Date fechaAplicacion) {
		this.fechaAplicacion = fechaAplicacion;
	}
	public String getTipoActualizacionCodigo() {
		return tipoActualizacionCodigo;
	}
	public void setTipoActualizacionCodigo(String tipoActualizacionCodigo) {
		this.tipoActualizacionCodigo = tipoActualizacionCodigo;
	}
	public Double getIncrementoRenta() {
		return incrementoRenta;
	}
	public void setIncrementoRenta(Double incrementoRenta) {
		this.incrementoRenta = incrementoRenta;
	}

}