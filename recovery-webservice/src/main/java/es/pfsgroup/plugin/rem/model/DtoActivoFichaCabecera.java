package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * 
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoFichaCabecera extends WebDto {

	private static final long serialVersionUID = 0L;

	// private NMBLocalizacionesBienInfo localizacionActual;
	private String descripcion;

	// private NMBDDOrigenBien origen;
	private String tipoTitulo;
	private String poblacion;
	private Date fechaDueD;
	private String rating;
	private String numActivo;
	private String numActivoRem;
	private String idSareb;
	private String numActivoUvem;
	private String idProp;
	private String propietario;
	private String idRecovery;
	private String direccion;
	private String codPostal;
	private String portal;
	private String escalera;
	private String puerta;
	private String barrio;
	private String piso;
	private String numeroDomicilio;
	private String nombreVia;
	private String municipioCodigo;
	private String inferiorMunicipioCodigo;
	private String inferiorMunicipioDescripcion;
	private String municipioDescripcion;
	private String provinciaCodigo;
	private String provinciaDescripcion;
	private String paisCodigo;
	private String tipoViaCodigo;
	private String tipoViaDescripcion;
	private String tipoActivoCodigo;
	private String subtipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoDescripcion;
	private String latitud;
	private String longitud;
	private String entidadPropietaria;
	private String entidadPropietariaCodigo;
	private String entidadPropietariaDescripcion;

	private String estadoActivoCodigo;
	private Integer divHorizontal;
	private String tipoUsoDestinoCodigo;
	private String tipoUsoDestinoDescripcion;

	// Comunidad de propietarios
	// Mapeo manual
	private String tipoCuotaCodigo;
	private String direccionComunidad;

	// Mapeo automático beanutils
	private Integer constituida;
	private String nombre;
	private String nif;
	private String numCuenta;
	private String numCuentaUno;
	private String numCuentaDos;
	private String numCuentaTres;
	private String numCuentaCuatro;
	private String numCuentaCinco;
	private String nomPresidente;
	private String telfPresidente;
	private String telfPresidente2;
	private String emailPresidente;
	private String dirPresidente;
	private Date fechaInicioPresidente;
	private Date fechaFinPresidente;
	private String nomAdministrador;
	private String telfAdministrador;
	private String telfAdministrador2;
	private String emailAdministrador;
	private String dirAdministrador;
	private String importeMedio;
	private Boolean estatutos;
	private Boolean libroEdificio;
	private Boolean certificadoIte;
	private String observaciones;
	private Boolean selloCalidad;
	private Boolean admision;
	private Boolean gestion;
	private String tipoInfoComercialCodigo;
	private String estadoPublicacionDescripcion;
	private String estadoPublicacionCodigo;
	private String tipoComercializacionDescripcion;
	private Boolean pertenceAgrupacionRestringida;

	private int page;
	private int start;
	private int limit;

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getStart() {
		return start;
	}

	public void setStart(int start) {
		this.start = start;
	}

	public int getLimit() {
		return limit;
	}

	public void setLimit(int limit) {
		this.limit = limit;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/*
	 * public NMBDDOrigenBien getOrigen() { return origen; } public void
	 * setOrigen(NMBDDOrigenBien origen) { this.origen = origen; }
	 */

	public String getPoblacion() {
		return poblacion;
	}

	public String getEntidadPropietaria() {
		return entidadPropietaria;
	}

	public void setEntidadPropietaria(String entidadPropietaria) {
		this.entidadPropietaria = entidadPropietaria;
	}

	public String getTipoTitulo() {
		return tipoTitulo;
	}

	public void setTipoTitulo(String tipoTitulo) {
		this.tipoTitulo = tipoTitulo;
	}

	public void setPoblacion(String poblacion) {
		this.poblacion = poblacion;
	}

	public Date getFechaDueD() {
		return fechaDueD;
	}

	public void setFechaDueD(Date fechaDueD) {
		this.fechaDueD = fechaDueD;
	}/*
	 * public NMBLocalizacionesBienInfo getLocalizacionActual() { return
	 * localizacionActual; } public void
	 * setLocalizacionActual(NMBLocalizacionesBienInfo localizacionActual) {
	 * this.localizacionActual = localizacionActual; }
	 */

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getPortal() {
		return portal;
	}

	public void setPortal(String portal) {
		this.portal = portal;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getBarrio() {
		return barrio;
	}

	public void setBarrio(String barrio) {
		this.barrio = barrio;
	}

	public String getPiso() {
		return piso;
	}

	public void setPiso(String piso) {
		this.piso = piso;
	}

	public String getNumeroDomicilio() {
		return numeroDomicilio;
	}

	public void setNumeroDomicilio(String numeroDomicilio) {
		this.numeroDomicilio = numeroDomicilio;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}

	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}

	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}

	public String getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public String getNumActivoUvem() {
		return numActivoUvem;
	}

	public void setNumActivoUvem(String numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}

	public String getIdSareb() {
		return idSareb;
	}

	public void setIdSareb(String idSareb) {
		this.idSareb = idSareb;
	}

	public String getIdProp() {
		return idProp;
	}

	public void setIdProp(String idProp) {
		this.idProp = idProp;
	}

	public String getPropietario() {
		return propietario;
	}

	public void setPropietario(String propietario) {
		this.propietario = propietario;
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

	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}

	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}

	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}

	public Integer getDivHorizontal() {
		return divHorizontal;
	}

	public void setDivHorizontal(Integer divHorizontal) {
		this.divHorizontal = divHorizontal;
	}

	public String getTipoCuotaCodigo() {
		return tipoCuotaCodigo;
	}

	public void setTipoCuotaCodigo(String tipoCuotaCodigo) {
		this.tipoCuotaCodigo = tipoCuotaCodigo;
	}

	public String getDireccionComunidad() {
		return direccionComunidad;
	}

	public void setDireccionComunidad(String direccionComunidad) {
		this.direccionComunidad = direccionComunidad;
	}

	public Integer getConstituida() {
		return constituida;
	}

	public void setConstituida(Integer constituida) {
		this.constituida = constituida;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getNumCuenta() {
		return numCuenta;
	}

	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}

	public String getNomPresidente() {
		return nomPresidente;
	}

	public void setNomPresidente(String nomPresidente) {
		this.nomPresidente = nomPresidente;
	}

	public String getTelfPresidente() {
		return telfPresidente;
	}

	public void setTelfPresidente(String telfPresidente) {
		this.telfPresidente = telfPresidente;
	}

	public String getEmailPresidente() {
		return emailPresidente;
	}

	public void setEmailPresidente(String emailPresidente) {
		this.emailPresidente = emailPresidente;
	}

	public String getDirPresidente() {
		return dirPresidente;
	}

	public void setDirPresidente(String dirPresidente) {
		this.dirPresidente = dirPresidente;
	}

	public Date getFechaInicioPresidente() {
		return fechaInicioPresidente;
	}

	public void setFechaInicioPresidente(Date fechaInicioPresidente) {
		this.fechaInicioPresidente = fechaInicioPresidente;
	}

	public Date getFechaFinPresidente() {
		return fechaFinPresidente;
	}

	public void setFechaFinPresidente(Date fechaFinPresidente) {
		this.fechaFinPresidente = fechaFinPresidente;
	}

	public String getNomAdministrador() {
		return nomAdministrador;
	}

	public void setNomAdministrador(String nomAdministrador) {
		this.nomAdministrador = nomAdministrador;
	}

	public String getTelfAdministrador() {
		return telfAdministrador;
	}

	public void setTelfAdministrador(String telfAdministrador) {
		this.telfAdministrador = telfAdministrador;
	}

	public String getEmailAdministrador() {
		return emailAdministrador;
	}

	public void setEmailAdministrador(String emailAdministrador) {
		this.emailAdministrador = emailAdministrador;
	}

	public String getImporteMedio() {
		return importeMedio;
	}

	public void setImporteMedio(String importeMedio) {
		this.importeMedio = importeMedio;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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

	public String getPaisCodigo() {
		return paisCodigo;
	}

	public void setPaisCodigo(String paisCodigo) {
		this.paisCodigo = paisCodigo;
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

	public String getInferiorMunicipioCodigo() {
		return inferiorMunicipioCodigo;
	}

	public void setInferiorMunicipioCodigo(String inferiorMunicipioCodigo) {
		this.inferiorMunicipioCodigo = inferiorMunicipioCodigo;
	}

	public String getNumCuentaUno() {
		return numCuentaUno;
	}

	public void setNumCuentaUno(String numCuentaUno) {
		this.numCuentaUno = numCuentaUno;
	}

	public String getNumCuentaDos() {
		return numCuentaDos;
	}

	public void setNumCuentaDos(String numCuentaDos) {
		this.numCuentaDos = numCuentaDos;
	}

	public String getNumCuentaTres() {
		return numCuentaTres;
	}

	public void setNumCuentaTres(String numCuentaTres) {
		this.numCuentaTres = numCuentaTres;
	}

	public String getNumCuentaCuatro() {
		return numCuentaCuatro;
	}

	public void setNumCuentaCuatro(String numCuentaCuatro) {
		this.numCuentaCuatro = numCuentaCuatro;
	}

	public String getNumCuentaCinco() {
		return numCuentaCinco;
	}

	public void setNumCuentaCinco(String numCuentaCinco) {
		this.numCuentaCinco = numCuentaCinco;
	}

	public String getDirAdministrador() {
		return dirAdministrador;
	}

	public void setDirAdministrador(String dirAdministrador) {
		this.dirAdministrador = dirAdministrador;
	}

	public void setEstatutos(Boolean estatutos) {
		this.estatutos = estatutos;
	}

	public void setLibroEdificio(Boolean libroEdificio) {
		this.libroEdificio = libroEdificio;
	}

	public void setCertificadoIte(Boolean certificadoIte) {
		this.certificadoIte = certificadoIte;
	}

	public Boolean isEstatutos() {
		return estatutos;
	}

	public Boolean isLibroEdificio() {
		return libroEdificio;
	}

	public Boolean isCertificadoIte() {
		return certificadoIte;
	}

	public Boolean getEstatutos() {
		return estatutos;
	}

	public Boolean getLibroEdificio() {
		return libroEdificio;
	}

	public Boolean getCertificadoIte() {
		return certificadoIte;
	}

	public String getTelfPresidente2() {
		return telfPresidente2;
	}

	public void setTelfPresidente2(String telfPresidente2) {
		this.telfPresidente2 = telfPresidente2;
	}

	public String getTelfAdministrador2() {
		return telfAdministrador2;
	}

	public void setTelfAdministrador2(String telfAdministrador2) {
		this.telfAdministrador2 = telfAdministrador2;
	}

	public String getIdRecovery() {
		return idRecovery;
	}

	public void setIdRecovery(String idRecovery) {
		this.idRecovery = idRecovery;
	}

	public String getTipoViaDescripcion() {
		return tipoViaDescripcion;
	}

	public void setTipoViaDescripcion(String tipoViaDescripcion) {
		this.tipoViaDescripcion = tipoViaDescripcion;
	}

	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}

	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}

	public String getTipoUsoDestinoCodigo() {
		return tipoUsoDestinoCodigo;
	}

	public void setTipoUsoDestinoCodigo(String tipoUsoDestinoCodigo) {
		this.tipoUsoDestinoCodigo = tipoUsoDestinoCodigo;
	}

	public String getTipoUsoDestinoDescripcion() {
		return tipoUsoDestinoDescripcion;
	}

	public void setTipoUsoDestinoDescripcion(String tipoUsoDestinoDescripcion) {
		this.tipoUsoDestinoDescripcion = tipoUsoDestinoDescripcion;
	}

	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public Boolean getSelloCalidad() {
		return selloCalidad;
	}

	public void setSelloCalidad(Boolean selloCalidad) {
		this.selloCalidad = selloCalidad;
	}

	public Boolean getAdmision() {
		return admision;
	}

	public void setAdmision(Boolean admision) {
		this.admision = admision;
	}

	public Boolean getGestion() {
		return gestion;
	}

	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}

	public String getTipoInfoComercialCodigo() {
		return tipoInfoComercialCodigo;
	}

	public void setTipoInfoComercialCodigo(String tipoInfoComercialCodigo) {
		this.tipoInfoComercialCodigo = tipoInfoComercialCodigo;
	}

	public String getInferiorMunicipioDescripcion() {
		return inferiorMunicipioDescripcion;
	}

	public void setInferiorMunicipioDescripcion(String inferiorMunicipioDescripcion) {
		this.inferiorMunicipioDescripcion = inferiorMunicipioDescripcion;
	}

	public String getEstadoPublicacionDescripcion() {
		return estadoPublicacionDescripcion;
	}

	public void setEstadoPublicacionDescripcion(String estadoPublicacionDescripcion) {
		this.estadoPublicacionDescripcion = estadoPublicacionDescripcion;
	}

	public String getTipoComercializacionDescripcion() {
		return tipoComercializacionDescripcion;
	}

	public void setTipoComercializacionDescripcion(String tipoComercializacionDescripcion) {
		this.tipoComercializacionDescripcion = tipoComercializacionDescripcion;
	}

	public String getEstadoPublicacionCodigo() {
		return estadoPublicacionCodigo;
	}

	public void setEstadoPublicacionCodigo(String estadoPublicacionCodigo) {
		this.estadoPublicacionCodigo = estadoPublicacionCodigo;
	}

	public Boolean getPertenceAgrupacionRestringida() {
		return pertenceAgrupacionRestringida;
	}

	public void setPertenceAgrupacionRestringida(
			Boolean pertenceAgrupacionRestringida) {
		this.pertenceAgrupacionRestringida = pertenceAgrupacionRestringida;
	}
	

}