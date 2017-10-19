package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.sql.Date;

import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoDenegacionResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDPenitenciales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;

public class ResolucionComiteBankiaDto implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	

	private ExpedienteComercial expediente;
	private DDTipoResolucion tipoResolucion;
	private DDComiteSancion comite;	
	private DDEstadoResolucion estadoResolucion;
	private DDMotivoDenegacionResolucion motivoDenegacion;
	private Date fechaAnulacion;
	private Double importeContraoferta;
	private DDPenitenciales penitenciales;
	private DDMotivoAnulacionExpediente motivoAnulacionExpediente;
	
	
	public ExpedienteComercial getExpediente() {
		return expediente;
	}
	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}
	public DDTipoResolucion getTipoResolucion() {
		return tipoResolucion;
	}
	public void setTipoResolucion(DDTipoResolucion tipoResolucion) {
		this.tipoResolucion = tipoResolucion;
	}
	public DDComiteSancion getComite() {
		return comite;
	}
	public void setComite(DDComiteSancion comite) {
		this.comite = comite;
	}
	public DDEstadoResolucion getEstadoResolucion() {
		return estadoResolucion;
	}
	public void setEstadoResolucion(DDEstadoResolucion estadoResolucion) {
		this.estadoResolucion = estadoResolucion;
	}
	public DDMotivoDenegacionResolucion getMotivoDenegacion() {
		return motivoDenegacion;
	}
	public void setMotivoDenegacion(DDMotivoDenegacionResolucion motivoDenegacion) {
		this.motivoDenegacion = motivoDenegacion;
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
	public DDPenitenciales getPenitenciales() {
		return penitenciales;
	}
	public void setPenitenciales(DDPenitenciales penitenciales) {
		this.penitenciales = penitenciales;
	}
	public DDMotivoAnulacionExpediente getMotivoAnulacionExpediente() {
		return motivoAnulacionExpediente;
	}
	public void setMotivoAnulacionExpediente(DDMotivoAnulacionExpediente motivoAnulacionExpediente) {
		this.motivoAnulacionExpediente = motivoAnulacionExpediente;
	}

	
	
	
}
