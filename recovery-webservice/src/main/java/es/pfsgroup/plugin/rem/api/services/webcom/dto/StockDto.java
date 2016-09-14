package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.FloatDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;

public class StockDto {
	
	private LongDataType idActivoHaya;
	private StringDataType codTipoVia;
	private StringDataType nombreCalle;
	private StringDataType numeroCalle;
	private StringDataType escalera;
	private StringDataType planta;
	private StringDataType puerta;
	private LongDataType idMunicipio;
	private LongDataType idPedania;
	private LongDataType idProvincia;
	private StringDataType codigoPostal;
	private FloatDataType actualImporte;
	private FloatDataType anteriorImporte;
	private DateDataType desdeImporte;
	private DateDataType hastaImporte;
	private LongDataType idTipoInmueble;
	private LongDataType idSubtipoInmueble;
	private StringDataType fincaRegistral;
	private LongDataType idMunicipioRegistro;
	private StringDataType registro;
	private StringDataType referenciaCatastral;
	private FloatDataType superficie;
	private FloatDataType superficieRegistral;
	private BooleanDataType ascensor;
	private LongDataType dormitorios;
	private LongDataType banyos;
	private LongDataType aseos;
	private LongDataType garajes;
	private LongDataType idEstadoComercial;
	private LongDataType idTipoVenta;
	private FloatDataType lat;
	private FloatDataType lng;
	private LongDataType idEstadoConstruccion;
	private LongDataType terrazas;
	private LongDataType idEstadoPublicacion;
	private DateDataType publicadoDesde;
	private BooleanDataType reformas;
	private LongDataType idRegimenProteccion;
	private StringDataType descripcion;
	private StringDataType distribucion;
	private StringDataType condicionesEspecificas;
	private LongDataType idDetallePublicacion;
	private StringDataType codigoAgrupacionObraNueva;
	private StringDataType codigoCabeceraObraNueva;
	private LongDataType idProveedorRemAnterior;
	private LongDataType idProveedorRemActual;
	private StringDataType nombreGestorComercial;
	private StringDataType telefonoGestorComercial;
	private StringDataType emailGestorComercial;
	private StringDataType codCee;
	private DateDataType antiguedad;
	private LongDataType idCartera;
	private StringDataType codRatio;
	private BooleanDataType idEstado;
	
	
	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
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
	public LongDataType getIdMunicipio() {
		return idMunicipio;
	}
	public void setIdMunicipio(LongDataType idMunicipio) {
		this.idMunicipio = idMunicipio;
	}
	public LongDataType getIdPedania() {
		return idPedania;
	}
	public void setIdPedania(LongDataType idPedania) {
		this.idPedania = idPedania;
	}
	public LongDataType getIdProvincia() {
		return idProvincia;
	}
	public void setIdProvincia(LongDataType idProvincia) {
		this.idProvincia = idProvincia;
	}
	public StringDataType getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(StringDataType codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public FloatDataType getActualImporte() {
		return actualImporte;
	}
	public void setActualImporte(FloatDataType actualImporte) {
		this.actualImporte = actualImporte;
	}
	public FloatDataType getAnteriorImporte() {
		return anteriorImporte;
	}
	public void setAnteriorImporte(FloatDataType anteriorImporte) {
		this.anteriorImporte = anteriorImporte;
	}
	public DateDataType getDesdeImporte() {
		return desdeImporte;
	}
	public void setDesdeImporte(DateDataType desdeImporte) {
		this.desdeImporte = desdeImporte;
	}
	public DateDataType getHastaImporte() {
		return hastaImporte;
	}
	public void setHastaImporte(DateDataType hastaImporte) {
		this.hastaImporte = hastaImporte;
	}
	public LongDataType getIdTipoInmueble() {
		return idTipoInmueble;
	}
	public void setIdTipoInmueble(LongDataType idTipoInmueble) {
		this.idTipoInmueble = idTipoInmueble;
	}
	public LongDataType getIdSubtipoInmueble() {
		return idSubtipoInmueble;
	}
	public void setIdSubtipoInmueble(LongDataType idSubtipoInmueble) {
		this.idSubtipoInmueble = idSubtipoInmueble;
	}
	public StringDataType getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(StringDataType fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	public LongDataType getIdMunicipioRegistro() {
		return idMunicipioRegistro;
	}
	public void setIdMunicipioRegistro(LongDataType idMunicipioRegistro) {
		this.idMunicipioRegistro = idMunicipioRegistro;
	}
	public StringDataType getRegistro() {
		return registro;
	}
	public void setRegistro(StringDataType registro) {
		this.registro = registro;
	}
	public StringDataType getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(StringDataType referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	public FloatDataType getSuperficie() {
		return superficie;
	}
	public void setSuperficie(FloatDataType superficie) {
		this.superficie = superficie;
	}
	public FloatDataType getSuperficieRegistral() {
		return superficieRegistral;
	}
	public void setSuperficieRegistral(FloatDataType superficieRegistral) {
		this.superficieRegistral = superficieRegistral;
	}
	public BooleanDataType getAscensor() {
		return ascensor;
	}
	public void setAscensor(BooleanDataType ascensor) {
		this.ascensor = ascensor;
	}
	public LongDataType getDormitorios() {
		return dormitorios;
	}
	public void setDormitorios(LongDataType dormitorios) {
		this.dormitorios = dormitorios;
	}
	public LongDataType getBanyos() {
		return banyos;
	}
	public void setBanyos(LongDataType banyos) {
		this.banyos = banyos;
	}
	public LongDataType getAseos() {
		return aseos;
	}
	public void setAseos(LongDataType aseos) {
		this.aseos = aseos;
	}
	public LongDataType getGarajes() {
		return garajes;
	}
	public void setGarajes(LongDataType garajes) {
		this.garajes = garajes;
	}
	public LongDataType getIdEstadoComercial() {
		return idEstadoComercial;
	}
	public void setIdEstadoComercial(LongDataType idEstadoComercial) {
		this.idEstadoComercial = idEstadoComercial;
	}
	public LongDataType getIdTipoVenta() {
		return idTipoVenta;
	}
	public void setIdTipoVenta(LongDataType idTipoVenta) {
		this.idTipoVenta = idTipoVenta;
	}
	public FloatDataType getLat() {
		return lat;
	}
	public void setLat(FloatDataType lat) {
		this.lat = lat;
	}
	public FloatDataType getLng() {
		return lng;
	}
	public void setLng(FloatDataType lng) {
		this.lng = lng;
	}
	public LongDataType getIdEstadoConstruccion() {
		return idEstadoConstruccion;
	}
	public void setIdEstadoConstruccion(LongDataType idEstadoConstruccion) {
		this.idEstadoConstruccion = idEstadoConstruccion;
	}
	public LongDataType getTerrazas() {
		return terrazas;
	}
	public void setTerrazas(LongDataType terrazas) {
		this.terrazas = terrazas;
	}
	public LongDataType getIdEstadoPublicacion() {
		return idEstadoPublicacion;
	}
	public void setIdEstadoPublicacion(LongDataType idEstadoPublicacion) {
		this.idEstadoPublicacion = idEstadoPublicacion;
	}
	public DateDataType getPublicadoDesde() {
		return publicadoDesde;
	}
	public void setPublicadoDesde(DateDataType publicadoDesde) {
		this.publicadoDesde = publicadoDesde;
	}
	public BooleanDataType getReformas() {
		return reformas;
	}
	public void setReformas(BooleanDataType reformas) {
		this.reformas = reformas;
	}
	public LongDataType getIdRegimenProteccion() {
		return idRegimenProteccion;
	}
	public void setIdRegimenProteccion(LongDataType idRegimenProteccion) {
		this.idRegimenProteccion = idRegimenProteccion;
	}
	public StringDataType getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(StringDataType descripcion) {
		this.descripcion = descripcion;
	}
	public StringDataType getDistribucion() {
		return distribucion;
	}
	public void setDistribucion(StringDataType distribucion) {
		this.distribucion = distribucion;
	}
	public StringDataType getCondicionesEspecificas() {
		return condicionesEspecificas;
	}
	public void setCondicionesEspecificas(StringDataType condicionesEspecificas) {
		this.condicionesEspecificas = condicionesEspecificas;
	}
	public LongDataType getIdDetallePublicacion() {
		return idDetallePublicacion;
	}
	public void setIdDetallePublicacion(LongDataType idDetallePublicacion) {
		this.idDetallePublicacion = idDetallePublicacion;
	}
	public StringDataType getCodigoAgrupacionObraNueva() {
		return codigoAgrupacionObraNueva;
	}
	public void setCodigoAgrupacionObraNueva(StringDataType codigoAgrupacionObraNueva) {
		this.codigoAgrupacionObraNueva = codigoAgrupacionObraNueva;
	}
	public StringDataType getCodigoCabeceraObraNueva() {
		return codigoCabeceraObraNueva;
	}
	public void setCodigoCabeceraObraNueva(StringDataType codigoCabeceraObraNueva) {
		this.codigoCabeceraObraNueva = codigoCabeceraObraNueva;
	}
	public LongDataType getIdProveedorRemAnterior() {
		return idProveedorRemAnterior;
	}
	public void setIdProveedorRemAnterior(LongDataType idProveedorRemAnterior) {
		this.idProveedorRemAnterior = idProveedorRemAnterior;
	}
	public StringDataType getNombreGestorComercial() {
		return nombreGestorComercial;
	}
	public void setNombreGestorComercial(StringDataType nombreGestorComercial) {
		this.nombreGestorComercial = nombreGestorComercial;
	}
	public StringDataType getTelefonoGestorComercial() {
		return telefonoGestorComercial;
	}
	public void setTelefonoGestorComercial(StringDataType telefonoGestorComercial) {
		this.telefonoGestorComercial = telefonoGestorComercial;
	}
	public StringDataType getEmailGestorComercial() {
		return emailGestorComercial;
	}
	public void setEmailGestorComercial(StringDataType emailGestorComercial) {
		this.emailGestorComercial = emailGestorComercial;
	}
	public StringDataType getCodCee() {
		return codCee;
	}
	public void setCodCee(StringDataType codCee) {
		this.codCee = codCee;
	}
	public DateDataType getAntiguedad() {
		return antiguedad;
	}
	public void setAntiguedad(DateDataType antiguedad) {
		this.antiguedad = antiguedad;
	}
	public LongDataType getIdCartera() {
		return idCartera;
	}
	public void setIdCartera(LongDataType idCartera) {
		this.idCartera = idCartera;
	}
	public StringDataType getCodRatio() {
		return codRatio;
	}
	public void setCodRatio(StringDataType codRatio) {
		this.codRatio = codRatio;
	}
	public LongDataType getIdProveedorRemActual() {
		return idProveedorRemActual;
	}
	public void setIdProveedorRemActual(LongDataType idProveedorRemActual) {
		this.idProveedorRemActual = idProveedorRemActual;
	}
	public BooleanDataType getIdEstado() {
		return idEstado;
	}
	public void setIdEstado(BooleanDataType idEstado) {
		this.idEstado = idEstado;
	}
		
}
