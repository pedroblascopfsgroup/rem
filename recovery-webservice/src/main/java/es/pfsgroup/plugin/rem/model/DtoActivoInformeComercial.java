package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para la pestaña de informe comercial de la ficha de Activo.
 * Este Dto se basa en información comercial y añade info extra para la pantalla.
 * 
 * @author Bender
 */
public class DtoActivoInformeComercial extends DtoActivoInformacionComercial{
	private static final long serialVersionUID = 0L;

	private int autorizacionWeb;
	private Date fechaAutorizacionHasta;
	private Date fechaRecepcionLlaves;
	private String tipoActivoCodigo;
	private String subtipoActivoCodigo;
	private String tipoViaCodigo;
	private String nombreVia;
	private String numeroVia;
	private String escalera;
	private String planta;
	private String puerta;
	private String latitud;
	private String longitud;
	private String zona;
	private String distrito;
	private String municipioCodigo;
	private String provinciaCodigo;
	private String codigoPostal;
	private int inscritaComunidad;
	private Float cuotaOrientativaComunidad;
	private Double derramaOrientativaComunidad;
	private String nomPresidenteComunidad;
	private String telPresidenteComunidad;
	private String nomAdministradorComunidad;
	private String telAdministradorComunidad;
	private Double valorEstimadoVenta;
	private Double valorEstimadoRenta;
	private String justificacionVenta;
	private String justificacionRenta;
	private Date fechaEstimacionVenta;
	private Date fechaEstimacionRenta;
	private String inferiorMunicipioCodigo;
	private String ubicacionActivoCodigo;
	
	
	public String getInferiorMunicipioCodigo() {
		return inferiorMunicipioCodigo;
	}
	public Date getFechaEstimacionVenta() {
		return fechaEstimacionVenta;
	}
	public void setFechaEstimacionVenta(Date fechaEstimacionVenta) {
		this.fechaEstimacionVenta = fechaEstimacionVenta;
	}
	public Date getFechaEstimacionRenta() {
		return fechaEstimacionRenta;
	}
	public void setFechaEstimacionRenta(Date fechaEstimacionRenta) {
		this.fechaEstimacionRenta = fechaEstimacionRenta;
	}
	public String getUbicacionActivoCodigo() {
		return ubicacionActivoCodigo;
	}
	public void setUbicacionActivoCodigo(String ubicacionActivoCodigo) {
		this.ubicacionActivoCodigo = ubicacionActivoCodigo;
	}
	public void setInferiorMunicipioCodigo(String inferiorMunicipioCodigo) {
		this.inferiorMunicipioCodigo = inferiorMunicipioCodigo;
	}
	public int getAutorizacionWeb() {
		return autorizacionWeb;
	}
	public void setAutorizacionWeb(int autorizacionWeb) {
		this.autorizacionWeb = autorizacionWeb;
	}
	public Date getFechaAutorizacionHasta() {
		return fechaAutorizacionHasta;
	}
	public void setFechaAutorizacionHasta(Date fechaAutorizacionHasta) {
		this.fechaAutorizacionHasta = fechaAutorizacionHasta;
	}
	public Date getFechaRecepcionLlaves() {
		return fechaRecepcionLlaves;
	}
	public void setFechaRecepcionLlaves(Date fechaRecepcionLlaves) {
		this.fechaRecepcionLlaves = fechaRecepcionLlaves;
	}
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}
	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}
	public String getNombreVia() {
		return nombreVia;
	}
	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}
	public String getNumeroVia() {
		return numeroVia;
	}
	public void setNumeroVia(String numeroVia) {
		this.numeroVia = numeroVia;
	}
	public String getEscalera() {
		return escalera;
	}
	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}
	public String getPlanta() {
		return planta;
	}
	public void setPlanta(String planta) {
		this.planta = planta;
	}
	public String getPuerta() {
		return puerta;
	}
	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}
	public String getLatitud() {
		return latitud;
	}
	public void setLatitud(String latitud) {
		this.latitud = latitud;
	}
	public String getLongitud() {
		return longitud;
	}
	public void setLongitud(String longitud) {
		this.longitud = longitud;
	}
	public String getZona() {
		return zona;
	}
	public void setZona(String zona) {
		this.zona = zona;
	}
	public String getDistrito() {
		return distrito;
	}
	public void setDistrito(String distrito) {
		this.distrito = distrito;
	}
	public String getMunicipioCodigo() {
		return municipioCodigo;
	}
	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public int getInscritaComunidad() {
		return inscritaComunidad;
	}
	public void setInscritaComunidad(int inscritaComunidad) {
		this.inscritaComunidad = inscritaComunidad;
	}
	public Float getCuotaOrientativaComunidad() {
		return cuotaOrientativaComunidad;
	}
	public void setCuotaOrientativaComunidad(Float cuotaOrientativaComunidad) {
		this.cuotaOrientativaComunidad = cuotaOrientativaComunidad;
	}
	public Double getDerramaOrientativaComunidad() {
		return derramaOrientativaComunidad;
	}
	public void setDerramaOrientativaComunidad(Double derramaOrientativaComunidad) {
		this.derramaOrientativaComunidad = derramaOrientativaComunidad;
	}
	public String getNomPresidenteComunidad() {
		return nomPresidenteComunidad;
	}
	public void setNomPresidenteComunidad(String nomPresidenteComunidad) {
		this.nomPresidenteComunidad = nomPresidenteComunidad;
	}
	public String getTelPresidenteComunidad() {
		return telPresidenteComunidad;
	}
	public void setTelPresidenteComunidad(String telPresidenteComunidad) {
		this.telPresidenteComunidad = telPresidenteComunidad;
	}
	public String getNomAdministradorComunidad() {
		return nomAdministradorComunidad;
	}
	public void setNomAdministradorComunidad(String nomAdministradorComunidad) {
		this.nomAdministradorComunidad = nomAdministradorComunidad;
	}
	public String getTelAdministradorComunidad() {
		return telAdministradorComunidad;
	}
	public void setTelAdministradorComunidad(String telAdministradorComunidad) {
		this.telAdministradorComunidad = telAdministradorComunidad;
	}
	public Double getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}
	public void setValorEstimadoVenta(Double valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}
	public Double getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}
	public void setValorEstimadoRenta(Double valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}
	public String getJustificacionVenta() {
		return justificacionVenta;
	}
	public void setJustificacionVenta(String justificacionVenta) {
		this.justificacionVenta = justificacionVenta;
	}
	public String getJustificacionRenta() {
		return justificacionRenta;
	}
	public void setJustificacionRenta(String justificacionRenta) {
		this.justificacionRenta = justificacionRenta;
	}
	
	
}