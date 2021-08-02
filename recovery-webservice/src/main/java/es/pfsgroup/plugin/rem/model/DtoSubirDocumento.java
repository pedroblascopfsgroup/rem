package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import es.pfsgroup.plugin.rem.model.dd.DDTerritorio;

public class DtoSubirDocumento extends DtoTabActivo{

	private static final long serialVersionUID = 1L;

	private String aplica;
	private String fechaEmision;
	private String fechaCaducidad;
	private String fechaObtencion;
	private String fechaEtiqueta;
	private String calificacionEnergetica;
	private String registro;
	
	public String getAplica() {
		return aplica;
	}
	public void setAplica(String aplica) {
		this.aplica = aplica;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getFechaCaducidad() {
		return fechaCaducidad;
	}
	public void setFechaCaducidad(String fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}
	public String getFechaObtencion() {
		return fechaObtencion;
	}
	public void setFechaObtencion(String fechaObtencion) {
		this.fechaObtencion = fechaObtencion;
	}
	public String getFechaEtiqueta() {
		return fechaEtiqueta;
	}
	public void setFechaEtiqueta(String fechaEtiqueta) {
		this.fechaEtiqueta = fechaEtiqueta;
	}
	public String getRegistro() {
		return registro;
	}
	public void setRegistro(String registro) {
		this.registro = registro;
	}
	public String getCalificacionEnergetica() {
		return calificacionEnergetica;
	}
	public void setCalificacionEnergetica(String calificacionEnergetica) {
		this.calificacionEnergetica = calificacionEnergetica;
	}

	

	


}
