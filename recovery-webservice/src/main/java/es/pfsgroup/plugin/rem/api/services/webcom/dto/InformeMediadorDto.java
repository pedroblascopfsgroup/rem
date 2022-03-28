package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class InformeMediadorDto implements WebcomRESTDto {
	@WebcomRequired //No se puede quitar
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired //No se puede quitar
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idActivoHaya;
	@WebcomRequired
	private LongDataType idInformeMediadorRem;
	@WebcomRequired
	private LongDataType idInformeMediadorWebcom;
	@WebcomRequired
	private LongDataType idProveedorRem; 
	@WebcomRequired
	private StringDataType codTipoVenta; 
	@WebcomRequired
	private StringDataType estadoInforme; 
	@WebcomRequired
	private StringDataType motivoRechazo;
	@WebcomRequired
	private StringDataType codCartera;
	@WebcomRequired
	private StringDataType codSubCartera; 
	@WebcomRequired
	private BooleanDataType perimetroMacc;
	@WebcomRequired
	private DoubleDataType porcentajePropiedad;
	@WebcomRequired
	private StringDataType codRegimenProteccion;
	@WebcomRequired
	private DoubleDataType lat;
	@WebcomRequired
	private DoubleDataType lng;
	@WebcomRequired
	private StringDataType nombreGestorPublicaciones;
	@WebcomRequired
	private StringDataType emailGestorPublicaciones;
	@WebcomRequired
	private DateDataType envioLlavesAApi;
	@WebcomRequired
	private StringDataType codEstadoOcupacional;
	@WebcomRequired
	private DateDataType fechaRecepcionLlavesApi;
	@WebcomRequired
	private LongDataType anyoConstruccion;
	@WebcomRequired
	private StringDataType codTipoActivo;
	@WebcomRequired
	private StringDataType codSubtipoInmueble;
	@WebcomRequired
	private StringDataType codTipoVia;
	@WebcomRequired
	private StringDataType nombreCalle;
	@WebcomRequired
	private StringDataType numeroCalle;
	@WebcomRequired
	private StringDataType escalera;
	@WebcomRequired
	private StringDataType planta;
	@WebcomRequired
	private StringDataType puerta;
	@WebcomRequired
	private StringDataType codPedania;
	@WebcomRequired
	private StringDataType codMunicipio;
	@WebcomRequired
	private StringDataType codProvincia;
	@WebcomRequired
	private StringDataType codigoPostal;
	@WebcomRequired
	private LongDataType numeroDormitorios;
	@WebcomRequired
	private LongDataType numeroBanyos;
	@WebcomRequired
	private LongDataType numeroPlazasGaraje;
	@WebcomRequired
	private LongDataType numeroAseos;
	@WebcomRequired
	private BooleanDataType terraza;
	@WebcomRequired
	private BooleanDataType patio;
	@WebcomRequired
	private BooleanDataType ascensor;
	@WebcomRequired
	private DoubleDataType utilSuperficie;
	@WebcomRequired
	private BooleanDataType rehabilitado;
	@WebcomRequired
	private LongDataType anyoRehabilitacion;
	@WebcomRequired
	private BooleanDataType licenciaApertura;
	@WebcomRequired
	private BooleanDataType licenciaObra;
	@WebcomRequired
	private DateDataType fechaRecepcionInforme;
	@WebcomRequired
	private DateDataType ultimaModificacionInforme;
	@WebcomRequired
	private StringDataType ultimaModificacionInformePor;
	//@WebcomRequired
	//private DateDataType primerEnvioInformeCompletado; //falta en vista
	//@WebcomRequired
	//private StringDataType primerEnvioInformeCompletadoPor; //falta en vista
	
	private BooleanDataType esVisitable;
	
	private DateDataType fechaUltimaVisita;
	
	private StringDataType descripcionComercial;
	
	private StringDataType codEstadoConservacion;
	
	private BooleanDataType anejoGaraje;
	
	private BooleanDataType anejoTrastero;
	
	private StringDataType cocinaRating;
	
	private BooleanDataType cocinaAmueblada;
	
	private StringDataType codCalefaccion;
	
	private StringDataType codTipoCalefaccion;
	
	private StringDataType codAireAcondicionado;
	
	private BooleanDataType existenArmariosEmpotrados;
	
	private DoubleDataType superficieTerraza;
	
	private DoubleDataType superficiePatio;
	
	private StringDataType exteriorInterior;
	
	private BooleanDataType existenZonasVerdes;
	
	private BooleanDataType existeConserjeVigilancia;
	
	private StringDataType jardin;
	
	private StringDataType piscina;
	
	private BooleanDataType existenInstalacionesDeportivas;
	
	private StringDataType gimnasio;
	
	private BooleanDataType accesoMinusvalidosOtrasCaracteristicas;
	
	private StringDataType codEstadoConservacionEdificio;
	
	private LongDataType numeroPlantasEdificio;
	
	private StringDataType codTipoPuertaAcceso;
	
	private StringDataType codEstadoPuertasInteriores;
	
	private StringDataType codEstadoVentanas;
	
	private StringDataType codEstadoPersianas;
	
	private StringDataType codEstadoPintura;
	
	private StringDataType codEstadoSolados;
	
	private StringDataType codAdmiteMascota;
	
	private StringDataType codEstadoBanyos;
	
	private StringDataType codValoracionUbicacion;
	
	private StringDataType codUbicacion;
	
	private BooleanDataType salidaHumosOtrasCaracteristicas;
	
	private BooleanDataType aptoUsoEnBruto;
	
	private StringDataType accesibilidad;
	
	private DoubleDataType edificabilidadSuperficieTecho;
	
	private DoubleDataType parcelaSuperficie;
	
	private DoubleDataType porcentajeUrbanizacionEjecutado;
	
	private StringDataType clasificacion;
	
	private StringDataType codUso;
	
	private DoubleDataType metrosLinealesFachadaPrincipal;
	
	private BooleanDataType almacen;
	
	private DoubleDataType almacenSuperficie;
	
	private BooleanDataType superficieVentaExposicion;
	
	private DoubleDataType superficieVentaExposicionConstruido;
	
	private BooleanDataType entreplanta;
	
	private DoubleDataType altura;
	
	private DoubleDataType porcentajeEdificacionEjecutada;
	
	private BooleanDataType ocupado;
	
	private DateDataType visitableFechaVisita;
	
	private DoubleDataType valorEstimadoMinVenta;
	
	private DoubleDataType valorEstimadoMaxVenta;
	
	private DoubleDataType valorEstimadoVenta;
	
	private DoubleDataType valorEstimadoMaxRenta;
	
	private DoubleDataType valorEstimadoMinRenta;
	
	private DoubleDataType valorEstimadoRenta;
	
	private LongDataType numeroSalones;
	
	private LongDataType numeroEstancias;
	
	private LongDataType numeroPlantas;
	
	public LongDataType getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(LongDataType idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public DateDataType getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(DateDataType fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public LongDataType getIdProveedorRem() {
		return idProveedorRem;
	}
	public void setIdProveedorRem(LongDataType idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}
	public LongDataType getIdInformeMediadorRem() {
		return idInformeMediadorRem;
	}
	public void setIdInformeMediadorRem(LongDataType idInformeMediadorRem) {
		this.idInformeMediadorRem = idInformeMediadorRem;
	}
	public LongDataType getIdInformeMediadorWebcom() {
		return idInformeMediadorWebcom;
	}
	public void setIdInformeMediadorWebcom(LongDataType idInformeMediadorWebcom) {
		this.idInformeMediadorWebcom = idInformeMediadorWebcom;
	}
	public StringDataType getCodTipoVenta() {
		return codTipoVenta;
	}
	public void setCodTipoVenta(StringDataType codTipoVenta) {
		this.codTipoVenta = codTipoVenta;
	}
	public StringDataType getEstadoInforme() {
		return estadoInforme;
	}
	public void setEstadoInforme(StringDataType estadoInforme) {
		this.estadoInforme = estadoInforme;
	}
	public StringDataType getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(StringDataType motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public StringDataType getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(StringDataType codCartera) {
		this.codCartera = codCartera;
	}
	public StringDataType getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(StringDataType codSubCartera) {
		this.codSubCartera = codSubCartera;
	}
	public BooleanDataType getPerimetroMacc() {
		return perimetroMacc;
	}
	public void setPerimetroMacc(BooleanDataType perimetroMacc) {
		this.perimetroMacc = perimetroMacc;
	}
	public DoubleDataType getPorcentajePropiedad() {
		return porcentajePropiedad;
	}
	public void setPorcentajePropiedad(DoubleDataType porcentajePropiedad) {
		this.porcentajePropiedad = porcentajePropiedad;
	}
	public StringDataType getCodRegimenProteccion() {
		return codRegimenProteccion;
	}
	public void setCodRegimenProteccion(StringDataType codRegimenProteccion) {
		this.codRegimenProteccion = codRegimenProteccion;
	}
	public DoubleDataType getLat() {
		return lat;
	}
	public void setLat(DoubleDataType lat) {
		this.lat = lat;
	}
	public DoubleDataType getLng() {
		return lng;
	}
	public void setLng(DoubleDataType lng) {
		this.lng = lng;
	}
	public StringDataType getNombreGestorPublicaciones() {
		return nombreGestorPublicaciones;
	}
	public void setNombreGestorPublicaciones(StringDataType nombreGestorPublicaciones) {
		this.nombreGestorPublicaciones = nombreGestorPublicaciones;
	}
	public StringDataType getEmailGestorPublicaciones() {
		return emailGestorPublicaciones;
	}
	public void setEmailGestorPublicaciones(StringDataType emailGestorPublicaciones) {
		this.emailGestorPublicaciones = emailGestorPublicaciones;
	}
	/*public BooleanDataType getPublicado() {
		return publicado;
	}
	public void setPublicado(BooleanDataType publicado) {
		this.publicado = publicado;
	}*/
	public DateDataType getEnvioLlavesAApi() {
		return envioLlavesAApi;
	}
	public void setEnvioLlavesAApi(DateDataType envioLlavesAApi) {
		this.envioLlavesAApi = envioLlavesAApi;
	}
	/*public DateDataType getFechaPosesion() {
		return fechaPosesion;
	}
	public void setFechaPosesion(DateDataType fechaPosesion) {
		this.fechaPosesion = fechaPosesion;
	}*/
	public StringDataType getCodEstadoOcupacional() {
		return codEstadoOcupacional;
	}
	public void setCodEstadoOcupacional(StringDataType codEstadoOcupacional) {
		this.codEstadoOcupacional = codEstadoOcupacional;
	}
	public DateDataType getFechaRecepcionLlavesApi() {
		return fechaRecepcionLlavesApi;
	}
	public void setFechaRecepcionLlavesApi(DateDataType fechaRecepcionLlavesApi) {
		this.fechaRecepcionLlavesApi = fechaRecepcionLlavesApi;
	}
	public LongDataType getAnyoConstruccion() {
		return anyoConstruccion;
	}
	public void setAnyoConstruccion(LongDataType anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}
	public StringDataType getCodTipoActivo() {
		return codTipoActivo;
	}
	public void setCodTipoActivo(StringDataType codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}
	public StringDataType getCodSubtipoInmueble() {
		return codSubtipoInmueble;
	}
	public void setCodSubtipoInmueble(StringDataType codSubtipoInmueble) {
		this.codSubtipoInmueble = codSubtipoInmueble;
	}
	public StringDataType getCodTipoVia() {
		return codTipoVia;
	}
	public void setCodTipoVia(StringDataType codTipoVia) {
		this.codTipoVia = codTipoVia;
	}
	public StringDataType getNombreCalle() {
		return nombreCalle;
	}
	public void setNombreCalle(StringDataType nombreCalle) {
		this.nombreCalle = nombreCalle;
	}
	public StringDataType getNumeroCalle() {
		return numeroCalle;
	}
	public void setNumeroCalle(StringDataType numeroCalle) {
		this.numeroCalle = numeroCalle;
	}
	public StringDataType getEscalera() {
		return escalera;
	}
	public void setEscalera(StringDataType escalera) {
		this.escalera = escalera;
	}
	public StringDataType getPlanta() {
		return planta;
	}
	public void setPlanta(StringDataType planta) {
		this.planta = planta;
	}
	public StringDataType getPuerta() {
		return puerta;
	}
	public void setPuerta(StringDataType puerta) {
		this.puerta = puerta;
	}
	public StringDataType getCodPedania() {
		return codPedania;
	}
	public void setCodPedania(StringDataType codPedania) {
		this.codPedania = codPedania;
	}
	public StringDataType getCodMunicipio() {
		return codMunicipio;
	}
	public void setCodMunicipio(StringDataType codMunicipio) {
		this.codMunicipio = codMunicipio;
	}
	public StringDataType getCodProvincia() {
		return codProvincia;
	}
	public void setCodProvincia(StringDataType codProvincia) {
		this.codProvincia = codProvincia;
	}
	public StringDataType getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(StringDataType codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public LongDataType getNumeroDormitorios() {
		return numeroDormitorios;
	}
	public void setNumeroDormitorios(LongDataType numeroDormitorios) {
		this.numeroDormitorios = numeroDormitorios;
	}
	public LongDataType getNumeroBanyos() {
		return numeroBanyos;
	}
	public void setNumeroBanyos(LongDataType numeroBanyos) {
		this.numeroBanyos = numeroBanyos;
	}
	public LongDataType getNumeroPlazasGaraje() {
		return numeroPlazasGaraje;
	}
	public void setNumeroPlazasGaraje(LongDataType numeroPlazasGaraje) {
		this.numeroPlazasGaraje = numeroPlazasGaraje;
	}
	public LongDataType getNumeroAseos() {
		return numeroAseos;
	}
	public void setNumeroAseos(LongDataType numeroAseos) {
		this.numeroAseos = numeroAseos;
	}
	public BooleanDataType getTerraza() {
		return terraza;
	}
	public void setTerraza(BooleanDataType terraza) {
		this.terraza = terraza;
	}
	public BooleanDataType getPatio() {
		return patio;
	}
	public void setPatio(BooleanDataType patio) {
		this.patio = patio;
	}
	public BooleanDataType getAscensor() {
		return ascensor;
	}
	public void setAscensor(BooleanDataType ascensor) {
		this.ascensor = ascensor;
	}
	public BooleanDataType getRehabilitado() {
		return rehabilitado;
	}
	public void setRehabilitado(BooleanDataType rehabilitado) {
		this.rehabilitado = rehabilitado;
	}
	public LongDataType getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}
	public void setAnyoRehabilitacion(LongDataType anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}
	public BooleanDataType getLicenciaApertura() {
		return licenciaApertura;
	}
	public void setLicenciaApertura(BooleanDataType licenciaApertura) {
		this.licenciaApertura = licenciaApertura;
	}
	public BooleanDataType getLicenciaObra() {
		return licenciaObra;
	}
	public void setLicenciaObra(BooleanDataType licenciaObra) {
		this.licenciaObra = licenciaObra;
	}
	public DateDataType getFechaRecepcionInforme() {
		return fechaRecepcionInforme;
	}
	public void setFechaRecepcionInforme(DateDataType fechaRecepcionInforme) {
		this.fechaRecepcionInforme = fechaRecepcionInforme;
	}
	public DateDataType getUltimaModificacionInforme() {
		return ultimaModificacionInforme;
	}
	public void setUltimaModificacionInforme(DateDataType ultimaModificacionInforme) {
		this.ultimaModificacionInforme = ultimaModificacionInforme;
	}
	public StringDataType getUltimaModificacionInformePor() {
		return ultimaModificacionInformePor;
	}
	public void setUltimaModificacionInformePor(StringDataType ultimaModificacionInformePor) {
		this.ultimaModificacionInformePor = ultimaModificacionInformePor;
	}
	/*public DateDataType getPrimerEnvioInformeCompletado() {
		return primerEnvioInformeCompletado;
	}
	public void setPrimerEnvioInformeCompletado(DateDataType primerEnvioInformeCompletado) {
		this.primerEnvioInformeCompletado = primerEnvioInformeCompletado;
	}
	public StringDataType getPrimerEnvioInformeCompletadoPor() {
		return primerEnvioInformeCompletadoPor;
	}
	public void setPrimerEnvioInformeCompletadoPor(StringDataType primerEnvioInformeCompletadoPor) {
		this.primerEnvioInformeCompletadoPor = primerEnvioInformeCompletadoPor;
	}*/
	public DoubleDataType getUtilSuperficie() {
		return utilSuperficie;
	}
	public void setUtilSuperficie(DoubleDataType utilSuperficie) {
		this.utilSuperficie = utilSuperficie;
	}
	public BooleanDataType getEsVisitable() {
		return esVisitable;
	}
	public void setEsVisitable(BooleanDataType esVisitable) {
		this.esVisitable = esVisitable;
	}
	public DateDataType getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}
	public void setFechaUltimaVisita(DateDataType fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
	}
	public StringDataType getDescripcionComercial() {
		return descripcionComercial;
	}
	public void setDescripcionComercial(StringDataType descripcionComercial) {
		this.descripcionComercial = descripcionComercial;
	}
	public StringDataType getCodEstadoConservacion() {
		return codEstadoConservacion;
	}
	public void setCodEstadoConservacion(StringDataType codEstadoConservacion) {
		this.codEstadoConservacion = codEstadoConservacion;
	}
	public BooleanDataType getAnejoGaraje() {
		return anejoGaraje;
	}
	public void setAnejoGaraje(BooleanDataType anejoGaraje) {
		this.anejoGaraje = anejoGaraje;
	}
	public BooleanDataType getAnejoTrastero() {
		return anejoTrastero;
	}
	public void setAnejoTrastero(BooleanDataType anejoTrastero) {
		this.anejoTrastero = anejoTrastero;
	}
	public StringDataType getCocinaRating() {
		return cocinaRating;
	}
	public void setCocinaRating(StringDataType cocinaRating) {
		this.cocinaRating = cocinaRating;
	}
	public BooleanDataType getCocinaAmueblada() {
		return cocinaAmueblada;
	}
	public void setCocinaAmueblada(BooleanDataType cocinaAmueblada) {
		this.cocinaAmueblada = cocinaAmueblada;
	}
	public StringDataType getCodCalefaccion() {
		return codCalefaccion;
	}
	public void setCodCalefaccion(StringDataType codCalefaccion) {
		this.codCalefaccion = codCalefaccion;
	}
	public StringDataType getCodTipoCalefaccion() {
		return codTipoCalefaccion;
	}
	public void setCodTipoCalefaccion(StringDataType codTipoCalefaccion) {
		this.codTipoCalefaccion = codTipoCalefaccion;
	}
	public StringDataType getCodAireAcondicionado() {
		return codAireAcondicionado;
	}
	public void setCodAireAcondicionado(StringDataType codAireAcondicionado) {
		this.codAireAcondicionado = codAireAcondicionado;
	}
	public BooleanDataType getExistenArmariosEmpotrados() {
		return existenArmariosEmpotrados;
	}
	public void setExistenArmariosEmpotrados(BooleanDataType existenArmariosEmpotrados) {
		this.existenArmariosEmpotrados = existenArmariosEmpotrados;
	}
	public DoubleDataType getSuperficieTerraza() {
		return superficieTerraza;
	}
	public void setSuperficieTerraza(DoubleDataType superficieTerraza) {
		this.superficieTerraza = superficieTerraza;
	}
	public DoubleDataType getSuperficiePatio() {
		return superficiePatio;
	}
	public void setSuperficiePatio(DoubleDataType superficiePatio) {
		this.superficiePatio = superficiePatio;
	}
	public StringDataType getExteriorInterior() {
		return exteriorInterior;
	}
	public void setExteriorInterior(StringDataType exteriorInterior) {
		this.exteriorInterior = exteriorInterior;
	}
	public BooleanDataType getExistenZonasVerdes() {
		return existenZonasVerdes;
	}
	public void setExistenZonasVerdes(BooleanDataType existenZonasVerdes) {
		this.existenZonasVerdes = existenZonasVerdes;
	}
	public BooleanDataType getExisteConserjeVigilancia() {
		return existeConserjeVigilancia;
	}
	public void setExisteConserjeVigilancia(BooleanDataType existeConserjeVigilancia) {
		this.existeConserjeVigilancia = existeConserjeVigilancia;
	}
	public StringDataType getJardin() {
		return jardin;
	}
	public void setJardin(StringDataType jardin) {
		this.jardin = jardin;
	}
	public StringDataType getPiscina() {
		return piscina;
	}
	public void setPiscina(StringDataType piscina) {
		this.piscina = piscina;
	}
	public BooleanDataType getExistenInstalacionesDeportivas() {
		return existenInstalacionesDeportivas;
	}
	public void setExistenInstalacionesDeportivas(BooleanDataType existenInstalacionesDeportivas) {
		this.existenInstalacionesDeportivas = existenInstalacionesDeportivas;
	}
	public StringDataType getGimnasio() {
		return gimnasio;
	}
	public void setGimnasio(StringDataType gimnasio) {
		this.gimnasio = gimnasio;
	}
	public BooleanDataType getAccesoMinusvalidosOtrasCaracteristicas() {
		return accesoMinusvalidosOtrasCaracteristicas;
	}
	public void setAccesoMinusvalidosOtrasCaracteristicas(BooleanDataType accesoMinusvalidosOtrasCaracteristicas) {
		this.accesoMinusvalidosOtrasCaracteristicas = accesoMinusvalidosOtrasCaracteristicas;
	}
	public StringDataType getCodEstadoConservacionEdificio() {
		return codEstadoConservacionEdificio;
	}
	public void setCodEstadoConservacionEdificio(StringDataType codEstadoConservacionEdificio) {
		this.codEstadoConservacionEdificio = codEstadoConservacionEdificio;
	}
	public LongDataType getNumeroPlantasEdificio() {
		return numeroPlantasEdificio;
	}
	public void setNumeroPlantasEdificio(LongDataType numeroPlantasEdificio) {
		this.numeroPlantasEdificio = numeroPlantasEdificio;
	}
	public StringDataType getCodTipoPuertaAcceso() {
		return codTipoPuertaAcceso;
	}
	public void setCodTipoPuertaAcceso(StringDataType codTipoPuertaAcceso) {
		this.codTipoPuertaAcceso = codTipoPuertaAcceso;
	}
	public StringDataType getCodEstadoPuertasInteriores() {
		return codEstadoPuertasInteriores;
	}
	public void setCodEstadoPuertasInteriores(StringDataType codEstadoPuertasInteriores) {
		this.codEstadoPuertasInteriores = codEstadoPuertasInteriores;
	}
	public StringDataType getCodEstadoVentanas() {
		return codEstadoVentanas;
	}
	public void setCodEstadoVentanas(StringDataType codEstadoVentanas) {
		this.codEstadoVentanas = codEstadoVentanas;
	}
	public StringDataType getCodEstadoPersianas() {
		return codEstadoPersianas;
	}
	public void setCodEstadoPersianas(StringDataType codEstadoPersianas) {
		this.codEstadoPersianas = codEstadoPersianas;
	}
	public StringDataType getCodEstadoPintura() {
		return codEstadoPintura;
	}
	public void setCodEstadoPintura(StringDataType codEstadoPintura) {
		this.codEstadoPintura = codEstadoPintura;
	}
	public StringDataType getCodEstadoSolados() {
		return codEstadoSolados;
	}
	public void setCodEstadoSolados(StringDataType codEstadoSolados) {
		this.codEstadoSolados = codEstadoSolados;
	}
	public StringDataType getCodAdmiteMascota() {
		return codAdmiteMascota;
	}
	public void setCodAdmiteMascota(StringDataType codAdmiteMascota) {
		this.codAdmiteMascota = codAdmiteMascota;
	}
	public StringDataType getCodEstadoBanyos() {
		return codEstadoBanyos;
	}
	public void setCodEstadoBanyos(StringDataType codEstadoBanyos) {
		this.codEstadoBanyos = codEstadoBanyos;
	}
	public StringDataType getCodValoracionUbicacion() {
		return codValoracionUbicacion;
	}
	public void setCodValoracionUbicacion(StringDataType codValoracionUbicacion) {
		this.codValoracionUbicacion = codValoracionUbicacion;
	}
	public StringDataType getCodUbicacion() {
		return codUbicacion;
	}
	public void setCodUbicacion(StringDataType codUbicacion) {
		this.codUbicacion = codUbicacion;
	}
	public BooleanDataType getSalidaHumosOtrasCaracteristicas() {
		return salidaHumosOtrasCaracteristicas;
	}
	public void setSalidaHumosOtrasCaracteristicas(BooleanDataType salidaHumosOtrasCaracteristicas) {
		this.salidaHumosOtrasCaracteristicas = salidaHumosOtrasCaracteristicas;
	}
	public BooleanDataType getAptoUsoEnBruto() {
		return aptoUsoEnBruto;
	}
	public void setAptoUsoEnBruto(BooleanDataType aptoUsoEnBruto) {
		this.aptoUsoEnBruto = aptoUsoEnBruto;
	}
	public StringDataType getAccesibilidad() {
		return accesibilidad;
	}
	public void setAccesibilidad(StringDataType accesibilidad) {
		this.accesibilidad = accesibilidad;
	}
	public DoubleDataType getEdificabilidadSuperficieTecho() {
		return edificabilidadSuperficieTecho;
	}
	public void setEdificabilidadSuperficieTecho(DoubleDataType edificabilidadSuperficieTecho) {
		this.edificabilidadSuperficieTecho = edificabilidadSuperficieTecho;
	}
	public DoubleDataType getParcelaSuperficie() {
		return parcelaSuperficie;
	}
	public void setParcelaSuperficie(DoubleDataType parcelaSuperficie) {
		this.parcelaSuperficie = parcelaSuperficie;
	}
	public DoubleDataType getPorcentajeUrbanizacionEjecutado() {
		return porcentajeUrbanizacionEjecutado;
	}
	public void setPorcentajeUrbanizacionEjecutado(DoubleDataType porcentajeUrbanizacionEjecutado) {
		this.porcentajeUrbanizacionEjecutado = porcentajeUrbanizacionEjecutado;
	}
	public StringDataType getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(StringDataType clasificacion) {
		this.clasificacion = clasificacion;
	}
	public StringDataType getCodUso() {
		return codUso;
	}
	public void setCodUso(StringDataType codUso) {
		this.codUso = codUso;
	}
	public DoubleDataType getMetrosLinealesFachadaPrincipal() {
		return metrosLinealesFachadaPrincipal;
	}
	public void setMetrosLinealesFachadaPrincipal(DoubleDataType metrosLinealesFachadaPrincipal) {
		this.metrosLinealesFachadaPrincipal = metrosLinealesFachadaPrincipal;
	}
	public BooleanDataType getAlmacen() {
		return almacen;
	}
	public void setAlmacen(BooleanDataType almacen) {
		this.almacen = almacen;
	}
	public DoubleDataType getAlmacenSuperficie() {
		return almacenSuperficie;
	}
	public void setAlmacenSuperficie(DoubleDataType almacenSuperficie) {
		this.almacenSuperficie = almacenSuperficie;
	}
	public BooleanDataType getSuperficieVentaExposicion() {
		return superficieVentaExposicion;
	}
	public void setSuperficieVentaExposicion(BooleanDataType superficieVentaExposicion) {
		this.superficieVentaExposicion = superficieVentaExposicion;
	}
	public DoubleDataType getSuperficieVentaExposicionConstruido() {
		return superficieVentaExposicionConstruido;
	}
	public void setSuperficieVentaExposicionConstruido(DoubleDataType superficieVentaExposicionConstruido) {
		this.superficieVentaExposicionConstruido = superficieVentaExposicionConstruido;
	}
	public BooleanDataType getEntreplanta() {
		return entreplanta;
	}
	public void setEntreplanta(BooleanDataType entreplanta) {
		this.entreplanta = entreplanta;
	}
	public DoubleDataType getAltura() {
		return altura;
	}
	public void setAltura(DoubleDataType altura) {
		this.altura = altura;
	}
	public DoubleDataType getPorcentajeEdificacionEjecutada() {
		return porcentajeEdificacionEjecutada;
	}
	public void setPorcentajeEdificacionEjecutada(DoubleDataType porcentajeEdificacionEjecutada) {
		this.porcentajeEdificacionEjecutada = porcentajeEdificacionEjecutada;
	}
	public BooleanDataType getOcupado() {
		return ocupado;
	}
	public void setOcupado(BooleanDataType ocupado) {
		this.ocupado = ocupado;
	}
	public DateDataType getVisitableFechaVisita() {
		return visitableFechaVisita;
	}
	public void setVisitableFechaVisita(DateDataType visitableFechaVisita) {
		this.visitableFechaVisita = visitableFechaVisita;
	}
	public DoubleDataType getValorEstimadoMinVenta() {
		return valorEstimadoMinVenta;
	}
	public void setValorEstimadoMinVenta(DoubleDataType valorEstimadoMinVenta) {
		this.valorEstimadoMinVenta = valorEstimadoMinVenta;
	}
	public DoubleDataType getValorEstimadoMaxVenta() {
		return valorEstimadoMaxVenta;
	}
	public void setValorEstimadoMaxVenta(DoubleDataType valorEstimadoMaxVenta) {
		this.valorEstimadoMaxVenta = valorEstimadoMaxVenta;
	}
	public DoubleDataType getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}
	public void setValorEstimadoVenta(DoubleDataType valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}
	public DoubleDataType getValorEstimadoMaxRenta() {
		return valorEstimadoMaxRenta;
	}
	public void setValorEstimadoMaxRenta(DoubleDataType valorEstimadoMaxRenta) {
		this.valorEstimadoMaxRenta = valorEstimadoMaxRenta;
	}
	public DoubleDataType getValorEstimadoMinRenta() {
		return valorEstimadoMinRenta;
	}
	public void setValorEstimadoMinRenta(DoubleDataType valorEstimadoMinRenta) {
		this.valorEstimadoMinRenta = valorEstimadoMinRenta;
	}
	public DoubleDataType getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}
	public void setValorEstimadoRenta(DoubleDataType valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}
	public LongDataType getNumeroSalones() {
		return numeroSalones;
	}
	public void setNumeroSalones(LongDataType numeroSalones) {
		this.numeroSalones = numeroSalones;
	}
	public LongDataType getNumeroEstancias() {
		return numeroEstancias;
	}
	public void setNumeroEstancias(LongDataType numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}
	public LongDataType getNumeroPlantas() {
		return numeroPlantas;
	}
	public void setNumeroPlantas(LongDataType numeroPlantas) {
		this.numeroPlantas = numeroPlantas;
	}	
}
