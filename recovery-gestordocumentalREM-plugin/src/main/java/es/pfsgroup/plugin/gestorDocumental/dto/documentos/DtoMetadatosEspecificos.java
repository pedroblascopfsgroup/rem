package es.pfsgroup.plugin.gestorDocumental.dto.documentos;

import java.util.Date;

public class DtoMetadatosEspecificos{

	private static final long serialVersionUID = 1L;

	private Boolean aplica;
	private Date fechaEmision;
	private Date fechaCaducidad;
	private Date fechaObtencion;
	private Date fechaEtiqueta;
	private String registro;
	

	public Boolean getAplica() {
		return aplica;
	}
	public void setAplica(Boolean aplica) {
		this.aplica = aplica;
	}
	public Date getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public Date getFechaCaducidad() {
		return fechaCaducidad;
	}
	public void setFechaCaducidad(Date fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}
	public Date getFechaObtencion() {
		return fechaObtencion;
	}
	public void setFechaObtencion(Date fechaObtencion) {
		this.fechaObtencion = fechaObtencion;
	}
	public Date getFechaEtiqueta() {
		return fechaEtiqueta;
	}
	public void setFechaEtiqueta(Date fechaEtiqueta) {
		this.fechaEtiqueta = fechaEtiqueta;
	}
	public String getRegistro() {
		return registro;
	}
	public void setRegistro(String registro) {
		this.registro = registro;
	}


}
