package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.pfsgroup.commons.utils.Checks;

public class DtoHistoricoPrecios {	
	
	private String tipo;
	
	private String descripcionTipoPrecio;
		
	private Double importe;
	
	private Date fechaAprobacion;
	
	private Date fechaCarga;
	
	private Date fechaInicio;
	
	private Date fechaFin;
	
	private String gestor;
	
	private String observaciones;
	
	public DtoHistoricoPrecios() {};

	public DtoHistoricoPrecios(ActivoHistoricoValoraciones historico) {
		
		this.tipo=historico.getTipoPrecio().getTipo();
		this.descripcionTipoPrecio=historico.getTipoPrecio().getDescripcion();
		this.importe = historico.getImporte();
		this.fechaAprobacion = historico.getFechaAprobacion();
		this.fechaCarga=historico.getFechaCarga();
		this.fechaFin=historico.getFechaFin();
		this.fechaInicio=historico.getFechaInicio();
		if(!Checks.esNulo(historico.getGestor())) {
			this.gestor=historico.getGestor().getApellidoNombre();
		}
		this.observaciones=historico.getObservaciones();		
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getDescripcionTipoPrecio() {
		return descripcionTipoPrecio;
	}

	public void setDescripcionTipoPrecio(String descripcionTipoPrecio) {
		this.descripcionTipoPrecio = descripcionTipoPrecio;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFechaAprobacion() {
		return fechaAprobacion;
	}

	public void setFechaAprobacion(Date fechaAprobacion) {
		this.fechaAprobacion = fechaAprobacion;
	}

	public Date getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	

}
