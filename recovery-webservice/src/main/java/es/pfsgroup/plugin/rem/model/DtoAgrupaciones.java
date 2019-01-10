package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la pestaña cabecera de la ficha de Agrupación.
 */
public class DtoAgrupaciones extends WebDto {

	private static final long serialVersionUID = 8456858084936661002L;
	
	private String nombre;
	private String descripcion;
	private Date fechaAlta;
	private Date fechaBaja;
	private Long numAgrupRem;
	private Long numAgrupUvem;
	private String numeroPublicados;
	private String numeroActivos;
	private String tipoAgrupacionDescripcion;
	private String municipioDescripcion;
	private String provinciaDescripcion;
	private String direccion;
	private String provinciaCodigo;
	private String municipioCodigo;
	private String propietario;
	private String acreedorPDV;
	private String codigoPostal;
	private String tipoAgrupacionCodigo;
	private String estadoObraNuevaCodigo;
	private String codigoCartera;
	@SuppressWarnings("unused")
	private Boolean existeFechaBaja;
	private Date fechaInicioVigencia;
	private Date fechaFinVigencia;
	private boolean esEditable;
	private Boolean existenOfertasVivas;
	private Long codigoGestoriaFormalizacion;
	private Long codigoGestorActivo;
	private Long codigoGestorComercial;
	private Long codigoGestorDobleActivo;
	private Long codigoGestorFormalizacion;
	private Long codigoGestorComercialBackOffice;
	private Integer isFormalizacion;
	private Boolean estaCaducada;
	private Boolean agrupacionEliminada;
	private Integer estadoVenta;
	private Integer estadoAlquiler;
	private String tipoComercializacionCodigo;
	private String tipoComercializacionDescripcion;
	private Boolean incluidoEnPerimetro;
	private String estadoAlquilerDescripcion;
	private String estadoVentaDescripcion;
	private String estadoAlquilerCodigo;
	private String estadoVentaCodigo;
	private String tipoActivoCodigo;
	private String estadoActivoCodigo;
	private String subtipoActivoCodigo;
	private Long idNumActivoPrincipal;
	private String tipoActivoPrincipalCodigo;


	public Boolean getEstaCaducada() {
		return estaCaducada;
	}
	public void setEstaCaducada(Boolean estaCaducada) {
		this.estaCaducada = estaCaducada;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public Long getNumAgrupRem() {
		return numAgrupRem;
	}
	public void setNumAgrupRem(Long numAgrupRem) {
		this.numAgrupRem = numAgrupRem;
	}
	public Long getNumAgrupUvem() {
		return numAgrupUvem;
	}
	public void setNumAgrupUvem(Long numAgrupUvem) {
		this.numAgrupUvem = numAgrupUvem;
	}
	public String getNumeroPublicados() {
		return numeroPublicados;
	}
	public void setNumeroPublicados(String numeroPublicados) {
		this.numeroPublicados = numeroPublicados;
	}
	public String getNumeroActivos() {
		return numeroActivos;
	}
	public void setNumeroActivos(String numeroActivos) {
		this.numeroActivos = numeroActivos;
	}
	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}
	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}
	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}
	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}
	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}
	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getMunicipioCodigo() {
		return municipioCodigo;
	}
	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getTipoAgrupacionCodigo() {
		return tipoAgrupacionCodigo;
	}
	public void setTipoAgrupacionCodigo(String tipoAgrupacionCodigo) {
		this.tipoAgrupacionCodigo = tipoAgrupacionCodigo;
	}
	public String getAcreedorPDV() {
		return acreedorPDV;
	}
	public void setAcreedorPDV(String acreedorPDV) {
		this.acreedorPDV = acreedorPDV;
	}
	public String getEstadoObraNuevaCodigo() {
		return estadoObraNuevaCodigo;
	}
	public void setEstadoObraNuevaCodigo(String estadoObraNuevaCodigo) {
		this.estadoObraNuevaCodigo = estadoObraNuevaCodigo;
	}
	public Boolean getExisteFechaBaja() {
		if (this.fechaBaja != null)
			return true;
		else
			return false;
	}
	public void setExisteFechaBaja(Boolean existeFechaBaja) {
		this.existeFechaBaja = existeFechaBaja;
	}
	public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}
	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}
	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}
	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}
	public boolean getEsEditable() {
		return esEditable;
	}
	public void setEsEditable(boolean esEditable) {
		this.esEditable = esEditable;
	}
	public Boolean getExistenOfertasVivas() {
		return existenOfertasVivas;
	}
	public void setExistenOfertasVivas(Boolean existenOfertasVivas) {
		this.existenOfertasVivas = existenOfertasVivas;
	}
	public Long getCodigoGestoriaFormalizacion() {
		return codigoGestoriaFormalizacion;
	}
	public void setCodigoGestoriaFormalizacion(Long codigoGestoriaFormalizacion) {
		this.codigoGestoriaFormalizacion = codigoGestoriaFormalizacion;
	}
	public Long getCodigoGestorComercial() {
		return codigoGestorComercial;
	}
	public void setCodigoGestorComercial(Long codigoGestorComercial) {
		this.codigoGestorComercial = codigoGestorComercial;
	}
	public Long getCodigoGestorFormalizacion() {
		return codigoGestorFormalizacion;
	}
	public void setCodigoGestorFormalizacion(Long codigoGestorFormalizacion) {
		this.codigoGestorFormalizacion = codigoGestorFormalizacion;
	}
	public Long getCodigoGestorComercialBackOffice() {
		return codigoGestorComercialBackOffice;
	}
	public void setCodigoGestorComercialBackOffice(Long codigoGestorComercialBackOffice) {
		this.codigoGestorComercialBackOffice = codigoGestorComercialBackOffice;
	}
	public Integer getIsFormalizacion() {
		return isFormalizacion;
	}
	public void setIsFormalizacion(Integer isFormalizacion) {
		this.isFormalizacion = isFormalizacion;
	}
	public String getCodigoCartera() {
		return codigoCartera;
	}
	public void setCodigoCartera(String codigoCartera) {
		this.codigoCartera = codigoCartera;
	}
	public Boolean getAgrupacionEliminada() {
		return agrupacionEliminada;
	}
	public void setAgrupacionEliminada(Boolean agrupacionEliminada) {
		this.agrupacionEliminada = agrupacionEliminada;
	}
	public Integer getEstadoVenta() {
		return estadoVenta;
	}
	public void setEstadoVenta(Integer estadoVenta) {
		this.estadoVenta = estadoVenta;
	}
	public Integer getEstadoAlquiler() {
		return estadoAlquiler;
	}
	public void setEstadoAlquiler(Integer estadoAlquiler) {
		this.estadoAlquiler = estadoAlquiler;
	}
	public String getTipoComercializacionDescripcion() {
		return tipoComercializacionDescripcion;
	}
	public void setTipoComercializacionDescripcion(String tipoComercializacionDescripcion) {
		this.tipoComercializacionDescripcion = tipoComercializacionDescripcion;
	}
	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}
	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}
	public Boolean getIncluidoEnPerimetro() {
		return incluidoEnPerimetro;
	}
	public void setIncluidoEnPerimetro(Boolean incluidoEnPerimetro) {
		this.incluidoEnPerimetro = incluidoEnPerimetro;
	}
	public String getEstadoAlquilerDescripcion() {
		return estadoAlquilerDescripcion;
	}
	public void setEstadoAlquilerDescripcion(String estadoAlquilerDescripcion) {
		this.estadoAlquilerDescripcion = estadoAlquilerDescripcion;
	}
	public String getEstadoVentaDescripcion() {
		return estadoVentaDescripcion;
	}
	public void setEstadoVentaDescripcion(String estadoVentaDescripcion) {
		this.estadoVentaDescripcion = estadoVentaDescripcion;
	}
	public String getEstadoAlquilerCodigo() {
		return estadoAlquilerCodigo;
	}
	public void setEstadoAlquilerCodigo(String estadoAlquilerCodigo) {
		this.estadoAlquilerCodigo = estadoAlquilerCodigo;
	}
	public String getEstadoVentaCodigo() {
		return estadoVentaCodigo;
	}
	public void setEstadoVentaCodigo(String estadoVentaCodigo) {
		this.estadoVentaCodigo = estadoVentaCodigo;
	}
	public Long getCodigoGestorActivo() {
		return codigoGestorActivo;
	}
	public void setCodigoGestorActivo(Long codigoGestorActivo) {
		this.codigoGestorActivo = codigoGestorActivo;
	}
	public Long getCodigoGestorDobleActivo() {
		return codigoGestorDobleActivo;
	}
	public void setCodigoGestorDobleActivo(Long codigoGestorDobleActivo) {
		this.codigoGestorDobleActivo = codigoGestorDobleActivo;
	}
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}
	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public Long getIdNumActivoPrincipal() {
		return idNumActivoPrincipal;
	}
	public void setIdNumActivoPrincipal(Long idNumActivoPrincipal) {
		this.idNumActivoPrincipal = idNumActivoPrincipal;
	}
	public String getTipoActivoPrincipalCodigo() {
		return tipoActivoPrincipalCodigo;
	}
	public void setTipoActivoPrincipalCodigo(String tipoActivoPrincipalCodigo) {
		this.tipoActivoPrincipalCodigo = tipoActivoPrincipalCodigo;
	}





}
