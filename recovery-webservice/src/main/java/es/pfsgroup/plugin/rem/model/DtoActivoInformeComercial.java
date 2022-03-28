package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para la pestaña de informe comercial de la ficha de Activo.
 * Este Dto se basa en información comercial y añade info extra para la pantalla.
 * 
 * @author Bender
 */
public class DtoActivoInformeComercial {
	private static final long serialVersionUID = 0L;

	/*private int autorizacionWeb;
	private Date fechaAutorizacionHasta;
	private Date fechaRecepcionLlaves;
	private String tipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoCodigo;
	private String subtipoActivoDescripcion;
	private String tipoViaCodigo;
	private String tipoViaDescripcion;
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
	private String municipioDescripcion;
	private String provinciaCodigo;
	private String provinciaDescripcion;
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
	private String inferiorMunicipioDescripcion;
	private String ubicacionActivoCodigo;
	private String ubicacionActivoDescripcion;
	private Integer numTerrazaCubierta;
	private String descTerrazaCubierta;
	private Integer numTerrazaDescubierta;
	private String descTerrazaDescubierta;
	private Boolean despensa;
	private Boolean lavadero;
	private Boolean azotea;
	private String descOtras;
	private Date fechaComunicacionComunidad;
	private Integer envioCartas;
	private Integer numCartas;
	private Integer contactoTel;
	private Integer visita;
	private Integer burofax;
	private Boolean tieneProveedorTecnico;
	private String codigoProveedor;
	private String nombreProveedor;
	private Integer posibleInforme;
	private String motivoNoPosibleInforme;
	private Boolean posibleInformeBoolean;
	private Integer autorizacionWebEspejo;
	private Date fechaRecepcionLlavesEspejo;
	private String admiteMascotaCodigo;
	
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
	public String getUbicacionActivoDescripcion() {
		return ubicacionActivoDescripcion;
	}
	public void setUbicacionActivoDescripcion(String ubicacionActivoDescripcion) {
		this.ubicacionActivoDescripcion = ubicacionActivoDescripcion;
	}
	public String getInferiorMunicipioCodigo() {
		return inferiorMunicipioCodigo;
	}
	public void setInferiorMunicipioCodigo(String inferiorMunicipioCodigo) {
		this.inferiorMunicipioCodigo = inferiorMunicipioCodigo;
	}
	public String getInferiorMunicipioDescripcion() {
		return inferiorMunicipioDescripcion;
	}
	public void setInferiorMunicipioDescripcion(String inferiorMunicipioDescripcion) {
		this.inferiorMunicipioDescripcion = inferiorMunicipioDescripcion;
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
	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}
	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}
	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}
	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}
	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}
	public String getTipoViaDescripcion() {
		return tipoViaDescripcion;
	}
	public void setTipoViaDescripcion(String tipoViaDescripcion) {
		this.tipoViaDescripcion = tipoViaDescripcion;
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
	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}
	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}
	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
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
	public Integer getNumTerrazaCubierta() {
		return numTerrazaCubierta;
	}
	public void setNumTerrazaCubierta(Integer numTerrazaCubierta) {
		this.numTerrazaCubierta = numTerrazaCubierta;
	}
	public String getDescTerrazaCubierta() {
		return descTerrazaCubierta;
	}
	public void setDescTerrazaCubierta(String descTerrazaCubierta) {
		this.descTerrazaCubierta = descTerrazaCubierta;
	}
	public Integer getNumTerrazaDescubierta() {
		return numTerrazaDescubierta;
	}
	public void setNumTerrazaDescubierta(Integer numTerrazaDescubierta) {
		this.numTerrazaDescubierta = numTerrazaDescubierta;
	}
	public String getDescTerrazaDescubierta() {
		return descTerrazaDescubierta;
	}
	public void setDescTerrazaDescubierta(String descTerrazaDescubierta) {
		this.descTerrazaDescubierta = descTerrazaDescubierta;
	}
	public Boolean getDespensa() {
		return despensa;
	}
	public void setDespensa(Boolean despensa) {
		this.despensa = despensa;
	}
	public Boolean getLavadero() {
		return lavadero;
	}
	public void setLavadero(Boolean lavadero) {
		this.lavadero = lavadero;
	}
	public Boolean getAzotea() {
		return azotea;
	}
	public void setAzotea(Boolean azotea) {
		this.azotea = azotea;
	}
	public String getDescOtras() {
		return descOtras;
	}
	public void setDescOtras(String descOtras) {
		this.descOtras = descOtras;
	}

	public Date getFechaComunicacionComunidad() {
		return fechaComunicacionComunidad;
	}
	public void setFechaComunicacionComunidad(Date fechaComunicacionComunidad) {
		this.fechaComunicacionComunidad = fechaComunicacionComunidad;
	}
	public Integer getEnvioCartas() {
		return envioCartas;
	}
	public void setEnvioCartas(Integer envioCartas) {
		this.envioCartas = envioCartas;
	}
	public Integer getNumCartas() {
		return numCartas;
	}
	public void setNumCartas(Integer numCartas) {
		this.numCartas = numCartas;
	}
	public Integer getContactoTel() {
		return contactoTel;
	}
	public void setContactoTel(Integer contactoTel) {
		this.contactoTel = contactoTel;
	}
	public Integer getVisita() {
		return visita;
	}
	public void setVisita(Integer visita) {
		this.visita = visita;
	}
	public Integer getBurofax() {
		return burofax;
	}
	public void setBurofax(Integer burofax) {
		this.burofax = burofax;
	}
	
	public Boolean getTieneProveedorTecnico() {
		return tieneProveedorTecnico;
	}
	public void setTieneProveedorTecnico(Boolean tieneProveedorTecnico) {
		this.tieneProveedorTecnico = tieneProveedorTecnico;
	}
	public String getCodigoProveedor() {
		return codigoProveedor;
	}
	public void setCodigoProveedor(String codigoProveedor) {
		this.codigoProveedor = codigoProveedor;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public Integer getPosibleInforme() {
		return posibleInforme;
	}
	public void setPosibleInforme(Integer posibleInforme) {
		this.posibleInforme = posibleInforme;
	}
	public String getMotivoNoPosibleInforme() {
		return motivoNoPosibleInforme;
	}
	public void setMotivoNoPosibleInforme(String motivoNoPosibleInforme) {
		this.motivoNoPosibleInforme = motivoNoPosibleInforme;
	}
	public Boolean getPosibleInformeBoolean() {
		return posibleInformeBoolean;
	}
	public void setPosibleInformeBoolean(Boolean posibleInformeBoolean) {
		this.posibleInformeBoolean = posibleInformeBoolean;
	}
	public Integer getAutorizacionWebEspejo() {
		return autorizacionWebEspejo;
	}
	public void setAutorizacionWebEspejo(Integer autorizacionWebEspejo) {
		this.autorizacionWebEspejo = autorizacionWebEspejo;
	}
	public Date getFechaRecepcionLlavesEspejo() {
		return fechaRecepcionLlavesEspejo;
	}
	public void setFechaRecepcionLlavesEspejo(Date fechaRecepcionLlavesEspejo) {
		this.fechaRecepcionLlavesEspejo = fechaRecepcionLlavesEspejo;
	}
	public String getAdmiteMascotaCodigo() {
		return admiteMascotaCodigo;
	}
	public void setAdmiteMascotaCodigo(String admiteMascotaCodigo) {
		this.admiteMascotaCodigo = admiteMascotaCodigo;
	}*/
	
}