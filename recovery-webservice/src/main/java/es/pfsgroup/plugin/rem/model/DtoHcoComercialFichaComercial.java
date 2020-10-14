package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoHcoComercialFichaComercial extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5644535812738414346L;
	
	Date fecha;
	String numActivo;
	String numOferta;
	String fechaSancion;
	String ofertante;
	String estado;
	String desestimado;
	String motivoDesestimiento;
	String ffrr;
	Double oferta;
	Double pvpComite;
	Double tasacion;
	
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(String numOferta) {
		this.numOferta = numOferta;
	}
	public String getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(String fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	public String getOfertante() {
		return ofertante;
	}
	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getDesestimado() {
		return desestimado;
	}
	public void setDesestimado(String desestimado) {
		this.desestimado = desestimado;
	}
	public String getMotivoDesestimiento() {
		return motivoDesestimiento;
	}
	public void setMotivoDesestimiento(String motivoDesestimiento) {
		this.motivoDesestimiento = motivoDesestimiento;
	}
	public String getFfrr() {
		return ffrr;
	}
	public void setFfrr(String ffrr) {
		this.ffrr = ffrr;
	}
	public Double getOferta() {
		return oferta;
	}
	public void setOferta(Double oferta) {
		this.oferta = oferta;
	}
	public Double getPvpComite() {
		return pvpComite;
	}
	public void setPvpComite(Double pvpComite) {
		this.pvpComite = pvpComite;
	}
	public Double getTasacion() {
		return tasacion;
	}
	public void setTasacion(Double tasacion) {
		this.tasacion = tasacion;
	}

}
