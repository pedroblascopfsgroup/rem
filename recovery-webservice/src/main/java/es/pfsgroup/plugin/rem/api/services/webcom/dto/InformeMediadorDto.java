package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
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
	private StringDataType codEstadoInforme; //falta en vista
	@WebcomRequired
	private StringDataType motivoRechazo;
	@WebcomRequired
	private StringDataType codCartera;
	@WebcomRequired
	private StringDataType codSubCartera; 
	@WebcomRequired
	private BooleanDataType perimetroMacc; 
	@WebcomRequired
	private StringDataType referenciaCatastral;
	@WebcomRequired
	private StringDataType codEstadoPublicacion;
	@WebcomRequired
	private StringDataType codSubfasePublicacion;
	@WebcomRequired
	private StringDataType fincaRegistral;
	@WebcomRequired
	private DoubleDataType porcentajePropiedad;
	@WebcomRequired
	private StringDataType codRegimenProteccion;
	@WebcomRequired
	private LongDataType codigoAgrupacionObraNueva; 
	@WebcomRequired
	private LongDataType idLoteRem;
	@WebcomRequired
	private BooleanDataType esActivoPrincipal;
	@WebcomRequired
	private DoubleDataType lat;
	@WebcomRequired
	private DoubleDataType lng;
	@WebcomRequired
	private StringDataType nombreGestorComercial;
	@WebcomRequired
	private StringDataType emailGestorComercial;
	@WebcomRequired
	private StringDataType nombreGestorPublicaciones;
	@WebcomRequired
	private StringDataType emailGestorPublicaciones;
	@WebcomRequired
	private StringDataType codEstadoFisico;
	@WebcomRequired
	private BooleanDataType publicado;//falta
	@WebcomRequired
	private StringDataType codDetallePublicacion;
	@WebcomRequired
	private DateDataType envioLlavesAApi;
	@WebcomRequired
	private DateDataType fechaPosesion;
	@WebcomRequired
	private StringDataType codEstadoComercial;
	@WebcomRequired
	private StringDataType codEstadoOcupacional;
	@WebcomRequired
	private StringDataType codCee;
	@WebcomRequired
	private DoubleDataType construidaSuperficie;
	@WebcomRequired
	private DoubleDataType registralSuperficie;
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
	private StringDataType licenciaApertura;
	@WebcomRequired
	private DateDataType fechaRecepcionInforme;//falta
	@WebcomRequired
	private DateDataType ultimaModificacionInforme;
	@WebcomRequired
	private StringDataType ultimaModificacionInformePor;
	@WebcomRequired
	private DateDataType primerEnvioInformeCompletado;//falta
	@WebcomRequired
	private StringDataType primerEnvioInformeCompletadoPor;//falta
	
	
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
	public StringDataType getCodEstadoInforme() {
		return codEstadoInforme;
	}
	public void setCodEstadoInforme(StringDataType codEstadoInforme) {
		this.codEstadoInforme = codEstadoInforme;
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
	public StringDataType getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(StringDataType referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	public StringDataType getCodEstadoPublicacion() {
		return codEstadoPublicacion;
	}
	public void setCodEstadoPublicacion(StringDataType codEstadoPublicacion) {
		this.codEstadoPublicacion = codEstadoPublicacion;
	}
	public StringDataType getCodSubfasePublicacion() {
		return codSubfasePublicacion;
	}
	public void setCodSubfasePublicacion(StringDataType codSubfasePublicacion) {
		this.codSubfasePublicacion = codSubfasePublicacion;
	}
	public StringDataType getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(StringDataType fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
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
	public LongDataType getCodigoAgrupacionObraNueva() {
		return codigoAgrupacionObraNueva;
	}
	public void setCodigoAgrupacionObraNueva(LongDataType codigoAgrupacionObraNueva) {
		this.codigoAgrupacionObraNueva = codigoAgrupacionObraNueva;
	}
	public LongDataType getIdLoteRem() {
		return idLoteRem;
	}
	public void setIdLoteRem(LongDataType idLoteRem) {
		this.idLoteRem = idLoteRem;
	}
	public BooleanDataType getEsActivoPrincipal() {
		return esActivoPrincipal;
	}
	public void setEsActivoPrincipal(BooleanDataType esActivoPrincipal) {
		this.esActivoPrincipal = esActivoPrincipal;
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
	public StringDataType getNombreGestorComercial() {
		return nombreGestorComercial;
	}
	public void setNombreGestorComercial(StringDataType nombreGestorComercial) {
		this.nombreGestorComercial = nombreGestorComercial;
	}
	public StringDataType getEmailGestorComercial() {
		return emailGestorComercial;
	}
	public void setEmailGestorComercial(StringDataType emailGestorComercial) {
		this.emailGestorComercial = emailGestorComercial;
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
	public StringDataType getCodEstadoFisico() {
		return codEstadoFisico;
	}
	public void setCodEstadoFisico(StringDataType codEstadoFisico) {
		this.codEstadoFisico = codEstadoFisico;
	}
	public BooleanDataType getPublicado() {
		return publicado;
	}
	public void setPublicado(BooleanDataType publicado) {
		this.publicado = publicado;
	}
	public StringDataType getCodDetallePublicacion() {
		return codDetallePublicacion;
	}
	public void setCodDetallePublicacion(StringDataType codDetallePublicacion) {
		this.codDetallePublicacion = codDetallePublicacion;
	}
	public DateDataType getEnvioLlavesAApi() {
		return envioLlavesAApi;
	}
	public void setEnvioLlavesAApi(DateDataType envioLlavesAApi) {
		this.envioLlavesAApi = envioLlavesAApi;
	}
	public DateDataType getFechaPosesion() {
		return fechaPosesion;
	}
	public void setFechaPosesion(DateDataType fechaPosesion) {
		this.fechaPosesion = fechaPosesion;
	}
	public StringDataType getCodEstadoComercial() {
		return codEstadoComercial;
	}
	public void setCodEstadoComercial(StringDataType codEstadoComercial) {
		this.codEstadoComercial = codEstadoComercial;
	}
	public StringDataType getCodEstadoOcupacional() {
		return codEstadoOcupacional;
	}
	public void setCodEstadoOcupacional(StringDataType codEstadoOcupacional) {
		this.codEstadoOcupacional = codEstadoOcupacional;
	}
	public StringDataType getCodCee() {
		return codCee;
	}
	public void setCodCee(StringDataType codCee) {
		this.codCee = codCee;
	}
	public DoubleDataType getConstruidaSuperficie() {
		return construidaSuperficie;
	}
	public void setConstruidaSuperficie(DoubleDataType construidaSuperficie) {
		this.construidaSuperficie = construidaSuperficie;
	}
	public DoubleDataType getRegistralSuperficie() {
		return registralSuperficie;
	}
	public void setRegistralSuperficie(DoubleDataType registralSuperficie) {
		this.registralSuperficie = registralSuperficie;
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
	public DoubleDataType getUtilSuperficie() {
		return utilSuperficie;
	}
	public void setUtilSuperficie(DoubleDataType utilSuperficie) {
		this.utilSuperficie = utilSuperficie;
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
	public StringDataType getLicenciaApertura() {
		return licenciaApertura;
	}
	public void setLicenciaApertura(StringDataType licenciaApertura) {
		this.licenciaApertura = licenciaApertura;
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
	public DateDataType getPrimerEnvioInformeCompletado() {
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
	}	
}
