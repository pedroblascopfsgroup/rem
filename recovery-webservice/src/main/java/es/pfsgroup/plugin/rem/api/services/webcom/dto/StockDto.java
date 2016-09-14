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
	private StringDataType codMunicipio;
	private StringDataType codPedania;
	private StringDataType codProvincia;
	private StringDataType codigoPostal;
	private FloatDataType actualImporte;
	private FloatDataType anteriorImporte;
	private DateDataType desdeImporte;
	private DateDataType hastaImporte;
	private StringDataType codTipoInmueble;
	private StringDataType codSubtipoInmueble;
	private StringDataType fincaRegistral;
	private StringDataType codMunicipioRegistro;
	private StringDataType registro;
	private StringDataType referenciaCatastral;
	private FloatDataType superficie;
	private FloatDataType superficieRegistral;
	private BooleanDataType ascensor;
	private LongDataType dormitorios;
	private LongDataType banyos;
	private LongDataType aseos;
	private LongDataType garajes;
	private BooleanDataType publicado;
	private StringDataType codEstadoComercial;
	private StringDataType codTipoVenta;
	private FloatDataType lat;
	private FloatDataType lng;
	private StringDataType codEstadoConstruccion;
	private LongDataType terrazas;
	private StringDataType codEstadoPublicacion;
	private DateDataType publicadoDesde;
	private BooleanDataType reformas;
	private StringDataType codRegimenProteccion;
	private StringDataType descripcion;
	private StringDataType distribucion;
	private StringDataType condicionesEspecificas;
	private StringDataType codDetallePublicacion;
	private StringDataType codigoAgrupacionObraNueva;
	private StringDataType codigoCabeceraObraNueva;
	private LongDataType idProveedorRemAnterior;
	private LongDataType idProveedorRem;
	private StringDataType nombreGestorComercial;
	private StringDataType telefonoGestorComercial;
	private StringDataType emailGestorComercial;
	private StringDataType codCee;
	private DateDataType antiguedad;
	private StringDataType codCartera;
	private StringDataType codRatio;
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
	public StringDataType getCodMunicipio() {
		return codMunicipio;
	}
	public void setCodMunicipio(StringDataType codMunicipio) {
		this.codMunicipio = codMunicipio;
	}
	public StringDataType getCodPedania() {
		return codPedania;
	}
	public void setCodPedania(StringDataType codPedania) {
		this.codPedania = codPedania;
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
	public StringDataType getCodTipoInmueble() {
		return codTipoInmueble;
	}
	public void setCodTipoInmueble(StringDataType codTipoInmueble) {
		this.codTipoInmueble = codTipoInmueble;
	}
	public StringDataType getCodSubtipoInmueble() {
		return codSubtipoInmueble;
	}
	public void setCodSubtipoInmueble(StringDataType codSubtipoInmueble) {
		this.codSubtipoInmueble = codSubtipoInmueble;
	}
	public StringDataType getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(StringDataType fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	public StringDataType getCodMunicipioRegistro() {
		return codMunicipioRegistro;
	}
	public void setCodMunicipioRegistro(StringDataType codMunicipioRegistro) {
		this.codMunicipioRegistro = codMunicipioRegistro;
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
	public BooleanDataType getPublicado() {
		return publicado;
	}
	public void setPublicado(BooleanDataType publicado) {
		this.publicado = publicado;
	}
	public StringDataType getCodEstadoComercial() {
		return codEstadoComercial;
	}
	public void setCodEstadoComercial(StringDataType codEstadoComercial) {
		this.codEstadoComercial = codEstadoComercial;
	}
	public StringDataType getCodTipoVenta() {
		return codTipoVenta;
	}
	public void setCodTipoVenta(StringDataType codTipoVenta) {
		this.codTipoVenta = codTipoVenta;
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
	public StringDataType getCodEstadoConstruccion() {
		return codEstadoConstruccion;
	}
	public void setCodEstadoConstruccion(StringDataType codEstadoConstruccion) {
		this.codEstadoConstruccion = codEstadoConstruccion;
	}
	public LongDataType getTerrazas() {
		return terrazas;
	}
	public void setTerrazas(LongDataType terrazas) {
		this.terrazas = terrazas;
	}
	public StringDataType getCodEstadoPublicacion() {
		return codEstadoPublicacion;
	}
	public void setCodEstadoPublicacion(StringDataType codEstadoPublicacion) {
		this.codEstadoPublicacion = codEstadoPublicacion;
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
	public StringDataType getCodRegimenProteccion() {
		return codRegimenProteccion;
	}
	public void setCodRegimenProteccion(StringDataType codRegimenProteccion) {
		this.codRegimenProteccion = codRegimenProteccion;
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
	public StringDataType getCodDetallePublicacion() {
		return codDetallePublicacion;
	}
	public void setCodDetallePublicacion(StringDataType codDetallePublicacion) {
		this.codDetallePublicacion = codDetallePublicacion;
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
	public LongDataType getIdProveedorRem() {
		return idProveedorRem;
	}
	public void setIdProveedorRem(LongDataType idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
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
	public StringDataType getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(StringDataType codCartera) {
		this.codCartera = codCartera;
	}
	public StringDataType getCodRatio() {
		return codRatio;
	}
	public void setCodRatio(StringDataType codRatio) {
		this.codRatio = codRatio;
	}
			
}
