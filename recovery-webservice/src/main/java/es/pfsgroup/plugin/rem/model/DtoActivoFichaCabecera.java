package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import java.util.List;

/**
 * Dto para la pestaña cabecera de la ficha de Activo
 */
public class DtoActivoFichaCabecera extends DtoTabActivo {

	private static final long serialVersionUID = 0L;

	private String descripcion;

	private String tipoTitulo;
	private String tipoTituloCodigo;
	private String poblacion;
	private Date fechaDueD;
	private String rating;
	private String estadoComunicacionGencatCodigo;
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
	private String codPostalOE;
	private String escaleraOE;
	private String puertaOE;
	private String barrio;
	private String piso;
	private String pisoOE;
	private String numeroDomicilio;
	private String nombreVia;
	private String municipioCodigo;
	private String numeroDomicilioOE;
	private String nombreViaOE;
	private String municipioCodigoOE;
	private String inferiorMunicipioCodigo;
	private String inferiorMunicipioDescripcion;
	private String municipioDescripcion;
	private String provinciaCodigo;
	private String provinciaDescripcion;
	private String municipioDescripcionOE;
	private String provinciaCodigoOE;
	private String provinciaDescripcionOE;
	private String paisCodigo;
	private String paisDescripcion;
	private String tipoViaCodigo;
	private String tipoViaDescripcion;
	private String tipoViaCodigoOE;
	private String tipoViaDescripcionOE;
	private String tipoActivoCodigo;
	private String subtipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoDescripcion;
	private String tipoActivoCodigoOE;
	private String subtipoActivoCodigoOE;
	private String tipoActivoDescripcionOE;
	private String subtipoActivoDescripcionOE;
	private String tipoActivoCodigoBde;
	private String subtipoActivoCodigoBde;
	private String tipoActivoDescripcionBde;
	private String subtipoActivoDescripcionBde;
	private String latitud;
	private String longitud;
	private String latitudOE;
	private String longitudOE;
	private Boolean reoContabilizadoSap;
	private Date fechaFinPrevistaAdecuacion;
	private String estadoAdecuacionSarebCodigo;
	private String estadoAdecuacionSarebDescripcion;
	private String entidadPropietaria;
	private String entidadPropietariaCodigo;
	private String entidadPropietariaDescripcion;
	private String subcarteraCodigo;
	private String subcarteraDescripcion;
	private String estadoActivoCodigo;
	private String estadoActivoDescripcion;
	private Integer divHorizontal;
	private String tipoUsoDestinoCodigo;
	private String tipoUsoDestinoDescripcion;
	private String codPromocionFinal;
	private String catContableDescripcion;
	private String motivoActivo;
	private Boolean tieneRegistroContrato;
	private Integer diasCambioEstadoActivo;
	private String tipoSegmentoCodigo;
	private String tipoSegmentoDescripcion;
	private String estadoRegistralCodigo;
	private String estadoRegistralDescripcion;
	private String plantaEdificioCodigo;
	private String plantaEdificioDescripcion;
	private String escaleraEdificioCodigo;
	private String escaleraEdificioDescripcion;
	
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
	private Integer estadoVenta;
	private Integer estadoAlquiler;
	private String estadoVentaDescripcion;
	private String estadoAlquilerDescripcion;
	private String estadoAlquilerCodigo;
	private String estadoVentaCodigo;
	private Boolean gestion;
	private String tipoInfoComercialCodigo;
	private String estadoPublicacionDescripcion;
	private String estadoPublicacionCodigo;
	private String tipoComercializarCodigo;
	private String tipoComercializarDescripcion;
	private Boolean pertenceAgrupacionRestringida;
	private Boolean perteneceAgrupacionRestringidaVigente;
	private Boolean pertenceAgrupacionComercial;
	private Boolean pertenceAgrupacionAsistida;
	private Boolean pertenceAgrupacionObraNueva;
	private Boolean pertenceAgrupacionProyecto;
	private String situacionComercialCodigo;
	private String situacionComercialDescripcion;
	private Boolean esSarebProyecto;
	private Boolean isUA;
	
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
	private Boolean aplicaPublicar;
	private Date fechaAplicaPublicar;
	private String motivoAplicaPublicar;
	private Integer enTramite;
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
	private String entradaActivoBankiaDescripcion;
	
	//Activo integrado en agrupación asistida
	private Boolean integradoEnAgrupacionAsistida;
	
	//Tipo Activo del mediador
	private String tipoActivoMediadorCodigo;

	private Boolean selloCalidad;
	private String nombreGestorSelloCalidad;
	private Date fechaRevisionSelloCalidad;

	private String minimoAutorizado;
	private String aprobadoVentaWeb;
	private String aprobadoRentaWeb;
	private String descuentoAprobado;
	private String descuentoPublicado;
	private String descuentoAprobadoAlquiler;
	private String descuentoPublicadoAlquiler;
	private String valorNetoContable;
	private String costeAdquisicion;
	private String valorUltimaTasacion;

	private String codigoPromocionPrinex;

	private List<?> activosPropagables;
	private List<Activo> activosPropagablesUas;

	private Boolean tienePosibleInformeMediador;

	private String idAgrupacion;
	private Boolean tienePromocion;
	
	private Boolean tieneCEE;

	private int page;
	private int start;
	private int limit;

	private String acbCoreaeTexto;

	private Boolean asignaGestPorCambioDeProv;

	private Boolean isLogUsuGestComerSupComerSupAdmin;
	
	//HREOS-4836 (GENCAT)
	private Boolean afectoAGencat;
	
	private Boolean tieneComunicacionGencat;

	private int ocupado;
	private int conTitulo;
	private String tipoInquilino;
	private String tipoEstadoAlquiler;

	//HREOS-4545
	private Boolean tieneOfertaAlquilerViva;
	private Boolean esGestorAlquiler;
	
	//HREOS-5573
	private Boolean unidadAlquilable;
	private Boolean activoMatriz;
	private Long numActivoMatriz;
	private Double porcentajeParticipacion;
	private Long unidadesAlquilablesEnAgrupacion;
	private String idPrinexHPM;
	private Boolean isPANoDadaDeBaja;
	
	private Boolean agrupacionDadaDeBaja;
	
	private String ofertasVivas;
	private String trabajosVivos;
	
	private Boolean cambioEstadoPublicacion;;
	private Boolean cambioEstadoPrecio;
	private Boolean cambioEstadoActivo; 
	
	//Contador de ofertas y visitas
	private Long ofertasTotal;
	private Long visitasTotal;
	
	// Datos Perimetro Apple
	private String servicerActivoCodigo;
	private String servicerActivoDescripcion;
	private String cesionSaneamientoCodigo;
	private String cesionSaneamientoDescripcion;
	private Integer perimetroMacc;
	private Integer perimetroCartera;
	private String nombreCarteraPerimetro;;
	
	private String tipoEquipoGestionCodigo;
	private String tipoEquipoGestionDescripcion;

	private Boolean checkGestionarReadOnly;
	private Boolean checkPublicacionReadOnly;
	private Boolean checkComercializarReadOnly;
	private Boolean checkFormalizarReadOnly;
	
	// Es tramitable bankia
	private Boolean tramitable;

	private String nombreMediador;
	private String sociedadPagoAnterior; 
	private Boolean mostrarEditarFasePublicacion;
	
	private Boolean pazSocial;
	private String numActivoDivarian;
	private Boolean activoEpa;
    private String empresa;
    private String oficina;
    private String contrapartida;
    private String folio;
    private String cdpen;
    
	private String numActivoBbva;
    private Long lineaFactura;
    private Long idOrigenHre;
    private String uicBbva;
    private String cexperBbva;
    private String tipoTransmisionCodigo;
    private String tipoAltaCodigo;
    private String tipoTransmisionDescripcion;
    private String tipoAltaDescripcion;
    private Boolean isGrupoOficinaKAM;


	//Estado Admision
	private Boolean incluidoEnPerimetroAdmision;
	private String estadoAdmisionCodigo;
	private String subestadoAdmisionCodigo;
	private String estadoAdmisionCodigoNuevo;
	private String subestadoAdmisionCodigoNuevo;
	private String observacionesAdmision;
	private Boolean perimetroAdmision;
	private String fechaPerimetroAdmision;
	private String motivoPerimetroAdmision;
	private String estadoAdmisionDesc;
	private String subestadoAdmisionDesc;
	private String estadoAdmisionCodCabecera;
	private String subestadoAdmisionCodCabecera;
	private String estadoAdmisionDescCabecera;
	private String subestadoAdmisionDescCabecera;
	
	//Visible Gestion comercial
	private Boolean excluirValidacionesBool;
	private Date fechaGestionComercial;
	private Boolean checkGestorComercial;
	private String motivoGestionComercialCodigo;
	private String motivoGestionComercialDescripcion;
	private Boolean restringido;  
	private Boolean esEditableActivoEstadoRegistral;
	private String estadoFisicoActivoDND;
	private String estadoFisicoActivoDNDDescripcion;
	private Double porcentajeConstruccion;
	private Boolean isEditablePorcentajeConstruccion;

	private Boolean activoChkPerimetroAlquiler;
	private List<?> activosAgrupacionRestringida;

	private Boolean tieneOkTecnico;

	private Long activoPrincipalRestringida;
	
	private String codPromocionBbva;
	
	private String procedenciaProductoCodigo;
	
	private String procedenciaProductoDescripcion;

	private String direccionDos;

	private String categoriaComercializacionCod;
	
	private String categoriaComercializacionDesc;
	
	private String tipoDistritoCodigoPostalCod;
	private String tipoDistritoCodigoPostalDesc;
	private String numActivoCaixa;
	
	private String bloque;
	
	private String codSubfasePublicacion;
	
	private Boolean esActivoPrincipalAgrupacionRestringida;
	
	private String unidadEconomicaCaixa;
	private String disponibleAdministrativoCodigo;
	private String disponibleAdministrativoDescripcion;
	private String disponibleTecnicoCodigo;
	private String disponibleTecnicoDescripcion;
	private String motivoTecnicoCodigo;
	private String motivoTecnicoDescripcion;
	private String tieneGestionDndCodigo;
	private String tieneGestionDndDescripcion;
	
	private Boolean esHayaHome;
	

	private String codComunidadAutonoma;
	private String comunidadDescripcion;
	
	private Boolean discrepanciasLocalizacion;
	private String discrepanciasLocalizacionObservaciones;
	
	private Boolean enConcurrencia;

	private Boolean activoOfertasConcurrencia;

	private String numeroInmuebleAnterior;

	private String anejoGarajeCodigo;
	private String anejoGarajeDescripcion;
	private String anejoTrasteroCodigo;
	private String anejoTrasteroDescripcion;
	private Long identificadorPlazaParking;
	private Long identificadorTrastero;

	public Boolean getTieneOfertaAlquilerViva() {
		return tieneOfertaAlquilerViva;
	}

	public void setTieneOfertaAlquilerViva(Boolean tieneOfertaAlquilerViva) {
		this.tieneOfertaAlquilerViva = tieneOfertaAlquilerViva;
	}

	public Boolean getEsGestorAlquiler() {
		return esGestorAlquiler;
	}

	public void setEsGestorAlquiler(Boolean esGestorAlquiler) {
		this.esGestorAlquiler = esGestorAlquiler;
	}

	public int getConTitulo() {
		return conTitulo;
	}

	public void setConTitulo(int conTitulo) {
		this.conTitulo = conTitulo;
	}

	public String getTipoInquilino() {
		return tipoInquilino;
	}

	public void setTipoInquilino(String tipoInquilino) {
		this.tipoInquilino = tipoInquilino;
	}

	public String getTipoEstadoAlquiler() {
		return tipoEstadoAlquiler;
	}

	public void setTipoEstadoAlquiler(String tipoEstadoAlquiler) {
		this.tipoEstadoAlquiler = tipoEstadoAlquiler;
	}

	public int getOcupado() {
		return ocupado;
	}

	public void setOcupado(int ocupado) {
		this.ocupado = ocupado;
	}

	public Boolean getTieneOkTecnico() {
		return tieneOkTecnico;
	}

	public void setTieneOkTecnico(Boolean tieneOkTecnico) {
		this.tieneOkTecnico = tieneOkTecnico;
	}

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
	
	public String getEstadoActivoDescripcion() {
		return estadoActivoDescripcion;
	}

	public void setEstadoActivoDescripcion(String estadoActivoDescripcion) {
		this.estadoActivoDescripcion = estadoActivoDescripcion;
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
	
	public String getPaisDescripcion() {
		return paisDescripcion;
	}

	public void setPaisDescripcion(String paisDescripcion) {
		this.paisDescripcion = paisDescripcion;
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

	public String getEstadoVentaDescripcion() {
		return estadoVentaDescripcion;
	}

	public void setEstadoVentaDescripcion(String estadoVentaDescripcion) {
		this.estadoVentaDescripcion = estadoVentaDescripcion;
	}

	public String getEstadoAlquilerDescripcion() {
		return estadoAlquilerDescripcion;
	}

	public void setEstadoAlquilerDescripcion(String estadoAlquilerDescripcion) {
		this.estadoAlquilerDescripcion = estadoAlquilerDescripcion;
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

	public Boolean getPerteneceAgrupacionRestringidaVigente() {
		return perteneceAgrupacionRestringidaVigente;
	}

	public void setPerteneceAgrupacionRestringidaVigente(Boolean perteneceAgrupacionRestringidaVigente) {
		this.perteneceAgrupacionRestringidaVigente = perteneceAgrupacionRestringidaVigente;
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

	public String getEntradaActivoBankiaDescripcion() {
		return entradaActivoBankiaDescripcion;
	}

	public void setEntradaActivoBankiaDescripcion(String entradaActivoBankiaDescripcion) {
		this.entradaActivoBankiaDescripcion = entradaActivoBankiaDescripcion;
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

	public Boolean getAplicaPublicar() {
		return aplicaPublicar;
	}

	public void setAplicaPublicar(Boolean aplicaPublicar) {
		this.aplicaPublicar = aplicaPublicar;
	}

	public Date getFechaAplicaPublicar() {
		return fechaAplicaPublicar;
	}

	public void setFechaAplicaPublicar(Date fechaAplicaPublicar) {
		this.fechaAplicaPublicar = fechaAplicaPublicar;
	}

	public String getMotivoAplicaPublicar() {
		return motivoAplicaPublicar;
	}

	public void setMotivoAplicaPublicar(String motivoAplicaPublicar) {
		this.motivoAplicaPublicar = motivoAplicaPublicar;
	}

	public String getAcreedorNumExp() {
		return acreedorNumExp;
	}

	public void setAcreedorNumExp(String acreedorNumExp) {
		this.acreedorNumExp = acreedorNumExp;
	}

	public Integer getEnTramite() {
		return enTramite;
	}

	public void setEnTramite(Integer enTramite) {
		this.enTramite = enTramite;
	}

	public Boolean getPertenceAgrupacionProyecto() {
		return pertenceAgrupacionProyecto;
	}

	public void setPertenceAgrupacionProyecto(Boolean pertenceAgrupacionProyecto) {
		this.pertenceAgrupacionProyecto = pertenceAgrupacionProyecto;
	}

	public String getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(String idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Boolean getTienePromocion() {
		return tienePromocion;
	}

	public void setTienePromocion(Boolean tienePromocion) {
		this.tienePromocion = tienePromocion;
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
	public Boolean getAsignaGestPorCambioDeProv() {
		return asignaGestPorCambioDeProv;
	}

	public void setAsignaGestPorCambioDeProv(Boolean asignaGestPorCambioDeProv) {
		this.asignaGestPorCambioDeProv = asignaGestPorCambioDeProv;
	}

	public Boolean getIsLogUsuGestComerSupComerSupAdmin() {
		return isLogUsuGestComerSupComerSupAdmin;
	}

	public void setIsLogUsuGestComerSupComerSupAdmin(Boolean isLogUsuGestComerSupComerSupAdmin) {
		this.isLogUsuGestComerSupComerSupAdmin = isLogUsuGestComerSupComerSupAdmin;
	}

	public Boolean getAfectoAGencat() {
		return afectoAGencat;
	}

	public void setAfectoAGencat(Boolean afectoAGencat) {
		this.afectoAGencat = afectoAGencat;
	}

	public String getEstadoComunicacionGencatCodigo() {
		return estadoComunicacionGencatCodigo;
	}

	public void setEstadoComunicacionGencatCodigo(String estadoComunicacionGencatCodigo) {
		this.estadoComunicacionGencatCodigo = estadoComunicacionGencatCodigo;
	}

	public Boolean getActivoChkPerimetroAlquiler() {
		return activoChkPerimetroAlquiler;
	}

	public void setActivoChkPerimetroAlquiler(Boolean activoChkPerimetroAlquiler) {
		this.activoChkPerimetroAlquiler = activoChkPerimetroAlquiler;
	}

	public List<?> getActivosAgrupacionRestringida() {
		return activosAgrupacionRestringida;
	}

	public void setActivosAgrupacionRestringida(List<?> activosAgrupacionRestringida) {
		this.activosAgrupacionRestringida = activosAgrupacionRestringida;
	}

	public Long getActivoPrincipalRestringida() {
		return activoPrincipalRestringida;
	}

	public void setActivoPrincipalRestringida(Long activoPrincipalRestringida) {
		this.activoPrincipalRestringida = activoPrincipalRestringida;
	}

	public String getMotivoActivo() {
		return motivoActivo;
	}

	public void setMotivoActivo(String motivoActivo) {
		this.motivoActivo = motivoActivo;
	}

	public Boolean getTieneCEE() {
		return tieneCEE;
	}

	public void setTieneCEE(Boolean tieneCEE) {
		this.tieneCEE = tieneCEE;
	}

	public Boolean isTieneCEE() {
		return tieneCEE;
	}

	public Boolean getUnidadAlquilable() {
		return unidadAlquilable;
	}

	public void setUnidadAlquilable(Boolean unidadAlquilable) {
		this.unidadAlquilable = unidadAlquilable;
	}

	public Boolean getActivoMatriz() {
		return activoMatriz;
	}

	public void setActivoMatriz(Boolean activoMatriz) {
		this.activoMatriz = activoMatriz;
	}

	public Long getNumActivoMatriz() {
		return numActivoMatriz;
	}

	public void setNumActivoMatriz(Long numActivoMatriz) {
		this.numActivoMatriz = numActivoMatriz;
	}

	public Double getPorcentajeParticipacion() {
		return porcentajeParticipacion;
	}

	public void setPorcentajeParticipacion(Double porcentajeParticipacion) {
		this.porcentajeParticipacion = porcentajeParticipacion;
	}

	public Long getUnidadesAlquilablesEnAgrupacion() {
		return unidadesAlquilablesEnAgrupacion;
	}
	public void setUnidadesAlquilablesEnAgrupacion(Long unidadesAlquilablesEnAgrupacion) {
	this.unidadesAlquilablesEnAgrupacion = unidadesAlquilablesEnAgrupacion;
	}

	public List<Activo> getActivosPropagablesUas() {
		return activosPropagablesUas;
	}

	public void setActivosPropagablesUas(List<Activo> activosPropagablesUas) {
		this.activosPropagablesUas = activosPropagablesUas;
	}

	public String getIdPrinexHPM() {
		return idPrinexHPM;
	}

	public void setIdPrinexHPM(String idPrinexHPM) {
		this.idPrinexHPM = idPrinexHPM;
	}

	public Boolean getIsPANoDadaDeBaja() {
		return isPANoDadaDeBaja;
	}

	public void setIsPANoDadaDeBaja(Boolean isPANoDadaDeBaja) {
		this.isPANoDadaDeBaja = isPANoDadaDeBaja;
	}

	public Boolean getAgrupacionDadaDeBaja() {
		return agrupacionDadaDeBaja;
	}

	public void setAgrupacionDadaDeBaja(Boolean agrupacionDadaDeBaja) {
		this.agrupacionDadaDeBaja = agrupacionDadaDeBaja;
	}

	public Boolean getTieneComunicacionGencat() {
		return tieneComunicacionGencat;
	}

	public void setTieneComunicacionGencat(Boolean tieneComunicacionGencat) {
		this.tieneComunicacionGencat = tieneComunicacionGencat;
	}
		
	public Boolean getTieneRegistroContrato() {
		return tieneRegistroContrato;
	}

	public void setTieneRegistroContrato(Boolean tieneRegistroContrato) {
		this.tieneRegistroContrato = tieneRegistroContrato;
	}

	public String getOfertasVivas() {
		return ofertasVivas;
	}

	public void setOfertasVivas(String ofertasVivas) {
		this.ofertasVivas = ofertasVivas;
	}

	public String getTrabajosVivos() {
		return trabajosVivos;
	}

	public void setTrabajosVivos(String trabajosVivos) {
		this.trabajosVivos = trabajosVivos;
	}
	
	public Integer getDiasCambioEstadoActivo() {
		return diasCambioEstadoActivo;
	}

	public void setDiasCambioEstadoActivo(Integer diasCambioEstadoActivo) {
		this.diasCambioEstadoActivo = diasCambioEstadoActivo;
	}

	public Boolean getCambioEstadoPublicacion() {
		return cambioEstadoPublicacion;
	}

	public void setCambioEstadoPublicacion(Boolean cambioEstadoPublicacion) {
		this.cambioEstadoPublicacion = cambioEstadoPublicacion;
	}

	public Boolean getCambioEstadoPrecio() {
		return cambioEstadoPrecio;
	}

	public void setCambioEstadoPrecio(Boolean cambioEstadoPrecio) {
		this.cambioEstadoPrecio = cambioEstadoPrecio;
	}

	public Boolean getCambioEstadoActivo() {
		return cambioEstadoActivo;
	}

	public void setCambioEstadoActivo(Boolean cambioEstadoActivo) {
		this.cambioEstadoActivo = cambioEstadoActivo;
	}
	
	public Long getOfertasTotal() {
		return ofertasTotal;
	}

	public void setOfertasTotal(Long ofertasTotal) {
		this.ofertasTotal = ofertasTotal;
	}

	public Long getVisitasTotal() {
		return visitasTotal;
	}

	public void setVisitasTotal(Long visitasTotal) {
		this.visitasTotal = visitasTotal;
	}

	public String getServicerActivoCodigo() {
		return servicerActivoCodigo;
	}

	public void setServicerActivoCodigo(String servicerActivoCodigo) {
		this.servicerActivoCodigo = servicerActivoCodigo;
	}
	
	public String getServicerActivoDescripcion() {
		return servicerActivoDescripcion;
	}

	public void setServicerActivoDescripcion(String servicerActivoDescripcion) {
		this.servicerActivoDescripcion = servicerActivoDescripcion;
	}

	public String getCesionSaneamientoCodigo() {
		return cesionSaneamientoCodigo;
	}

	public void setCesionSaneamientoCodigo(String cesionSaneamientoCodigo) {
		this.cesionSaneamientoCodigo = cesionSaneamientoCodigo;
	}
	
	public String getCesionSaneamientoDescripcion() {
		return cesionSaneamientoDescripcion;
	}

	public void setCesionSaneamientoDescripcion(String cesionSaneamientoDescripcion) {
		this.cesionSaneamientoDescripcion = cesionSaneamientoDescripcion;
	}

	public Integer getPerimetroMacc() {
		return perimetroMacc;
	}

	public void setPerimetroMacc(Integer perimetroMacc) {
		this.perimetroMacc = perimetroMacc;
	}

	public Integer getPerimetroCartera() {
		return perimetroCartera;
	}

	public void setPerimetroCartera(Integer perimetroCartera) {
		this.perimetroCartera = perimetroCartera;
	}

	public String getNombreCarteraPerimetro() {
		return nombreCarteraPerimetro;
	}

	public void setNombreCarteraPerimetro(String nombreCarteraPerimetro) {
		this.nombreCarteraPerimetro = nombreCarteraPerimetro;
	}	

	public String getTipoEquipoGestionCodigo() {
		return tipoEquipoGestionCodigo;
	}

	public void setTipoEquipoGestionCodigo(String tipoEquipoGestionCodigo) {
		this.tipoEquipoGestionCodigo = tipoEquipoGestionCodigo;
	}

	public String getTipoEquipoGestionDescripcion() {
		return tipoEquipoGestionDescripcion;
	}

	public void setTipoEquipoGestionDescripcion(String tipoEquipoGestionDescripcion) {
		this.tipoEquipoGestionDescripcion = tipoEquipoGestionDescripcion;
	}

	public Boolean getCheckGestionarReadOnly() {
		return checkGestionarReadOnly;
	}

	public void setCheckGestionarReadOnly(Boolean checkGestionarReadOnly) {
		this.checkGestionarReadOnly = checkGestionarReadOnly;
	}

	public Boolean getCheckPublicacionReadOnly() {
		return checkPublicacionReadOnly;
	}

	public void setCheckPublicacionReadOnly(Boolean checkPublicacionReadOnly) {
		this.checkPublicacionReadOnly = checkPublicacionReadOnly;
	}

	public Boolean getCheckComercializarReadOnly() {
		return checkComercializarReadOnly;
	}

	public void setCheckComercializarReadOnly(Boolean checkComercializarReadOnly) {
		this.checkComercializarReadOnly = checkComercializarReadOnly;
	}

	public Boolean getCheckFormalizarReadOnly() {
		return checkFormalizarReadOnly;
	}

	public void setCheckFormalizarReadOnly(Boolean checkFormalizarReadOnly) {
		this.checkFormalizarReadOnly = checkFormalizarReadOnly;
	}
	
	public String getNombreMediador() {
		return nombreMediador;
	}

	public void setNombreMediador(String nombreMediador) {
		this.nombreMediador = nombreMediador;
	}
	public Boolean getTramitable() {
		return tramitable;
	}

	public void setTramitable(Boolean tramitable) {
		this.tramitable = tramitable;
	}

	public Boolean getEsSarebProyecto() {
		return esSarebProyecto;
	}

	public void setEsSarebProyecto(Boolean esSarebProyecto) {
		this.esSarebProyecto = esSarebProyecto;
	}

	public String getSociedadPagoAnterior() {
		return sociedadPagoAnterior;
	}

	public void setSociedadPagoAnterior(String sociedadPagoAnterior) {
		this.sociedadPagoAnterior = sociedadPagoAnterior;
	}

	public Boolean getMostrarEditarFasePublicacion() {
		return mostrarEditarFasePublicacion;
	}

	public void setMostrarEditarFasePublicacion(Boolean mostrarEditarFasePublicacion) {
		this.mostrarEditarFasePublicacion = mostrarEditarFasePublicacion;
	}
	
	public Boolean getPazSocial() {
		return pazSocial;
	}

	public void setPazSocial(Boolean pazSocial) {
		this.pazSocial = pazSocial;
	}

	public String getTipoSegmentoCodigo() {
		return tipoSegmentoCodigo;
	}

	public void setTipoSegmentoCodigo(String tipoSegmentoCodigo) {
		this.tipoSegmentoCodigo = tipoSegmentoCodigo;
	}
	
	public String getTipoSegmentoDescripcion() {
		return tipoSegmentoDescripcion;
	}

	public void setTipoSegmentoDescripcion(String tipoSegmentoDescripcion) {
		this.tipoSegmentoDescripcion = tipoSegmentoDescripcion;
	}

	public Boolean getIsUA() {
		return isUA;
	}

	public void setIsUA(Boolean isUA) {
		this.isUA = isUA;
	}

	public String getNumActivoDivarian() {
		return numActivoDivarian;
	}

	public void setNumActivoDivarian(String numActivoDivarian) {
		this.numActivoDivarian = numActivoDivarian;
	}
	
	public Boolean getActivoEpa() {
		return activoEpa;
	}

	public void setActivoEpa(Boolean activoEpa) {
		this.activoEpa = activoEpa;
	}

	public String getEmpresa() {
		return empresa;
	}

	public void setEmpresa(String empresa) {
		this.empresa = empresa;
	}

	public String getOficina() {
		return oficina;
	}

	public void setOficina(String oficina) {
		this.oficina = oficina;
	}

	public String getContrapartida() {
		return contrapartida;
	}

	public void setContrapartida(String contrapartida) {
		this.contrapartida = contrapartida;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getNumActivoBbva() {
		return numActivoBbva;
	}

	public void setNumActivoBbva(String numActivoBbva) {
		this.numActivoBbva = numActivoBbva;
	}

	public Long getLineaFactura() {
		return lineaFactura;
	}

	public void setLineaFactura(Long lineaFactura) {
		this.lineaFactura = lineaFactura;
	}

	public Long getIdOrigenHre() {
		return idOrigenHre;
	}

	public void setIdOrigenHre(Long idOrigenHre) {
		this.idOrigenHre = idOrigenHre;
	}

	public String getUicBbva() {
		return uicBbva;
	}

	public void setUicBbva(String uicBbva) {
		this.uicBbva = uicBbva;
	}

	public String getCexperBbva() {
		return cexperBbva;
	}

	public void setCexperBbva(String cexperBbva) {
		this.cexperBbva = cexperBbva;
	}

	public String getTipoTransmisionCodigo() {
		return tipoTransmisionCodigo;
	}

	public void setTipoTransmisionCodigo(String tipoTransmisionCodigo) {
		this.tipoTransmisionCodigo = tipoTransmisionCodigo;
	}

	public String getTipoAltaCodigo() {
		return tipoAltaCodigo;
	}

	public void setTipoAltaCodigo(String tipoAltaCodigo) {
		this.tipoAltaCodigo = tipoAltaCodigo;
	}

	public String getTipoTransmisionDescripcion() {
		return tipoTransmisionDescripcion;
	}

	public void setTipoTransmisionDescripcion(String tipoTransmisionDescripcion) {
		this.tipoTransmisionDescripcion = tipoTransmisionDescripcion;
	}

	public String getTipoAltaDescripcion() {
		return tipoAltaDescripcion;
	}

	public void setTipoAltaDescripcion(String tipoAltaDescripcion) {
		this.tipoAltaDescripcion = tipoAltaDescripcion;
	}

	public Boolean getIsGrupoOficinaKAM() {
		return isGrupoOficinaKAM;
	}

	public void setIsGrupoOficinaKAM(Boolean isGrupoOficinaKAM) {
		this.isGrupoOficinaKAM = isGrupoOficinaKAM;
	}

	public String getTipoActivoCodigoOE() {
		return tipoActivoCodigoOE;
	}

	public void setTipoActivoCodigoOE(String tipoActivoCodigoOE) {
		this.tipoActivoCodigoOE = tipoActivoCodigoOE;
	}

	public String getSubtipoActivoCodigoOE() {
		return subtipoActivoCodigoOE;
	}

	public void setSubtipoActivoCodigoOE(String subtipoActivoCodigoOE) {
		this.subtipoActivoCodigoOE = subtipoActivoCodigoOE;
	}

	public String getTipoActivoDescripcionOE() {
		return tipoActivoDescripcionOE;
	}

	public void setTipoActivoDescripcionOE(String tipoActivoDescripcionOE) {
		this.tipoActivoDescripcionOE = tipoActivoDescripcionOE;
	}

	public String getSubtipoActivoDescripcionOE() {
		return subtipoActivoDescripcionOE;
	}

	public void setSubtipoActivoDescripcionOE(String subtipoActivoDescripcionOE) {
		this.subtipoActivoDescripcionOE = subtipoActivoDescripcionOE;
	}

	public String getCodPostalOE() {
		return codPostalOE;
	}

	public void setCodPostalOE(String codPostalOE) {
		this.codPostalOE = codPostalOE;
	}

	public String getEscaleraOE() {
		return escaleraOE;
	}

	public void setEscaleraOE(String escaleraOE) {
		this.escaleraOE = escaleraOE;
	}

	public String getPuertaOE() {
		return puertaOE;
	}

	public void setPuertaOE(String puertaOE) {
		this.puertaOE = puertaOE;
	}

	public String getPisoOE() {
		return pisoOE;
	}

	public void setPisoOE(String pisoOE) {
		this.pisoOE = pisoOE;
	}

	public String getNumeroDomicilioOE() {
		return numeroDomicilioOE;
	}

	public void setNumeroDomicilioOE(String numeroDomicilioOE) {
		this.numeroDomicilioOE = numeroDomicilioOE;
	}

	public String getNombreViaOE() {
		return nombreViaOE;
	}

	public void setNombreViaOE(String nombreViaOE) {
		this.nombreViaOE = nombreViaOE;
	}

	public String getMunicipioCodigoOE() {
		return municipioCodigoOE;
	}

	public void setMunicipioCodigoOE(String municipioCodigoOE) {
		this.municipioCodigoOE = municipioCodigoOE;
	}

	public String getMunicipioDescripcionOE() {
		return municipioDescripcionOE;
	}

	public void setMunicipioDescripcionOE(String municipioDescripcionOE) {
		this.municipioDescripcionOE = municipioDescripcionOE;
	}

	public String getProvinciaCodigoOE() {
		return provinciaCodigoOE;
	}

	public void setProvinciaCodigoOE(String provinciaCodigoOE) {
		this.provinciaCodigoOE = provinciaCodigoOE;
	}

	public String getProvinciaDescripcionOE() {
		return provinciaDescripcionOE;
	}

	public void setProvinciaDescripcionOE(String provinciaDescripcionOE) {
		this.provinciaDescripcionOE = provinciaDescripcionOE;
	}

	public String getTipoViaCodigoOE() {
		return tipoViaCodigoOE;
	}

	public void setTipoViaCodigoOE(String tipoViaCodigoOE) {
		this.tipoViaCodigoOE = tipoViaCodigoOE;
	}

	public String getTipoViaDescripcionOE() {
		return tipoViaDescripcionOE;
	}

	public void setTipoViaDescripcionOE(String tipoViaDescripcionOE) {
		this.tipoViaDescripcionOE = tipoViaDescripcionOE;
	}

	public String getLatitudOE() {
		return latitudOE;
	}

	public void setLatitudOE(String latitudOE) {
		this.latitudOE = latitudOE;
	}

	public String getLongitudOE() {
		return longitudOE;
	}

	public void setLongitudOE(String longitudOE) {
		this.longitudOE = longitudOE;
	}

	public Boolean getReoContabilizadoSap() {
		return reoContabilizadoSap;
	}

	public void setReoContabilizadoSap(Boolean reoContabilizadoSap) {
		this.reoContabilizadoSap = reoContabilizadoSap;
	}
	
	public Boolean getPerimetroAdmision() {
		return perimetroAdmision;
	}

	public void setPerimetroAdmision(Boolean perimetroAdmision) {
		this.perimetroAdmision = perimetroAdmision;
	}


	public String getFechaPerimetroAdmision() {
		return fechaPerimetroAdmision;
	}

	public void setFechaPerimetroAdmision(String fechaPerimetroAdmision) {
		this.fechaPerimetroAdmision = fechaPerimetroAdmision;
	}

	public String getMotivoPerimetroAdmision() {
		return motivoPerimetroAdmision;
	}

	public void setMotivoPerimetroAdmision(String motivoPerimetroAdmision) {
		this.motivoPerimetroAdmision = motivoPerimetroAdmision;
	}

	public Boolean getIncluidoEnPerimetroAdmision() {
		return incluidoEnPerimetroAdmision;
	}

	public void setIncluidoEnPerimetroAdmision(Boolean incluidoEnPerimetroAdmision) {
		this.incluidoEnPerimetroAdmision = incluidoEnPerimetroAdmision;
	}

	public String getEstadoAdmisionCodigo() {
		return estadoAdmisionCodigo;
	}

	public void setEstadoAdmisionCodigo(String estadoAdmisionCodigo) {
		this.estadoAdmisionCodigo = estadoAdmisionCodigo;
	}

	public String getSubestadoAdmisionCodigo() {
		return subestadoAdmisionCodigo;
	}

	public void setSubestadoAdmisionCodigo(String subestadoAdmisionCodigo) {
		this.subestadoAdmisionCodigo = subestadoAdmisionCodigo;
	}

	public String getEstadoAdmisionCodigoNuevo() {
		return estadoAdmisionCodigoNuevo;
	}

	public void setEstadoAdmisionCodigoNuevo(String estadoAdmisionCodigoNuevo) {
		this.estadoAdmisionCodigoNuevo = estadoAdmisionCodigoNuevo;
	}

	public String getSubestadoAdmisionCodigoNuevo() {
		return subestadoAdmisionCodigoNuevo;
	}

	public void setSubestadoAdmisionCodigoNuevo(String subestadoAdmisionCodigoNuevo) {
		this.subestadoAdmisionCodigoNuevo = subestadoAdmisionCodigoNuevo;
	}

	public String getObservacionesAdmision() {
		return observacionesAdmision;
	}

	public void setObservacionesAdmision(String observacionesAdmision) {
		this.observacionesAdmision = observacionesAdmision;
	}

	public String getEstadoAdmisionDesc() {
		return estadoAdmisionDesc;
	}

	public void setEstadoAdmisionDesc(String estadoAdmisionDesc) {
		this.estadoAdmisionDesc = estadoAdmisionDesc;
	}

	public String getSubestadoAdmisionDesc() {
		return subestadoAdmisionDesc;
	}

	public void setSubestadoAdmisionDesc(String subestadoAdmisionDesc) {
		this.subestadoAdmisionDesc = subestadoAdmisionDesc;
	}

	public String getEstadoAdmisionCodCabecera() {
		return estadoAdmisionCodCabecera;
	}

	public void setEstadoAdmisionCodCabecera(String estadoAdmisionCodCabecera) {
		this.estadoAdmisionCodCabecera = estadoAdmisionCodCabecera;
	}

	public String getSubestadoAdmisionCodCabecera() {
		return subestadoAdmisionCodCabecera;
	}

	public void setSubestadoAdmisionCodCabecera(String subestadoAdmisionCodCabecera) {
		this.subestadoAdmisionCodCabecera = subestadoAdmisionCodCabecera;
	}

	public String getEstadoAdmisionDescCabecera() {
		return estadoAdmisionDescCabecera;
	}

	public void setEstadoAdmisionDescCabecera(String estadoAdmisionDescCabecera) {
		this.estadoAdmisionDescCabecera = estadoAdmisionDescCabecera;
	}

	public String getSubestadoAdmisionDescCabecera() {
		return subestadoAdmisionDescCabecera;
	}

	public void setSubestadoAdmisionDescCabecera(String subestadoAdmisionDescCabecera) {
		this.subestadoAdmisionDescCabecera = subestadoAdmisionDescCabecera;
	}

	public String getEstadoRegistralCodigo() {
		return estadoRegistralCodigo;
	}

	public void setEstadoRegistralCodigo(String estadoRegistralCodigo) {
		this.estadoRegistralCodigo = estadoRegistralCodigo;
	}
	
	public String getEstadoRegistralDescripcion() {
		return estadoRegistralDescripcion;
	}

	public void setEstadoRegistralDescripcion(String estadoRegistralDescripcion) {
		this.estadoRegistralDescripcion = estadoRegistralDescripcion;
	}
	
	public Boolean getEsEditableActivoEstadoRegistral() {
		return esEditableActivoEstadoRegistral;
	}

	public void setEsEditableActivoEstadoRegistral(Boolean esEditableActivoEstadoRegistral) {
		this.esEditableActivoEstadoRegistral = esEditableActivoEstadoRegistral;
	}

	public Boolean getExcluirValidacionesBool() {
		return excluirValidacionesBool;
	}

	public void setExcluirValidacionesBool(Boolean excluirValidacionesBool) {
		this.excluirValidacionesBool = excluirValidacionesBool;
	}

	public Date getFechaGestionComercial() {
		return fechaGestionComercial;
	}

	public void setFechaGestionComercial(Date fechaGestionComercial) {
		this.fechaGestionComercial = fechaGestionComercial;
	}


	public String getMotivoGestionComercialCodigo() {
		return motivoGestionComercialCodigo;
	}

	public void setMotivoGestionComercialCodigo(String motivoGestionComercialCodigo) {
		this.motivoGestionComercialCodigo = motivoGestionComercialCodigo;
	}

	public String getMotivoGestionComercialDescripcion() {
		return motivoGestionComercialDescripcion;
	}

	public void setMotivoGestionComercialDescripcion(String motivoGestionComercialDescripcion) {
		this.motivoGestionComercialDescripcion = motivoGestionComercialDescripcion;
	}

	public Boolean getCheckGestorComercial() {
		return checkGestorComercial;
	}

	public void setCheckGestorComercial(Boolean checkGestorComercial) {
		this.checkGestorComercial = checkGestorComercial;
	}

	public Boolean getRestringido() {
		return restringido;
	}

	public void setRestringido(Boolean restringido) {
		this.restringido = restringido;
	}

	public String getCodSubfasePublicacion() {
		return codSubfasePublicacion;
	}

	public void setCodSubfasePublicacion(String codSubfasePublicacion) {
		this.codSubfasePublicacion = codSubfasePublicacion;
	}
	
	public Date getFechaFinPrevistaAdecuacion() {
		return fechaFinPrevistaAdecuacion;
	}

	public void setFechaFinPrevistaAdecuacion(Date fechaFinPrevistaAdecuacion) {
		this.fechaFinPrevistaAdecuacion = fechaFinPrevistaAdecuacion;
	}

	public String getEstadoAdecuacionSarebCodigo() {
		return estadoAdecuacionSarebCodigo;
	}

	public void setEstadoAdecuacionSarebCodigo(String estadoAdecuacionSarebCodigo) {
		this.estadoAdecuacionSarebCodigo = estadoAdecuacionSarebCodigo;
	}

	public String getEstadoAdecuacionSarebDescripcion() {
		return estadoAdecuacionSarebDescripcion;
	}

	public void setEstadoAdecuacionSarebDescripcion(String estadoAdecuacionSarebDescripcion) {
		this.estadoAdecuacionSarebDescripcion = estadoAdecuacionSarebDescripcion;
	}

	public String getEstadoFisicoActivoDND() {
		return estadoFisicoActivoDND;
	}

	public void setEstadoFisicoActivoDND(String estadoFisicoActivoDND) {
		this.estadoFisicoActivoDND = estadoFisicoActivoDND;
	}

	public Double getPorcentajeConstruccion() {
		return porcentajeConstruccion;
	}

	public void setPorcentajeConstruccion(Double porcentajeConstruccion) {
		this.porcentajeConstruccion = porcentajeConstruccion;
	}

	public Boolean getIsEditablePorcentajeConstruccion() {
		return isEditablePorcentajeConstruccion;
	}

	public void setIsEditablePorcentajeConstruccion(Boolean isEditablePorcentajeConstruccion) {
		this.isEditablePorcentajeConstruccion = isEditablePorcentajeConstruccion;
	}

	public String getCodPromocionBbva() {
		return codPromocionBbva;
	}

	public void setCodPromocionBbva(String codPromocionBbva) {
		this.codPromocionBbva = codPromocionBbva;
	}

	public String getCdpen() {
		return cdpen;
	}

	public void setCdpen(String cdpen) {
		this.cdpen = cdpen;
	}

	public Boolean getEsActivoPrincipalAgrupacionRestringida() {
		return esActivoPrincipalAgrupacionRestringida;
	}

	public void setEsActivoPrincipalAgrupacionRestringida(Boolean esActivoPrincipalAgrupacionRestringida) {
		this.esActivoPrincipalAgrupacionRestringida = esActivoPrincipalAgrupacionRestringida;
	}

	public String getEstadoFisicoActivoDNDDescripcion() {
		return estadoFisicoActivoDNDDescripcion;
	}

	public void setEstadoFisicoActivoDNDDescripcion(String estadoFisicoActivoDNDDescripcion) {
		this.estadoFisicoActivoDNDDescripcion = estadoFisicoActivoDNDDescripcion;
	}

	public String getProcedenciaProductoCodigo() {
		return procedenciaProductoCodigo;
	}

	public void setProcedenciaProductoCodigo(String procedenciaProductoCodigo) {
		this.procedenciaProductoCodigo = procedenciaProductoCodigo;
	}

	public String getProcedenciaProductoDescripcion() {
		return procedenciaProductoDescripcion;
	}

	public void setProcedenciaProductoDescripcion(String procedenciaProductoDescripcion) {
		this.procedenciaProductoDescripcion = procedenciaProductoDescripcion;
	}
	public String getDireccionDos() {
		return direccionDos;
	}

	public void setDireccionDos(String direccionDos) {
		this.direccionDos = direccionDos;
	}
	public String getCategoriaComercializacionCod() {
		return categoriaComercializacionCod;
	}

	public void setCategoriaComercializacionCod(String categoriaComercializacionCod) {
		this.categoriaComercializacionCod = categoriaComercializacionCod;
	}

	public String getCategoriaComercializacionDesc() {
		return categoriaComercializacionDesc;
	}

	public void setCategoriaComercializacionDesc(String categoriaComercializacionDesc) {
		this.categoriaComercializacionDesc = categoriaComercializacionDesc;
	}

	public String getPlantaEdificioCodigo() {
		return plantaEdificioCodigo;
	}

	public void setPlantaEdificioCodigo(String plantaEdificioCodigo) {
		this.plantaEdificioCodigo = plantaEdificioCodigo;
	}

	public String getPlantaEdificioDescripcion() {
		return plantaEdificioDescripcion;
	}

	public void setPlantaEdificioDescripcion(String plantaEdificioDescripcion) {
		this.plantaEdificioDescripcion = plantaEdificioDescripcion;
	}

	public String getEscaleraEdificioCodigo() {
		return escaleraEdificioCodigo;
	}

	public void setEscaleraEdificioCodigo(String escaleraEdificioCodigo) {
		this.escaleraEdificioCodigo = escaleraEdificioCodigo;
	}

	public String getEscaleraEdificioDescripcion() {
		return escaleraEdificioDescripcion;
	}

	public void setEscaleraEdificioDescripcion(String escaleraEdificioDescripcion) {
		this.escaleraEdificioDescripcion = escaleraEdificioDescripcion;
	}	
	
	public String getTipoDistritoCodigoPostalCod() {
		return tipoDistritoCodigoPostalCod;
	}

	public void setTipoDistritoCodigoPostalCod(String tipoDistritoCodigoPostalCod) {
		this.tipoDistritoCodigoPostalCod = tipoDistritoCodigoPostalCod;
	}

	public String getTipoDistritoCodigoPostalDesc() {
		return tipoDistritoCodigoPostalDesc;
	}

	public void setTipoDistritoCodigoPostalDesc(String tipoDistritoCodigoPostalDesc) {
		this.tipoDistritoCodigoPostalDesc = tipoDistritoCodigoPostalDesc;
	}

	public String getNumActivoCaixa() {
		return numActivoCaixa;
	}

	public void setNumActivoCaixa(String numActivoCaixa) {
		this.numActivoCaixa = numActivoCaixa;
	}

	public String getBloque() {
		return bloque;
	}

	public void setBloque(String bloque) {
		this.bloque = bloque;
	}

	public String getDescuentoAprobadoAlquiler() {
		return descuentoAprobadoAlquiler;
	}

	public void setDescuentoAprobadoAlquiler(String descuentoAprobadoAlquiler) {
		this.descuentoAprobadoAlquiler = descuentoAprobadoAlquiler;
	}

	public String getDisponibleAdministrativoCodigo() {
		return disponibleAdministrativoCodigo;
	}

	public void setDisponibleAdministrativoCodigo(String disponibleAdministrativoCodigo) {
		this.disponibleAdministrativoCodigo = disponibleAdministrativoCodigo;
	}
	
	public String getDisponibleAdministrativoDescripcion() {
		return disponibleAdministrativoDescripcion;
	}

	public void setDisponibleAdministrativoDescripcion(String disponibleAdministrativoDescripcion) {
		this.disponibleAdministrativoDescripcion = disponibleAdministrativoDescripcion;
	}
	
	public String getDisponibleTecnicoCodigo() {
		return disponibleTecnicoCodigo;
	}

	public void setDisponibleTecnicoCodigo(String disponibleTecnicoCodigo) {
		this.disponibleTecnicoCodigo = disponibleTecnicoCodigo;
	}
	
	public String getDisponibleTecnicoDescripcion() {
		return disponibleTecnicoDescripcion;
	}

	public void setDisponibleTecnicoDescripcion(String disponibleTecnicoDescripcion) {
		this.disponibleTecnicoDescripcion = disponibleTecnicoDescripcion;
	}
	
	public String getMotivoTecnicoCodigo() {
		return motivoTecnicoCodigo;
	}

	public void setMotivoTecnicoCodigo(String motivoTecnicoCodigo) {
		this.motivoTecnicoCodigo = motivoTecnicoCodigo;
	}
	
	public String getMotivoTecnicoDescripcion() {
		return motivoTecnicoDescripcion;
	}

	public void setMotivoTecnicoDescripcion(String motivoTecnicoDescripcion) {
		this.motivoTecnicoDescripcion = motivoTecnicoDescripcion;
	}
	
	public String getTieneGestionDndCodigo() {
		return tieneGestionDndCodigo;
	}

	public void setTieneGestionDndCodigo(String tieneGestionDndCodigo) {
		this.tieneGestionDndCodigo = tieneGestionDndCodigo;
	}
	
	public String getTieneGestionDndDescripcion() {
		return tieneGestionDndDescripcion;
	}

	public void setTieneGestionDndDescripcion(String tieneGestionDndDescripcion) {
		this.tieneGestionDndDescripcion = tieneGestionDndDescripcion;
	}

	public Boolean getEsHayaHome() {
		return esHayaHome;
	}

	public void setEsHayaHome(Boolean esHayaHome) {
		this.esHayaHome = esHayaHome;
	}


	public String getDescuentoPublicadoAlquiler() {
		return descuentoPublicadoAlquiler;
	}

	public void setDescuentoPublicadoAlquiler(String descuentoPublicadoAlquiler) {
		this.descuentoPublicadoAlquiler = descuentoPublicadoAlquiler;
	}

	public String getUnidadEconomicaCaixa() {
		return unidadEconomicaCaixa;
	}

	public void setUnidadEconomicaCaixa(String unidadEconomicaCaixa) {
		this.unidadEconomicaCaixa = unidadEconomicaCaixa;
	}

	public String getCodComunidadAutonoma() {
		return codComunidadAutonoma;
	}

	public void setCodComunidadAutonoma(String codComunidadAutonoma) {
		this.codComunidadAutonoma = codComunidadAutonoma;
	}

	public String getComunidadDescripcion() {
		return comunidadDescripcion;
	}

	public void setComunidadDescripcion(String comunidadDescripcion) {
		this.comunidadDescripcion = comunidadDescripcion;
	}

	public String getNumeroInmuebleAnterior() {
		return numeroInmuebleAnterior;
	}

	public void setNumeroInmuebleAnterior(String numeroInmuebleAnterior) {
		this.numeroInmuebleAnterior = numeroInmuebleAnterior;
	}

	public Boolean getDiscrepanciasLocalizacion() {
		return discrepanciasLocalizacion;
	}

	public void setDiscrepanciasLocalizacion(Boolean discrepanciasLocalizacion) {
		this.discrepanciasLocalizacion = discrepanciasLocalizacion;
	}

	public String getDiscrepanciasLocalizacionObservaciones() {
		return discrepanciasLocalizacionObservaciones;
	}

	public void setDiscrepanciasLocalizacionObservaciones(String discrepanciasLocalizacionObservaciones) {
		this.discrepanciasLocalizacionObservaciones = discrepanciasLocalizacionObservaciones;
	}

	public Boolean getEnConcurrencia() {
		return enConcurrencia;
	}

	public void setEnConcurrencia(Boolean enConcurrencia) {
		this.enConcurrencia = enConcurrencia;
	}

	public Boolean getActivoOfertasConcurrencia() {
		return activoOfertasConcurrencia;
	}

	public void setActivoOfertasConcurrencia(Boolean activoOfertasConcurrencia) {
		this.activoOfertasConcurrencia = activoOfertasConcurrencia;
	}

	public String getAnejoGarajeCodigo() {
		return anejoGarajeCodigo;
	}

	public void setAnejoGarajeCodigo(String anejoGarajeCodigo) {
		this.anejoGarajeCodigo = anejoGarajeCodigo;
	}

	public String getAnejoGarajeDescripcion() {
		return anejoGarajeDescripcion;
	}

	public void setAnejoGarajeDescripcion(String anejoGarajeDescripcion) {
		this.anejoGarajeDescripcion = anejoGarajeDescripcion;
	}

	public String getAnejoTrasteroCodigo() {
		return anejoTrasteroCodigo;
	}

	public void setAnejoTrasteroCodigo(String anejoTrasteroCodigo) {
		this.anejoTrasteroCodigo = anejoTrasteroCodigo;
	}

	public String getAnejoTrasteroDescripcion() {
		return anejoTrasteroDescripcion;
	}

	public void setAnejoTrasteroDescripcion(String anejoTrasteroDescripcion) {
		this.anejoTrasteroDescripcion = anejoTrasteroDescripcion;
	}

	public Long getIdentificadorPlazaParking() {
		return identificadorPlazaParking;
	}

	public void setIdentificadorPlazaParking(Long identificadorPlazaParking) {
		this.identificadorPlazaParking = identificadorPlazaParking;
	}

	public Long getIdentificadorTrastero() {
		return identificadorTrastero;
	}

	public void setIdentificadorTrastero(Long identificadorTrastero) {
		this.identificadorTrastero = identificadorTrastero;
	}

}