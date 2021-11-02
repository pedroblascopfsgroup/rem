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
    private Long idActivoCarga;
    private String titular;
    private String importeRegistral;
    private String importeEconomico;
    private Date fechaPresentacion;
    private Date fechaInscripcion;
    private Date fechaCancelacion;
    private Date fechaCancelacionRegistral;
    private Date fechaCancelacionEconomica;
    private String ordenCarga;
    private String estadoCodigo;
    private String estadoDescripcion;
    private String subestadoCodigo;
    private String subestadoDescripcion;
    private String estadoEconomicaCodigo;
    private String estadoEconomicaDescripcion;
    private String observaciones;
    private Long idActivo;
    private Integer cargasPropias;
    
    
    
    // Mapeados a mano
    private String subtipoCargaCodigo;
    private String tipoCargaCodigo;
    private String situacionCargaCodigo;

    private String subtipoCargaDescripcion;
    private String tipoCargaDescripcion;
    private String situacionCargaDescripcion;
    
    //HREOS-2733
    private String origenDatoCodigo;
    private String origenDatoDescripcion;
    
    //HREOS-7783
    private String codigoImpideVenta;
    
    //HREOS-15591
    private Date fechaSolicitudCarta;
    private Date fechaRecepcionCarta;
    private Date fechaPresentacionRpCarta;
 

    
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
	public Long getIdActivoCarga() {
		return idActivoCarga;
	}
	public void setIdActivoCarga(Long idActivoCarga) {
		this.idActivoCarga = idActivoCarga;
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
	public Date getFechaCancelacionEconomica() {
		return fechaCancelacionEconomica;
	}
	public void setFechaCancelacionEconomica(Date fechaCancelacionEconomica) {
		this.fechaCancelacionEconomica = fechaCancelacionEconomica;
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
	public String getSubtipoCargaDescripcion() {
		return subtipoCargaDescripcion;
	}
	public void setSubtipoCargaDescripcion(String subtipoCargaDescripcion) {
		this.subtipoCargaDescripcion = subtipoCargaDescripcion;
	}
	public String getTipoCargaDescripcion() {
		return tipoCargaDescripcion;
	}
	public void setTipoCargaDescripcion(String tipoCargaDescripcion) {
		this.tipoCargaDescripcion = tipoCargaDescripcion;
	}
	public String getSituacionCargaDescripcion() {
		return situacionCargaDescripcion;
	}
	public void setSituacionCargaDescripcion(String situacionCargaDescripcion) {
		this.situacionCargaDescripcion = situacionCargaDescripcion;
	}
	public String getOrdenCarga() {
		return ordenCarga;
	}
	public void setOrdenCarga(String ordenCarga) {
		this.ordenCarga = ordenCarga;
	}
	
	public String getEstadoCodigo() {
		return estadoCodigo;
	}
	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}
	public String getEstadoDescripcion() {
		return estadoDescripcion;
	}
	public void setEstadoDescripcion(String estadoDescripcion) {
		this.estadoDescripcion = estadoDescripcion;
	}	
	public String getSubestadoCodigo() {
		return subestadoCodigo;
	}
	public void setSubestadoCodigo(String subEstadoCodigo) {
		this.subestadoCodigo = subEstadoCodigo;
	}
	public String getSubestadoDescripcion() {
		return subestadoDescripcion;
	}
	public void setSubestadoDescripcion(String subEstadoDescripcion) {
		this.subestadoDescripcion = subEstadoDescripcion;
	}
	public String getEstadoEconomicaCodigo() {
		return estadoEconomicaCodigo;
	}
	public void setEstadoEconomicaCodigo(String estadoEconomicaCodigo) {
		this.estadoEconomicaCodigo = estadoEconomicaCodigo;
	}
	public String getEstadoEconomicaDescripcion() {
		return estadoEconomicaDescripcion;
	}
	public void setEstadoEconomicaDescripcion(String estadoEconomicaDescripcion) {
		this.estadoEconomicaDescripcion = estadoEconomicaDescripcion;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getOrigenDatoCodigo() {
		return origenDatoCodigo;
	}
	public void setOrigenDatoCodigo(String origenDato) {
		this.origenDatoCodigo = origenDato;
	}
	public String getOrigenDatoDescripcion() {
		return origenDatoDescripcion;
	}
	public void setOrigenDatoDescripcion(String origenDatoDescripcion) {
		this.origenDatoDescripcion = origenDatoDescripcion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Integer getCargasPropias() {
		return cargasPropias;
	}
	public void setCargasPropias(Integer cargasPropias) {
		this.cargasPropias = cargasPropias;
	}
	public String getCodigoImpideVenta() {
		return codigoImpideVenta;
	}
	public void setCodigoImpideVenta(String codigoImpideVenta) {
		this.codigoImpideVenta = codigoImpideVenta;
	}
	public Date getFechaSolicitudCarta() {
		return fechaSolicitudCarta;
	}
	public void setFechaSolicitudCarta(Date fechaSolicitudCarta) {
		this.fechaSolicitudCarta = fechaSolicitudCarta;
	}
	public Date getFechaRecepcionCarta() {
		return fechaRecepcionCarta;
	}
	public void setFechaRecepcionCarta(Date fechaRecepcionCarta) {
		this.fechaRecepcionCarta = fechaRecepcionCarta;
	}
	public Date getFechaPresentacionRpCarta() {
		return fechaPresentacionRpCarta;
	}
	public void setFechaPresentacionRpCarta(Date fechaPresentacionRpCarta) {
		this.fechaPresentacionRpCarta = fechaPresentacionRpCarta;
	}
	
	
}