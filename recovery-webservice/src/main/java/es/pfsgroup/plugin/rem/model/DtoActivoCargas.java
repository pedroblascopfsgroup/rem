package es.pfsgroup.plugin.rem.model;

import java.util.Date;




/**
 * Dto para el grid de cargas y los bloques de la pestaña relacionados
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoCargas {

/*
 * DDTIPOCARGA
    private DDSubtipoCarga subtipoCarga; 
    private DDSituacionCarga situacionCarga;
    ORDEN 
  */
	
	
    private Date fechaRevision;
    private String descripcionCarga;
    private Long idCarga;
    private String titular;
    private String importeRegistral;
    private String importeEconomico;
    private Date fechaPresentacion;
    private Date fechaInscripcion;
    private Date fechaCancelacion;
    private Date fechaCancelacionRegistral;
    private String ordenCarga;
    
    // Mapeados a mano
    private String subtipoCargaCodigo;
    private String situacionCargaCodigo;
    private String tipoCargaCodigo;
    
    // Descripción Carga y Subtipo Carga
    private String subtipoCargaDesc;
    private String tipoCargaDesc;
    private String subtipoCargaDescEconomica;
    private String tipoCargaDescEconomica;    
    
    // Mapeados a mano por duplicidad
    private String subtipoCargaCodigoEconomica;
    private String situacionCargaCodigoEconomica;
    private String tipoCargaCodigoEconomica;
    private String descripcionCargaEconomica;
    private String titularEconomica;
    private String importeEconomicoEconomica;
    private Date fechaCancelacionEconomica;
    
	public Date getFechaRevision() {
		return fechaRevision;
	}
	public void setFechaRevision(Date fechaRevision) {
		this.fechaRevision = fechaRevision;
	}
	public String getDescripcionCarga() {
		return descripcionCarga;
	}
	public void setDescripcionCarga(String descripcionCarga) {
		this.descripcionCarga = descripcionCarga;
	}
	public Long getIdCarga() {
		return idCarga;
	}
	public void setIdCarga(Long idCarga) {
		this.idCarga = idCarga;
	}
	public String getTitular() {
		return titular;
	}
	public void setTitular(String titular) {
		this.titular = titular;
	}
	public String getImporteRegistral() {
		return importeRegistral;
	}
	public void setImporteRegistral(String importeRegistral) {
		this.importeRegistral = importeRegistral;
	}
	public String getImporteEconomico() {
		return importeEconomico;
	}
	public void setImporteEconomico(String importeEconomico) {
		this.importeEconomico = importeEconomico;
	}
	public Date getFechaPresentacion() {
		return fechaPresentacion;
	}
	public void setFechaPresentacion(Date fechaPresentacion) {
		this.fechaPresentacion = fechaPresentacion;
	}
	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public Date getFechaCancelacion() {
		return fechaCancelacion;
	}
	public void setFechaCancelacion(Date fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}
	public Date getFechaCancelacionRegistral() {
		return fechaCancelacionRegistral;
	}
	public void setFechaCancelacionRegistral(Date fechaCancelacionRegistral) {
		this.fechaCancelacionRegistral = fechaCancelacionRegistral;
	}
	public String getSubtipoCargaCodigo() {
		return subtipoCargaCodigo;
	}
	public void setSubtipoCargaCodigo(String subtipoCargaCodigo) {
		this.subtipoCargaCodigo = subtipoCargaCodigo;
	}
	public String getSituacionCargaCodigo() {
		return situacionCargaCodigo;
	}
	public void setSituacionCargaCodigo(String situacionCargaCodigo) {
		this.situacionCargaCodigo = situacionCargaCodigo;
	}
	public String getTipoCargaCodigo() {
		return tipoCargaCodigo;
	}
	public void setTipoCargaCodigo(String tipoCargaCodigo) {
		this.tipoCargaCodigo = tipoCargaCodigo;
	}
	public String getSubtipoCargaCodigoEconomica() {
		return subtipoCargaCodigoEconomica;
	}
	public void setSubtipoCargaCodigoEconomica(String subtipoCargaCodigoEconomica) {
		this.subtipoCargaCodigoEconomica = subtipoCargaCodigoEconomica;
	}
	public String getSituacionCargaCodigoEconomica() {
		return situacionCargaCodigoEconomica;
	}
	public void setSituacionCargaCodigoEconomica(
			String situacionCargaCodigoEconomica) {
		this.situacionCargaCodigoEconomica = situacionCargaCodigoEconomica;
	}
	public String getTipoCargaCodigoEconomica() {
		return tipoCargaCodigoEconomica;
	}
	public void setTipoCargaCodigoEconomica(String tipoCargaCodigoEconomica) {
		this.tipoCargaCodigoEconomica = tipoCargaCodigoEconomica;
	}
	public String getDescripcionCargaEconomica() {
		return descripcionCargaEconomica;
	}
	public void setDescripcionCargaEconomica(String descripcionCargaEconomica) {
		this.descripcionCargaEconomica = descripcionCargaEconomica;
	}
	public String getTitularEconomica() {
		return titularEconomica;
	}
	public void setTitularEconomica(String titularEconomica) {
		this.titularEconomica = titularEconomica;
	}
	public String getImporteEconomicoEconomica() {
		return importeEconomicoEconomica;
	}
	public void setImporteEconomicoEconomica(String importeEconomicoEconomica) {
		this.importeEconomicoEconomica = importeEconomicoEconomica;
	}
	public Date getFechaCancelacionEconomica() {
		return fechaCancelacionEconomica;
	}
	public void setFechaCancelacionEconomica(Date fechaCancelacionEconomica) {
		this.fechaCancelacionEconomica = fechaCancelacionEconomica;
	}
	public String getOrdenCarga() {
		return ordenCarga;
	}
	public void setOrdenCarga(String ordenCarga) {
		this.ordenCarga = ordenCarga;
	}
	
	public String getSubtipoCargaDesc() {
		return subtipoCargaDesc;
	}
	public void setSubtipoCargaDesc(String subtipoCargaDesc) {
		this.subtipoCargaDesc = subtipoCargaDesc;
	}
	public String getTipoCargaDesc() {
		return tipoCargaDesc;
	}
	public void setTipoCargaDesc(String tipoCargaDesc) {
		this.tipoCargaDesc = tipoCargaDesc;
	}
	public String getSubtipoCargaDescEconomica() {
		return subtipoCargaDescEconomica;
	}
	public void setSubtipoCargaDescEconomica(String subtipoCargaDescEconomica) {
		this.subtipoCargaDescEconomica = subtipoCargaDescEconomica;
	}
	public String getTipoCargaDescEconomica() {
		return tipoCargaDescEconomica;
	}
	public void setTipoCargaDescEconomica(String tipoCargaDescEconomica) {
		this.tipoCargaDescEconomica = tipoCargaDescEconomica;
	}
    
}