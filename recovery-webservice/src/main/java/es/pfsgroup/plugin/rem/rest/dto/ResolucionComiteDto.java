package es.pfsgroup.plugin.rem.rest.dto;

import java.sql.Date;

public class ResolucionComiteDto {
	
	private Long ofertaHRE;
	private Long codigoComite;
	private Date fechaComite;
	private Long codigoResolucion;
	private Long codigoDenegacion;
	private Date fechaAnulacion;
	private Double importeContraoferta;
	
	public Long getOfertaHRE() {
		return ofertaHRE;
	}
	public void setOfertaHRE(Long ofertaHRE) {
		this.ofertaHRE = ofertaHRE;
	}
	public Long getCodigoComite() {
		return codigoComite;
	}
	public void setCodigoComite(Long codigoComite) {
		this.codigoComite = codigoComite;
	}
	public Date getFechaComite() {
		return fechaComite;
	}
	public void setFechaComite(Date fechaComite) {
		this.fechaComite = fechaComite;
	}
	public Long getCodigoResolucion() {
		return codigoResolucion;
	}
	public void setCodigoResolucion(Long codigoResolucion) {
		this.codigoResolucion = codigoResolucion;
	}
	public Long getCodigoDenegacion() {
		return codigoDenegacion;
	}
	public void setCodigoDenegacion(Long codigoDenegacion) {
		this.codigoDenegacion = codigoDenegacion;
	}
	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}
	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}
	public Double getImporteContraoferta() {
		return importeContraoferta;
	}
	public void setImporteContraoferta(Double importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
	}

	
	
}
