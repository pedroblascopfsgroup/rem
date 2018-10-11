package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import java.util.List;

/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * 
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoFichaCabecera extends DtoTabActivo {

	private static final long serialVersionUID = 0L;

	private String descripcion;

	private String tipoTitulo;
	private String tipoTituloCodigo;
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
	private String tipoActivoCodigoBde;
	private String subtipoActivoCodigoBde;
	private String tipoActivoDescripcionBde;
	private String subtipoActivoDescripcionBde;
	private String latitud;
	private String longitud;
	private String entidadPropietaria;
	private String entidadPropietariaCodigo;
	private String entidadPropietariaDescripcion;
	private String subcarteraCodigo;
	private String subcarteraDescripcion;
	private String estadoActivoCodigo;
	private Integer divHorizontal;
	private String tipoUsoDestinoCodigo;
	private String tipoUsoDestinoDescripcion;
	private String codPromocionFinal;
	private String catContableDescripcion;
	
	// Comunidad de propietarios
	private String tipoCuotaCodigo;
	private String direccionComunidad;

	// Mapeo manual
	private Boolean informeComercialAceptado;
	private Boolean tipoActivoAdmisionMediadorCorresponde;

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
	private Boolean admision;
	private Boolean gestion;
	private String tipoInfoComercialCodigo;
	private String estadoPublicacionDescripcion;
	private String estadoPublicacionCodigo;
	private String tipoComercializarCodigo;
	private String tipoComercializarDescripcion;
	private Boolean pertenceAgrupacionRestringida;
	private Boolean pertenceAgrupacionComercial;
	private Boolean pertenceAgrupacionAsistida;
	private Boolean pertenceAgrupacionObraNueva;
	private String situacionComercialCodigo;
	private String situacionComercialDescripcion;
	
	//Perimetro datos:
	private Boolean incluidoEnPerimetro;
	private Date fechaAltaActivoRem;
	private Boolean aplicaTramiteAdmision;
	private Date fechaAplicaTramiteAdmision;
	private String motivoAplicaTramiteAdmision;
	private Boolean aplicaGestion;
	private Date fechaAplicaGestion;
	private String motivoAplicaGestion;
	private Boolean aplicaAsignarMediador;
	private Date fechaAplicaAsignarMediador;
	private String motivoAplicaAsignarMediador;
	private Boolean aplicaComercializar;
	private Date fechaAplicaComercializar;
	private String motivoAplicaComercializarCodigo;
	private String motivoAplicaComercializarDescripcion;
	private String motivoNoAplicaComercializar;
	private Boolean aplicaFormalizar;
	private Date fechaAplicaFormalizar;
	private String motivoAplicaFormalizar;
	private String tipoComercializacionCodigo;
	private String tipoComercializacionDescripcion;
	private String tipoAlquilerCodigo;
	private String tipoAlquilerDescripcion;
	private Boolean bloqueoTipoComercializacionAutomatico;
	private String numInmovilizadoBankia;

	//Activo Bancario datos:
	private String claseActivoCodigo;
	private String claseActivoDescripcion;
	private String subtipoClaseActivoCodigo;
	private String subtipoClaseActivoDescripcion;
	private String numExpRiesgo;
	private String acreedorNumExp;
	private String tipoProductoCodigo;
	private String tipoProductoDescripcion;
	private String estadoExpRiesgoCodigo;
	private String estadoExpRiesgoDescripcion;
	private String estadoExpIncorrienteCodigo;
	private String estadoExpIncorrienteDescripcion;
	private String productoDescripcion;
	private String entradaActivoBankiaCodigo;
	
	//Activo integrado en agrupación asistida
	private Boolean integradoEnAgrupacionAsistida;
	
	//Tipo Activo del mediador
	private String tipoActivoMediadorCodigo;
	
	//HREOS-1983
	private Boolean selloCalidad;
	private String nombreGestorSelloCalidad;
	private Date fechaRevisionSelloCalidad;
	
	//HREOS-2684
	private String minimoAutorizado;
	private String aprobadoVentaWeb;
	private String aprobadoRentaWeb;
	private String descuentoAprobado;
	private String descuentoPublicado;
	private String valorNetoContable;
	private String costeAdquisicion;
	private String valorUltimaTasacion;
	
	//HREOS-2716
	private String codigoPromocionPrinex;

	// HREOS-2761
	private List<?> activosPropagables;
	
	//REMVIP-969
	private Boolean tienePosibleInformeMediador;
	
	private int page;
	private int start;
	private int limit;
	
	//HREOS-3415
	private String acbCoreaeTexto;
	
	//REMVIP-REMVIP-2193
	private Boolean isLogUsuGestComerSupComerSupAdmin;

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

	public String getTipoTituloCodigo() {
		return tipoTituloCodigo;
	}

	public void setTipoTituloCodigo(String tipoTituloCodigo) {
		this.tipoTituloCodigo = tipoTituloCodigo;
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

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public String getSubcarteraDescripcion() {
		return subcarteraDescripcion;
	}

	public void setSubcarteraDescripcion(String subcarteraDescripcion) {
		this.subcarteraDescripcion = subcarteraDescripcion;
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

	public String getTipoComercializarCodigo() {
		return tipoComercializarCodigo;
	}

	public void setTipoComercializarCodigo(String tipoComercializarCodigo) {
		this.tipoComercializarCodigo = tipoComercializarCodigo;
	}

	public String getTipoComercializarDescripcion() {
		return tipoComercializarDescripcion;
	}

	public void setTipoComercializarDescripcion(String tipoComercializarDescripcion) {
		this.tipoComercializarDescripcion = tipoComercializarDescripcion;
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

	public Boolean getIncluidoEnPerimetro() {
		return incluidoEnPerimetro;
	}

	public void setIncluidoEnPerimetro(Boolean incluidoEnPerimetro) {
		this.incluidoEnPerimetro = incluidoEnPerimetro;
	}

	public Date getFechaAltaActivoRem() {
		return fechaAltaActivoRem;
	}

	public void setFechaAltaActivoRem(Date fechaAltaActivoRem) {
		this.fechaAltaActivoRem = fechaAltaActivoRem;
	}

	public Boolean getAplicaTramiteAdmision() {
		return aplicaTramiteAdmision;
	}

	public void setAplicaTramiteAdmision(Boolean aplicaTramiteAdmision) {
		this.aplicaTramiteAdmision = aplicaTramiteAdmision;
	}

	public Date getFechaAplicaTramiteAdmision() {
		return fechaAplicaTramiteAdmision;
	}

	public void setFechaAplicaTramiteAdmision(Date fechaAplicaTramiteAdmision) {
		this.fechaAplicaTramiteAdmision = fechaAplicaTramiteAdmision;
	}

	public String getMotivoAplicaTramiteAdmision() {
		return motivoAplicaTramiteAdmision;
	}

	public void setMotivoAplicaTramiteAdmision(String motivoAplicaTramiteAdmision) {
		this.motivoAplicaTramiteAdmision = motivoAplicaTramiteAdmision;
	}

	public Boolean getAplicaGestion() {
		return aplicaGestion;
	}

	public void setAplicaGestion(Boolean aplicaGestion) {
		this.aplicaGestion = aplicaGestion;
	}

	public Date getFechaAplicaGestion() {
		return fechaAplicaGestion;
	}

	public void setFechaAplicaGestion(Date fechaAplicaGestion) {
		this.fechaAplicaGestion = fechaAplicaGestion;
	}

	public String getMotivoAplicaGestion() {
		return motivoAplicaGestion;
	}

	public void setMotivoAplicaGestion(String motivoAplicaGestion) {
		this.motivoAplicaGestion = motivoAplicaGestion;
	}

	public Boolean getAplicaAsignarMediador() {
		return aplicaAsignarMediador;
	}

	public void setAplicaAsignarMediador(Boolean aplicaAsignarMediador) {
		this.aplicaAsignarMediador = aplicaAsignarMediador;
	}

	public Date getFechaAplicaAsignarMediador() {
		return fechaAplicaAsignarMediador;
	}

	public void setFechaAplicaAsignarMediador(Date fechaAplicaAsignarMediador) {
		this.fechaAplicaAsignarMediador = fechaAplicaAsignarMediador;
	}

	public String getMotivoAplicaAsignarMediador() {
		return motivoAplicaAsignarMediador;
	}

	public void setMotivoAplicaAsignarMediador(String motivoAplicaAsignarMediador) {
		this.motivoAplicaAsignarMediador = motivoAplicaAsignarMediador;
	}

	public Boolean getAplicaComercializar() {
		return aplicaComercializar;
	}

	public void setAplicaComercializar(Boolean aplicaComercializar) {
		this.aplicaComercializar = aplicaComercializar;
	}

	public Date getFechaAplicaComercializar() {
		return fechaAplicaComercializar;
	}

	public void setFechaAplicaComercializar(Date fechaAplicaComercializar) {
		this.fechaAplicaComercializar = fechaAplicaComercializar;
	}

	public String getMotivoAplicaComercializarCodigo() {
		return motivoAplicaComercializarCodigo;
	}

	public void setMotivoAplicaComercializarCodigo(String motivoAplicaComercializarCodigo) {
		this.motivoAplicaComercializarCodigo = motivoAplicaComercializarCodigo;
	}

	public String getMotivoAplicaComercializarDescripcion() {
		return motivoAplicaComercializarDescripcion;
	}

	public void setMotivoAplicaComercializarDescripcion(String motivoAplicaComercializarDescripcion) {
		this.motivoAplicaComercializarDescripcion = motivoAplicaComercializarDescripcion;
	}
	
	public String getMotivoNoAplicaComercializar() {
		return motivoNoAplicaComercializar;
	}

	public void setMotivoNoAplicaComercializar(String motivoNoAplicaComercializar) {
		this.motivoNoAplicaComercializar = motivoNoAplicaComercializar;
	}

	public Boolean getAplicaFormalizar() {
		return aplicaFormalizar;
	}

	public void setAplicaFormalizar(Boolean aplicaFormalizar) {
		this.aplicaFormalizar = aplicaFormalizar;
	}

	public Date getFechaAplicaFormalizar() {
		return fechaAplicaFormalizar;
	}

	public void setFechaAplicaFormalizar(Date fechaAplicaFormalizar) {
		this.fechaAplicaFormalizar = fechaAplicaFormalizar;
	}

	public String getMotivoAplicaFormalizar() {
		return motivoAplicaFormalizar;
	}

	public void setMotivoAplicaFormalizar(String motivoAplicaFormalizar) {
		this.motivoAplicaFormalizar = motivoAplicaFormalizar;
	}

	public String getSituacionComercialDescripcion() {
		return situacionComercialDescripcion;
	}

	public void setSituacionComercialDescripcion(String situacionComercialDescripcion) {
		this.situacionComercialDescripcion = situacionComercialDescripcion;
	}

	public String getSituacionComercialCodigo() {
		return situacionComercialCodigo;
	}

	public void setSituacionComercialCodigo(String situacionComercialCodigo) {
		this.situacionComercialCodigo = situacionComercialCodigo;
	}

	public String getClaseActivoCodigo() {
		return claseActivoCodigo;
	}

	public void setClaseActivoCodigo(String claseActivoCodigo) {
		this.claseActivoCodigo = claseActivoCodigo;
	}

	public String getClaseActivoDescripcion() {
		return claseActivoDescripcion;
	}

	public void setClaseActivoDescripcion(String claseActivoDescripcion) {
		this.claseActivoDescripcion = claseActivoDescripcion;
	}

	public String getSubtipoClaseActivoCodigo() {
		return subtipoClaseActivoCodigo;
	}

	public void setSubtipoClaseActivoCodigo(String subtipoClaseActivoCodigo) {
		this.subtipoClaseActivoCodigo = subtipoClaseActivoCodigo;
	}

	public String getSubtipoClaseActivoDescripcion() {
		return subtipoClaseActivoDescripcion;
	}

	public void setSubtipoClaseActivoDescripcion(String subtipoClaseActivoDescripcion) {
		this.subtipoClaseActivoDescripcion = subtipoClaseActivoDescripcion;
	}

	public String getNumExpRiesgo() {
		return numExpRiesgo;
	}

	public void setNumExpRiesgo(String numExpRiesgo) {
		this.numExpRiesgo = numExpRiesgo;
	}

	public String getTipoProductoCodigo() {
		return tipoProductoCodigo;
	}

	public void setTipoProductoCodigo(String tipoProductoCodigo) {
		this.tipoProductoCodigo = tipoProductoCodigo;
	}

	public String getTipoProductoDescripcion() {
		return tipoProductoDescripcion;
	}

	public void setTipoProductoDescripcion(String tipoProductoDescripcion) {
		this.tipoProductoDescripcion = tipoProductoDescripcion;
	}

	public String getEstadoExpRiesgoCodigo() {
		return estadoExpRiesgoCodigo;
	}

	public void setEstadoExpRiesgoCodigo(String estadoExpRiesgoCodigo) {
		this.estadoExpRiesgoCodigo = estadoExpRiesgoCodigo;
	}

	public String getEstadoExpRiesgoDescripcion() {
		return estadoExpRiesgoDescripcion;
	}

	public void setEstadoExpRiesgoDescripcion(String estadoExpRiesgoDescripcion) {
		this.estadoExpRiesgoDescripcion = estadoExpRiesgoDescripcion;
	}

	public String getEstadoExpIncorrienteCodigo() {
		return estadoExpIncorrienteCodigo;
	}

	public void setEstadoExpIncorrienteCodigo(String estadoExpIncorrienteCodigo) {
		this.estadoExpIncorrienteCodigo = estadoExpIncorrienteCodigo;
	}

	public String getEstadoExpIncorrienteDescripcion() {
		return estadoExpIncorrienteDescripcion;
	}

	public void setEstadoExpIncorrienteDescripcion(String estadoExpIncorrienteDescripcion) {
		this.estadoExpIncorrienteDescripcion = estadoExpIncorrienteDescripcion;
	}

	public Boolean getIntegradoEnAgrupacionAsistida() {
		return integradoEnAgrupacionAsistida;
	}

	public void setIntegradoEnAgrupacionAsistida(
			Boolean integradoEnAgrupacionAsistida) {
		this.integradoEnAgrupacionAsistida = integradoEnAgrupacionAsistida;
	}

	public Boolean getInformeComercialAceptado() {
		return informeComercialAceptado;
	}

	public void setInformeComercialAceptado(Boolean informeComercialAceptado) {
		this.informeComercialAceptado = informeComercialAceptado;
	}

	public Boolean getTipoActivoAdmisionMediadorCorresponde() {
		return tipoActivoAdmisionMediadorCorresponde;
	}

	public void setTipoActivoAdmisionMediadorCorresponde(Boolean tipoActivoAdmisionMediadorCorresponde) {
		this.tipoActivoAdmisionMediadorCorresponde = tipoActivoAdmisionMediadorCorresponde;
	}

	public String getProductoDescripcion() {
		return productoDescripcion;
	}

	public void setProductoDescripcion(String productoDescripcion) {
		this.productoDescripcion = productoDescripcion;
	}

	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}

	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}

	public String getTipoComercializacionDescripcion() {
		return tipoComercializacionDescripcion;
	}

	public void setTipoComercializacionDescripcion(
			String tipoComercializacionDescripcion) {
		this.tipoComercializacionDescripcion = tipoComercializacionDescripcion;
	}

	public String getTipoAlquilerCodigo() {
		return tipoAlquilerCodigo;
	}

	public void setTipoAlquilerCodigo(String tipoAlquilerCodigo) {
		this.tipoAlquilerCodigo = tipoAlquilerCodigo;
	}

	public String getTipoAlquilerDescripcion() {
		return tipoAlquilerDescripcion;
	}

	public void setTipoAlquilerDescripcion(String tipoAlquilerDescripcion) {
		this.tipoAlquilerDescripcion = tipoAlquilerDescripcion;
	}

	public String getTipoActivoMediadorCodigo() {
		return tipoActivoMediadorCodigo;
	}

	public void setTipoActivoMediadorCodigo(String tipoActivoMediadorCodigo) {
		this.tipoActivoMediadorCodigo = tipoActivoMediadorCodigo;
	}

	public Boolean getBloqueoTipoComercializacionAutomatico() {
		return bloqueoTipoComercializacionAutomatico;
	}

	public void setBloqueoTipoComercializacionAutomatico(
			Boolean bloqueoTipoComercializacionAutomatico) {
		this.bloqueoTipoComercializacionAutomatico = bloqueoTipoComercializacionAutomatico;
	}

	public String getNombreGestorSelloCalidad() {
		return nombreGestorSelloCalidad;
	}

	public void setNombreGestorSelloCalidad(String nombreGestorSelloCalidad) {
		this.nombreGestorSelloCalidad = nombreGestorSelloCalidad;
	}

	public Date getFechaRevisionSelloCalidad() {
		return fechaRevisionSelloCalidad;
	}

	public void setFechaRevisionSelloCalidad(Date fechaRevisionSelloCalidad) {
		this.fechaRevisionSelloCalidad = fechaRevisionSelloCalidad;
	}
	
	public Boolean getPertenceAgrupacionComercial() {
		return pertenceAgrupacionComercial;
	}

	public void setPertenceAgrupacionComercial(Boolean pertenceAgrupacionComercial) {
		this.pertenceAgrupacionComercial = pertenceAgrupacionComercial;
	}

	public String getMinimoAutorizado() {
		return minimoAutorizado;
	}

	public void setMinimoAutorizado(String minimoAutorizado) {
		this.minimoAutorizado = minimoAutorizado;
	}

	public String getAprobadoVentaWeb() {
		return aprobadoVentaWeb;
	}

	public void setAprobadoVentaWeb(String aprobadoVentaWeb) {
		this.aprobadoVentaWeb = aprobadoVentaWeb;
	}

	public String getAprobadoRentaWeb() {
		return aprobadoRentaWeb;
	}

	public void setAprobadoRentaWeb(String aprobadoRentaWeb) {
		this.aprobadoRentaWeb = aprobadoRentaWeb;
	}

	public String getDescuentoAprobado() {
		return descuentoAprobado;
	}

	public void setDescuentoAprobado(String descuentoAprobado) {
		this.descuentoAprobado = descuentoAprobado;
	}

	public String getDescuentoPublicado() {
		return descuentoPublicado;
	}

	public void setDescuentoPublicado(String descuentoPublicado) {
		this.descuentoPublicado = descuentoPublicado;
	}

	public String getValorNetoContable() {
		return valorNetoContable;
	}

	public void setValorNetoContable(String valorNetoContable) {
		this.valorNetoContable = valorNetoContable;
	}

	public String getCosteAdquisicion() {
		return costeAdquisicion;
	}

	public void setCosteAdquisicion(String costeAdquisicion) {
		this.costeAdquisicion = costeAdquisicion;
	}

	public String getValorUltimaTasacion() {
		return valorUltimaTasacion;
	}

	public void setValorUltimaTasacion(String valorUltimaTasacion) {
		this.valorUltimaTasacion = valorUltimaTasacion;
	}

	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}

	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}

	public List<?> getActivosPropagables() {
		return activosPropagables;
	}

	public void setActivosPropagables(List<?> activosPropagables) {
		this.activosPropagables = activosPropagables;

	}

	public Boolean getPertenceAgrupacionAsistida() {
		return pertenceAgrupacionAsistida;
	}

	public void setPertenceAgrupacionAsistida(Boolean pertenceAgrupacionAsistida) {
		this.pertenceAgrupacionAsistida = pertenceAgrupacionAsistida;
	}

	public Boolean getPertenceAgrupacionObraNueva() {
		return pertenceAgrupacionObraNueva;
	}

	public void setPertenceAgrupacionObraNueva(Boolean pertenceAgrupacionObraNueva) {
		this.pertenceAgrupacionObraNueva = pertenceAgrupacionObraNueva;
	}

	public String getEntradaActivoBankiaCodigo() {
		return entradaActivoBankiaCodigo;
	}

	public void setEntradaActivoBankiaCodigo(String entradaActivoBankiaCodigo) {
		this.entradaActivoBankiaCodigo = entradaActivoBankiaCodigo;
	}

	public String getNumInmovilizadoBankia() {
		return numInmovilizadoBankia;
	}

	public void setNumInmovilizadoBankia(String numInmovilizadoBankia) {
		this.numInmovilizadoBankia = numInmovilizadoBankia;
	}

	public String getAcbCoreaeTexto() {
		return acbCoreaeTexto;
	}

	public void setAcbCoreaeTexto(String acbCoreaeTexto) {
		this.acbCoreaeTexto = acbCoreaeTexto;
	}

	public String getAcreedorNumExp() {
		return acreedorNumExp;
	}

	public void setAcreedorNumExp(String acreedorNumExp) {
		this.acreedorNumExp = acreedorNumExp;
	}

	public Boolean getTienePosibleInformeMediador() {
		return tienePosibleInformeMediador;
	}

	public void setTienePosibleInformeMediador(Boolean tienePosibleInformeMediador) {
		this.tienePosibleInformeMediador = tienePosibleInformeMediador;
	}

	public String getTipoActivoCodigoBde() {
		return tipoActivoCodigoBde;
	}

	public void setTipoActivoCodigoBde(String tipoActivoCodigoBde) {
		this.tipoActivoCodigoBde = tipoActivoCodigoBde;
	}

	public String getSubtipoActivoCodigoBde() {
		return subtipoActivoCodigoBde;
	}

	public void setSubtipoActivoCodigoBde(String subtipoActivoCodigoBde) {
		this.subtipoActivoCodigoBde = subtipoActivoCodigoBde;
	}

	public String getTipoActivoDescripcionBde() {
		return tipoActivoDescripcionBde;
	}

	public void setTipoActivoDescripcionBde(String tipoActivoDescripcionBde) {
		this.tipoActivoDescripcionBde = tipoActivoDescripcionBde;
	}

	public String getSubtipoActivoDescripcionBde() {
		return subtipoActivoDescripcionBde;
	}

	public void setSubtipoActivoDescripcionBde(String subtipoActivoDescripcionBde) {
		this.subtipoActivoDescripcionBde = subtipoActivoDescripcionBde;
	}

	public String getCodPromocionFinal() {
		return codPromocionFinal;
	}

	public void setCodPromocionFinal(String codPromocionFinal) {
		this.codPromocionFinal = codPromocionFinal;
	}

	public String getCatContableDescripcion() {
		return catContableDescripcion;
	}

	public void setCatContableDescripcion(String catContableDescripcion) {
		this.catContableDescripcion = catContableDescripcion;
	}

	public Boolean getIsLogUsuGestComerSupComerSupAdmin() {
		return isLogUsuGestComerSupComerSupAdmin;
	}

	public void setIsLogUsuGestComerSupComerSupAdmin(Boolean isLogUsuGestComerSupComerSupAdmin) {
		this.isLogUsuGestComerSupComerSupAdmin = isLogUsuGestComerSupComerSupAdmin;
	}
	
}