package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class StockDto implements WebcomRESTDto{
	@WebcomRequired //No se puede quitar
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired //No se puede quitar
	private DateDataType fechaAccion;
	
	@WebcomRequired
	private LongDataType idActivoHaya;
	
	private LongDataType idActivoSareb;
	
	private LongDataType idActivoPrinex;
	
	@WebcomRequired
	private LongDataType idActivoRem;
	
	private StringDataType idActivoBc;
	
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
	
	private StringDataType codTipoInmueble;
	
	private StringDataType codSubtipoInmueble;
	
	private StringDataType fincaRegistral;
	
	private StringDataType codMunicipioRegistro;
	
	private StringDataType registro;
	
	private StringDataType referenciaCatastral;
	
	private BooleanDataType ascensor;
	
	private LongDataType dormitorios;
	
	private LongDataType banyos;
	
	private LongDataType aseos;
	
	private LongDataType garajes;
	
	@WebcomRequired
	private StringDataType codEstadoComercial;
	
	private StringDataType codTipoVenta;
	
	@DecimalDataTypeFormat(decimals=8)
	private DoubleDataType lat;
	
	@DecimalDataTypeFormat(decimals=8)
	private DoubleDataType lng;
	
	private StringDataType codEstadoConstruccion;
	
	private LongDataType terrazas;
	
	@WebcomRequired
	private StringDataType codEstadoPublicacion;
	
	private DateDataType publicadoDesde;
	
	private BooleanDataType reformas;
	
	private StringDataType codRegimenProteccion;
	
	@WebcomRequired
	private StringDataType distribucion;
	
	@WebcomRequired
	private StringDataType codDetallePublicacion;
	
	@WebcomRequired
	private LongDataType codigoAgrupacionObraNueva;
	
	@WebcomRequired
	private LongDataType codigoCabeceraObraNueva;
	
	private LongDataType idProveedorRemAnterior;
	
	@WebcomRequired
	private LongDataType idProveedorRem;
	
	private StringDataType nombreGestorComercial;
	
	private StringDataType telefonoGestorComercial;
	
	private StringDataType emailGestorComercial;
	
	private StringDataType codCee;
	
	private LongDataType antiguedad;
	
	private StringDataType codCartera;
	
	private StringDataType codRatio;
	
	private BooleanDataType esNuevo;
	
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType utilSuperficie;
	
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType construidaSuperficie;
	
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType registralSuperficie;
	
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType parcelaSuperficie;
	
	private LongDataType idActivoUvem;
	
	@WebcomRequired
	private BooleanDataType riesgoOcupacion;
	
	private DateDataType fechaPosesion;
	
	@MappedColumn("FECHA_CONTRATO_DATOS_OCU")
	private DateDataType fechaContratoDatosOcupacionales;
	
	@MappedColumn("PLAZO_CONTRATO_DATOS_OCU")
	private DateDataType plazoContratoDatosOcupacionales;
	
	@MappedColumn("RENTA_MENSUAL_DATOS_OCU")
	private DoubleDataType rentaMensualDatosOcupacionales;
	
	@MappedColumn("RECIBIDO_IMPORTE_DATOS_ADM")
	private DoubleDataType recibidoImporteDatosAdministracion;
	
	@MappedColumn("IBI_IMPORTE_DATOS_ADM")
	private DoubleDataType ibiImporteDatosAdministracion;
	
	@MappedColumn("DERRAMA_IMPORTE_DATOS_ADM")
	private DoubleDataType derramaImporteDatosAdministracion;
	
	@MappedColumn("DETALLE_DERRAMA_DATOS_ADM")
	private StringDataType detalleDerramaDatosAdministracion;
	
	private StringDataType anejoTrastero;
	
	private BooleanDataType existePiscina;
	
	//HREOS-1479
	@WebcomRequired
	private LongDataType codigoAgrupacionRestringidaVenta;
	@WebcomRequired
	private BooleanDataType esActivoPrincipalRestringidaVenta;
	
	@WebcomRequired
	private LongDataType codigoAgrupacionRestringidaAlquiler;
	@WebcomRequired
	private BooleanDataType esActivoPrincipalRestringidaAlquiler;
	
	@WebcomRequired
	private LongDataType codigoAgrupacionRestringidaObRem;
	@WebcomRequired
	private BooleanDataType esActivoPrincipalRestringidaObRem;
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType actualImporteDescuentoWeb;
	
	@WebcomRequired
	private DateDataType desdeImporteDescuentoWeb;
	
	@WebcomRequired
	private DateDataType hastaImporteDescuentoWeb;
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType valorAprobadoRenta;
	
	@WebcomRequired
	private DateDataType fechaValorAprobadoRenta;	
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType anteriorValorAprobadoRenta;
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType valorAprobadoVenta;
	
	@WebcomRequired
	private DateDataType fechaValorAprobadoVenta;
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType anteriorValorAprobadoVenta;
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType minimoAutorizado;
	
	private LongDataType idAsistida;
	
	private LongDataType codigoCabeceraAsistida;
	
	private StringDataType codSubtipoTitulo;
	
	private StringDataType codSubCartera;
	
	@WebcomRequired
	private StringDataType condicionesEspecificas;
	
	@WebcomRequired
	private StringDataType descripcion;
	
	@WebcomRequired
	@MappedColumn("cod_estado_pub_alquiler")
	private StringDataType codEstadoPublicacionAlquiler;
	
	@WebcomRequired
	@MappedColumn("cod_subestado_pub_venta")
	private StringDataType codSubEstadoPublicacionVenta;
    
	@WebcomRequired
	@MappedColumn("cod_subestado_pub_alquiler")
	private StringDataType codSubEstadoPublicacionAlquiler;

	@WebcomRequired
	private BooleanDataType indOcultarPrecioVenta;
	
	@WebcomRequired
	private BooleanDataType indOcultarPrecioAlquiler;
    
	@WebcomRequired
	private StringDataType arrCodDetallePublicacion;
	

	@WebcomRequired
	private LongDataType codigoAgrupacionComercialRem;
	
	private StringDataType descripcionOtros;

	private LongDataType activoProveedorTecnico;

	private StringDataType codEstadoFisico;

	private StringDataType codTipoUsoDestino;
	
	//HREOS-6082
	private BooleanDataType esActivoMatrizPa;
	
	private LongDataType idActivoHayaPa;
	
	private LongDataType codigoAgrupacionPa;
	
	private LongDataType codigoCabeceraPa;
	
	private StringDataType nombreGmo;
	
	private StringDataType telefonoGmo;
	
	private StringDataType emailGmo;

	private StringDataType codTipoAlquiler;

	@WebcomRequired
	private String codFasePublicacion;
	
	@WebcomRequired
	private String codSubfasePublicacion;
	
	@NestedDto(groupBy="idActivoHaya", type=PoseedorLlavesDto.class)
	private List<PoseedorLlavesDto> arrProveedorLlavesRem;
	
	@WebcomRequired
	private LongDataType idProveedorEspejoRem;

	@WebcomRequired
	private BooleanDataType perimetroMacc;
	
	private StringDataType scomEmail;
	
	private StringDataType scomNombre;
	
	private StringDataType scomTelefono;
	
	@WebcomRequired
	private StringDataType codTipoComercializar;
	
	private StringDataType codEquipoGestion;

	@WebcomRequired
	private BooleanDataType checkGestionComercial;
	
	@WebcomRequired
	private BooleanDataType excluirValidaciones;
	
	@WebcomRequired
	private DateDataType fechaGestionComercial;
	
	@WebcomRequired
	private StringDataType motivoGestionComercial;

    @WebcomRequired
    private BooleanDataType spsAlarma;

	@WebcomRequired
	private DateDataType spsFechaInstalaAlarma;
	
	@WebcomRequired
	private DateDataType spsFechaDesinstalaAlarma;
	
	@WebcomRequired
	private BooleanDataType spsVigilancia;
	
	@WebcomRequired
	private DateDataType spsFechaInstalaVigilancia;
	
	@WebcomRequired
	private DateDataType spsFechaDesinstalaVigilancia;
	
	@WebcomRequired
	private BooleanDataType onvComercializacion;
	
	@WebcomRequired
	private StringDataType onvComercializacionFecha;
	

	private BooleanDataType necesidadIf;

	@WebcomRequired
	private StringDataType codDirComercial;

	
	@WebcomRequired
	private DoubleDataType importeCampanyaAlquiler;
	
	@WebcomRequired
	private DateDataType fechaInicioCampanyaAlquiler;
	
	@WebcomRequired
	private DateDataType fechaFinCampanyaAlquiler;
	
	private StringDataType codigoPortalPublicacion;
	
	private StringDataType codigoCanalDistVenta;
	
	private StringDataType codigoCanalDistAlquiler;
	
	@WebcomRequired
	private DoubleDataType testigoOblPorcentajeDesc;
	
	@WebcomRequired
	private DoubleDataType testigoOblImporteMin;
	
	@WebcomRequired
	private BooleanDataType requiereTestigo;
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	@MappedColumn("RECOMENDACION_PORCENTAJE_DESC")
	private DoubleDataType recomendacionPorcenDescuentoVenta;
	
	@WebcomRequired
	@DecimalDataTypeFormat(decimals=2)
	@MappedColumn("RECOMENDACION_IMPORTE_MIN")
	private DoubleDataType recomendacionPrecioMinimoVenta;
	
	@WebcomRequired
	@MappedColumn("RECOMENDACION_REQUERIDA")
	private StringDataType recomendacionInternaRequerida;
	
	@WebcomRequired
	private StringDataType proDocidentif;
	
	@WebcomRequired
	private StringDataType proNombre; 
	
	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public LongDataType getIdActivoSareb() {
		return idActivoSareb;
	}
	public void setIdActivoSareb(LongDataType idActivoSareb) {
		this.idActivoSareb = idActivoSareb;
	}
	public LongDataType getIdActivoPrinex() {
		return idActivoPrinex;
	}
	public void setIdActivoPrinex(LongDataType idActivoPrinex) {
		this.idActivoPrinex = idActivoPrinex;
	}
	public LongDataType getIdActivoRem() {
		return idActivoRem;
	}
	public void setIdActivoRem(LongDataType idActivoRem) {
		this.idActivoRem = idActivoRem;
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
	public LongDataType getCodigoAgrupacionObraNueva() {
		return codigoAgrupacionObraNueva;
	}
	public void setCodigoAgrupacionObraNueva(LongDataType codigoAgrupacionObraNueva) {
		this.codigoAgrupacionObraNueva = codigoAgrupacionObraNueva;
	}
	public LongDataType getCodigoCabeceraObraNueva() {
		return codigoCabeceraObraNueva;
	}
	public void setCodigoCabeceraObraNueva(LongDataType codigoCabeceraObraNueva) {
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
	public LongDataType getAntiguedad() {
		return antiguedad;
	}
	public void setAntiguedad(LongDataType antiguedad) {
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
	public BooleanDataType getEsNuevo() {
		return esNuevo;
	}
	public void setEsNuevo(BooleanDataType esNuevo) {
		this.esNuevo = esNuevo;
	}
	public DoubleDataType getUtilSuperficie() {
		return utilSuperficie;
	}
	public void setUtilSuperficie(DoubleDataType utilSuperficie) {
		this.utilSuperficie = utilSuperficie;
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
	public DoubleDataType getParcelaSuperficie() {
		return parcelaSuperficie;
	}
	public void setParcelaSuperficie(DoubleDataType parcelaSuperficie) {
		this.parcelaSuperficie = parcelaSuperficie;
	}
	public LongDataType getIdActivoUvem() {
		return idActivoUvem;
	}
	public void setIdActivoUvem(LongDataType idActivoUvem) {
		this.idActivoUvem = idActivoUvem;
	}
	public DoubleDataType getValorAprobadoVenta() {
		return valorAprobadoVenta;
	}
	public void setValorAprobadoVenta(DoubleDataType valorAprobadoVenta) {
		this.valorAprobadoVenta = valorAprobadoVenta;
	}
	public DateDataType getFechaValorAprobadoVenta() {
		return fechaValorAprobadoVenta;
	}
	public void setFechaValorAprobadoVenta(DateDataType fechaValorAprobadoVenta) {
		this.fechaValorAprobadoVenta = fechaValorAprobadoVenta;
	}
	public DoubleDataType getValorAprobadoRenta() {
		return valorAprobadoRenta;
	}
	public void setValorAprobadoRenta(DoubleDataType valorAprobadoRenta) {
		this.valorAprobadoRenta = valorAprobadoRenta;
	}
	public DateDataType getFechaValorAprobadoRenta() {
		return fechaValorAprobadoRenta;
	}
	public void setFechaValorAprobadoRenta(DateDataType fechaValorAprobadoRenta) {
		this.fechaValorAprobadoRenta = fechaValorAprobadoRenta;
	}
	public BooleanDataType getRiesgoOcupacion() {
		return riesgoOcupacion;
	}
	public void setRiesgoOcupacion(BooleanDataType riesgoOcupacion) {
		this.riesgoOcupacion = riesgoOcupacion;
	}
	public DateDataType getFechaPosesion() {
		return fechaPosesion;
	}
	public void setFechaPosesion(DateDataType fechaPosesion) {
		this.fechaPosesion = fechaPosesion;
	}
	public DateDataType getFechaContratoDatosOcupacionales() {
		return fechaContratoDatosOcupacionales;
	}
	public void setFechaContratoDatosOcupacionales(
			DateDataType fechaContratoDatosOcupacionales) {
		this.fechaContratoDatosOcupacionales = fechaContratoDatosOcupacionales;
	}
	public DateDataType getPlazoContratoDatosOcupacionales() {
		return plazoContratoDatosOcupacionales;
	}
	public void setPlazoContratoDatosOcupacionales(
			DateDataType plazoContratoDatosOcupacionales) {
		this.plazoContratoDatosOcupacionales = plazoContratoDatosOcupacionales;
	}
	public DoubleDataType getRentaMensualDatosOcupacionales() {
		return rentaMensualDatosOcupacionales;
	}
	public void setRentaMensualDatosOcupacionales(
			DoubleDataType rentaMensualDatosOcupacionales) {
		this.rentaMensualDatosOcupacionales = rentaMensualDatosOcupacionales;
	}
	public DoubleDataType getRecibidoImporteDatosAdministracion() {
		return recibidoImporteDatosAdministracion;
	}
	public void setRecibidoImporteDatosAdministracion(
			DoubleDataType recibidoImporteDatosAdministracion) {
		this.recibidoImporteDatosAdministracion = recibidoImporteDatosAdministracion;
	}
	public DoubleDataType getIbiImporteDatosAdministracion() {
		return ibiImporteDatosAdministracion;
	}
	public void setIbiImporteDatosAdministracion(
			DoubleDataType ibiImporteDatosAdministracion) {
		this.ibiImporteDatosAdministracion = ibiImporteDatosAdministracion;
	}
	public DoubleDataType getDerramaImporteDatosAdministracion() {
		return derramaImporteDatosAdministracion;
	}
	public void setDerramaImporteDatosAdministracion(
			DoubleDataType derramaImporteDatosAdministracion) {
		this.derramaImporteDatosAdministracion = derramaImporteDatosAdministracion;
	}
	public StringDataType getDetalleDerramaDatosAdministracion() {
		return detalleDerramaDatosAdministracion;
	}
	public void setDetalleDerramaDatosAdministracion(
			StringDataType detalleDerramaDatosAdministracion) {
		this.detalleDerramaDatosAdministracion = detalleDerramaDatosAdministracion;
	}
	public StringDataType getAnejoTrastero() {
		return anejoTrastero;
	}
	public void setAnejoTrastero(StringDataType anejoTrastero) {
		this.anejoTrastero = anejoTrastero;
	}
	public BooleanDataType getExistePiscina() {
		return existePiscina;
	}
	public void setExistePiscina(BooleanDataType existePiscina) {
		this.existePiscina = existePiscina;
	}
	public DoubleDataType getActualImporteDescuentoWeb() {
		return actualImporteDescuentoWeb;
	}
	public void setActualImporteDescuentoWeb(
			DoubleDataType actualImporteDescuentoWeb) {
		this.actualImporteDescuentoWeb = actualImporteDescuentoWeb;
	}
	public DateDataType getDesdeImporteDescuentoWeb() {
		return desdeImporteDescuentoWeb;
	}
	public void setDesdeImporteDescuentoWeb(DateDataType desdeImporteDescuentoWeb) {
		this.desdeImporteDescuentoWeb = desdeImporteDescuentoWeb;
	}
	public DateDataType getHastaImporteDescuentoWeb() {
		return hastaImporteDescuentoWeb;
	}
	public void setHastaImporteDescuentoWeb(DateDataType hastaImporteDescuentoWeb) {
		this.hastaImporteDescuentoWeb = hastaImporteDescuentoWeb;
	}
	public DoubleDataType getAnteriorValorAprobadoRenta() {
		return anteriorValorAprobadoRenta;
	}
	public void setAnteriorValorAprobadoRenta(
			DoubleDataType anteriorValorAprobadoRenta) {
		this.anteriorValorAprobadoRenta = anteriorValorAprobadoRenta;
	}
	public DoubleDataType getAnteriorValorAprobadoVenta() {
		return anteriorValorAprobadoVenta;
	}
	public void setAnteriorValorAprobadoVenta(
			DoubleDataType anteriorValorAprobadoVenta) {
		this.anteriorValorAprobadoVenta = anteriorValorAprobadoVenta;
	}
	public DoubleDataType getMinimoAutorizado() {
		return minimoAutorizado;
	}
	public void setMinimoAutorizado(DoubleDataType minimoAutorizado) {
		this.minimoAutorizado = minimoAutorizado;
	}
	public LongDataType getIdAsistida() {
		return idAsistida;
	}
	public void setIdAsistida(LongDataType idAsistida) {
		this.idAsistida = idAsistida;
	}
	public LongDataType getCodigoCabeceraAsistida() {
		return codigoCabeceraAsistida;
	}
	public void setCodigoCabeceraAsistida(LongDataType codigoCabeceraAsistida) {
		this.codigoCabeceraAsistida = codigoCabeceraAsistida;
	}
	public StringDataType getCodSubtipoTitulo() {
		return codSubtipoTitulo;
	}
	public void setCodSubtipoTitulo(StringDataType codSubtipoTitulo) {
		this.codSubtipoTitulo = codSubtipoTitulo;
	}
	public StringDataType getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(StringDataType codSubCartera) {
		this.codSubCartera = codSubCartera;
	}
	public StringDataType getCodEstadoPublicacionAlquiler() {
		return codEstadoPublicacionAlquiler;
	}
	public void setCodEstadoPublicacionAlquiler(
			StringDataType codEstadoPublicacionAlquiler) {
		this.codEstadoPublicacionAlquiler = codEstadoPublicacionAlquiler;
	}
	public StringDataType getCodSubEstadoPublicacionVenta() {
		return codSubEstadoPublicacionVenta;
	}
	public void setCodSubEstadoPublicacionVenta(
			StringDataType codSubEstadoPublicacionVenta) {
		this.codSubEstadoPublicacionVenta = codSubEstadoPublicacionVenta;
	}
	public StringDataType getCodSubEstadoPublicacionAlquiler() {
		return codSubEstadoPublicacionAlquiler;
	}
	public void setCodSubEstadoPublicacionAlquiler(
			StringDataType codSubEstadoPublicacionAlquiler) {
		this.codSubEstadoPublicacionAlquiler = codSubEstadoPublicacionAlquiler;
	}
	public BooleanDataType getIndOcultarPrecioVenta() {
		return indOcultarPrecioVenta;
	}
	public void setIndOcultarPrecioVenta(BooleanDataType indOcultarPrecioVenta) {
		this.indOcultarPrecioVenta = indOcultarPrecioVenta;
	}
	public BooleanDataType getIndOcultarPrecioAlquiler() {
		return indOcultarPrecioAlquiler;
	}
	public void setIndOcultarPrecioAlquiler(BooleanDataType indOcultarPrecioAlquiler) {
		this.indOcultarPrecioAlquiler = indOcultarPrecioAlquiler;
	}
	public StringDataType getArrCodDetallePublicacion() {
		return arrCodDetallePublicacion;
	}
	public void setArrCodDetallePublicacion(StringDataType arrCodDetallePublicacion) {
		this.arrCodDetallePublicacion = arrCodDetallePublicacion;
	}
	public StringDataType getDescripcionOtros() {
		return descripcionOtros;
	}
	public void setDescripcionOtros(StringDataType descripcionOtros) {
		this.descripcionOtros = descripcionOtros;
	}
	public LongDataType getActivoProveedorTecnico() {
		return activoProveedorTecnico;
	}
	public void setActivoProveedorTecnico(LongDataType activoProveedorTecnico) {
		this.activoProveedorTecnico = activoProveedorTecnico;
	}
	public StringDataType getCodEstadoFisico() {
		return codEstadoFisico;
	}
	public void setCodEstadoFisico(StringDataType codEstadoFisico) {
		this.codEstadoFisico = codEstadoFisico;
	}
	public StringDataType getCodTipoUsoDestino() {
		return codTipoUsoDestino;
	}
	public void setCodTipoUsoDestino(StringDataType codTipoUsoDestino) {
		this.codTipoUsoDestino = codTipoUsoDestino;
	}
	public StringDataType getCodTipoAlquiler() {
		return codTipoAlquiler;
	}
	public void setCodTipoAlquiler(StringDataType codTipoAlquiler) {
		this.codTipoAlquiler = codTipoAlquiler;
	}
	public LongDataType getCodigoAgrupacionComercialRem() {
		return codigoAgrupacionComercialRem;
	}
	public void setCodigoAgrupacionComercialRem(LongDataType codigoAgrupacionComercialRem) {
		this.codigoAgrupacionComercialRem = codigoAgrupacionComercialRem;
	}
	public BooleanDataType getEsActivoMatrizPa() {
		return esActivoMatrizPa;
	}
	public void setEsActivoMatrizPa(BooleanDataType esActivoMatrizPa) {
		this.esActivoMatrizPa = esActivoMatrizPa;
	}
	public LongDataType getIdActivoHayaPa() {
		return idActivoHayaPa;
	}
	public void setIdActivoHayaPa(LongDataType idActivoHayaPa) {
		this.idActivoHayaPa = idActivoHayaPa;
	}
	public LongDataType getCodigoAgrupacionPa() {
		return codigoAgrupacionPa;
	}
	public void setCodigoAgrupacionPa(LongDataType codigoAgrupacionPa) {
		this.codigoAgrupacionPa = codigoAgrupacionPa;
	}
	public LongDataType getCodigoCabeceraPa() {
		return codigoCabeceraPa;
	}
	public void setCodigoCabeceraPa(LongDataType codigoCabeceraPa) {
		this.codigoCabeceraPa = codigoCabeceraPa;
	}
	public StringDataType getNombreGmo() {
		return nombreGmo;
	}
	public void setNombreGmo(StringDataType nombreGmo) {
		this.nombreGmo = nombreGmo;
	}
	public StringDataType getTelefonoGmo() {
		return telefonoGmo;
	}
	public void setTelefonoGmo(StringDataType telefonoGmo) {
		this.telefonoGmo = telefonoGmo;
	}
	public StringDataType getEmailGmo() {
		return emailGmo;
	}
	public void setEmailGmo(StringDataType emailGmo) {
		this.emailGmo = emailGmo;
	}
	public String getCodFasePublicacion() {
		return codFasePublicacion;
	}
	public void setCodFasePublicacion(String codFasePublicacion) {
		this.codFasePublicacion = codFasePublicacion;
	}
	public String getCodSubfasePublicacion() {
		return codSubfasePublicacion;
	}
	public void setCodSubfasePublicacion(String codSubfasePublicacion) {
		this.codSubfasePublicacion = codSubfasePublicacion;
	}
	public List<PoseedorLlavesDto> getArrProveedorLlavesRem() {
		return arrProveedorLlavesRem;
	}
	public void setArrProveedorLlavesRem(List<PoseedorLlavesDto> arrProveedorLlavesRem) {
		this.arrProveedorLlavesRem = arrProveedorLlavesRem;
	}
	public LongDataType getIdProveedorEspejoRem() {
		return idProveedorEspejoRem;
	}
	public void setIdProveedorEspejoRem(LongDataType idProveedorEspejoRem) {
		this.idProveedorEspejoRem = idProveedorEspejoRem;
	}

	public BooleanDataType getPerimetroMacc() {
		return perimetroMacc;
	}
	public void setPerimetroMacc(BooleanDataType perimetroMacc) {
		this.perimetroMacc = perimetroMacc;
	}
	public StringDataType getScomEmail() {
		return scomEmail;
	}
	public void setScomEmail(StringDataType scomEmail) {
		this.scomEmail = scomEmail;
	}
	public StringDataType getScomNombre() {
		return scomNombre;
	}
	public void setScomNombre(StringDataType scomNombre) {
		this.scomNombre = scomNombre;
	}
	public StringDataType getScomTelefono() {
		return scomTelefono;
	}
	public void setScomTelefono(StringDataType scomTelefono) {
		this.scomTelefono = scomTelefono;
	}
	public StringDataType getCodTipoComercializar() {
		return codTipoComercializar;
	}
	public void setCodTipoComercializar(StringDataType codTipoComercializar) {
		this.codTipoComercializar = codTipoComercializar;
	}
	public StringDataType getCodEquipoGestion() {
		return codEquipoGestion;
	}
	public void setCodEquipoGestion(StringDataType codEquipoGestion) {
		this.codEquipoGestion = codEquipoGestion;
	}
	public BooleanDataType getCheckGestionComercial() {
		return checkGestionComercial;
	}
	public void setCheckGestionComercial(BooleanDataType checkGestionComercial) {
		this.checkGestionComercial = checkGestionComercial;
	}
	public BooleanDataType getExcluirValidaciones() {
		return excluirValidaciones;
	}
	public void setExcluirValidaciones(BooleanDataType excluirValidaciones) {
		this.excluirValidaciones = excluirValidaciones;
	}
	public DateDataType getFechaGestionComercial() {
		return fechaGestionComercial;
	}
	public void setFechaGestionComercial(DateDataType fechaGestionComercial) {
		this.fechaGestionComercial = fechaGestionComercial;
	}
	public StringDataType getMotivoGestionComercial() {
		return motivoGestionComercial;
	}
	public void setMotivoGestionComercial(StringDataType motivoGestionComercial) {
		this.motivoGestionComercial = motivoGestionComercial;
	}
	public BooleanDataType getSpsAlarma() {
		return spsAlarma;
	}
	public void setSpsAlarma(BooleanDataType spsAlarma) {
		this.spsAlarma = spsAlarma;
	}
	public DateDataType getSpsFechaInstalaAlarma() {
		return spsFechaInstalaAlarma;
	}
	public void setSpsFechaInstalaAlarma(DateDataType spsFechaInstalaAlarma) {
		this.spsFechaInstalaAlarma = spsFechaInstalaAlarma;
	}
	public DateDataType getSpsFechaDesinstalaAlarma() {
		return spsFechaDesinstalaAlarma;
	}
	public void setSpsFechaDesinstalaAlarma(DateDataType spsFechaDesinstalaAlarma) {
		this.spsFechaDesinstalaAlarma = spsFechaDesinstalaAlarma;
	}
	public BooleanDataType getSpsVigilancia() {
		return spsVigilancia;
	}
	public void setSpsVigilancia(BooleanDataType spsVigilancia) {
		this.spsVigilancia = spsVigilancia;
	}
	public DateDataType getSpsFechaInstalaVigilancia() {
		return spsFechaInstalaVigilancia;
	}
	public void setSpsFechaInstalaVigilancia(DateDataType spsFechaInstalaVigilancia) {
		this.spsFechaInstalaVigilancia = spsFechaInstalaVigilancia;
	}
	public DateDataType getSpsFechaDesinstalaVigilancia() {
		return spsFechaDesinstalaVigilancia;
	}
	public void setSpsFechaDesinstalaVigilancia(DateDataType spsFechaDesinstalaVigilancia) {
		this.spsFechaDesinstalaVigilancia = spsFechaDesinstalaVigilancia;
	}
	public BooleanDataType getOnvComercializacion() {
		return onvComercializacion;
	}
	public void setOnvComercializacion(BooleanDataType onvComercializacion) {
		this.onvComercializacion = onvComercializacion;
	}
	public StringDataType getOnvComercializacionFecha() {
		return onvComercializacionFecha;
	}
	public void setOnvComercializacionFecha(StringDataType onvComercializacionFecha) {
		this.onvComercializacionFecha = onvComercializacionFecha;
	}
	public BooleanDataType getNecesidadIf() {
		return necesidadIf;
	}
	public void setNecesidadIf(BooleanDataType necesidadIf) {
		this.necesidadIf = necesidadIf;
	}
	public StringDataType getCodDirComercial() {
		return codDirComercial;
	}
	public void setCodDirComercial(StringDataType codDirComercial) {
		this.codDirComercial = codDirComercial;
	}
	public DoubleDataType getImporteCampanyaAlquiler() {
		return importeCampanyaAlquiler;
	}
	public void setImporteCampanyaAlquiler(DoubleDataType importeCampanyaAlquiler) {
		this.importeCampanyaAlquiler = importeCampanyaAlquiler;
	}
	public DateDataType getFechaInicioCampanyaAlquiler() {
		return fechaInicioCampanyaAlquiler;
	}
	public void setFechaInicioCampanyaAlquiler(DateDataType fechaInicioCampanyaAlquiler) {
		this.fechaInicioCampanyaAlquiler = fechaInicioCampanyaAlquiler;
	}
	public DateDataType getFechaFinCampanyaAlquiler() {
		return fechaFinCampanyaAlquiler;
	}
	public void setFechaFinCampanyaAlquiler(DateDataType fechaFinCampanyaAlquiler) {
		this.fechaFinCampanyaAlquiler = fechaFinCampanyaAlquiler;
	}
	public LongDataType getCodigoAgrupacionRestringidaVenta() {
		return codigoAgrupacionRestringidaVenta;
	}
	public void setCodigoAgrupacionRestringidaVenta(LongDataType codigoAgrupacionRestringidaVenta) {
		this.codigoAgrupacionRestringidaVenta = codigoAgrupacionRestringidaVenta;
	}
	public BooleanDataType getEsActivoPrincipalRestringidaVenta() {
		return esActivoPrincipalRestringidaVenta;
	}
	public void setEsActivoPrincipalRestringidaVenta(BooleanDataType esActivoPrincipalRestringidaVenta) {
		this.esActivoPrincipalRestringidaVenta = esActivoPrincipalRestringidaVenta;
	}
	public LongDataType getCodigoAgrupacionRestringidaAlquiler() {
		return codigoAgrupacionRestringidaAlquiler;
	}
	public void setCodigoAgrupacionRestringidaAlquiler(LongDataType codigoAgrupacionRestringidaAlquiler) {
		this.codigoAgrupacionRestringidaAlquiler = codigoAgrupacionRestringidaAlquiler;
	}
	public BooleanDataType getEsActivoPrincipalRestringidaAlquiler() {
		return esActivoPrincipalRestringidaAlquiler;
	}
	public void setEsActivoPrincipalRestringidaAlquiler(BooleanDataType esActivoPrincipalRestringidaAlquiler) {
		this.esActivoPrincipalRestringidaAlquiler = esActivoPrincipalRestringidaAlquiler;
	}
	public LongDataType getCodigoAgrupacionRestringidaObRem() {
		return codigoAgrupacionRestringidaObRem;
	}
	public void setCodigoAgrupacionRestringidaObRem(LongDataType codigoAgrupacionRestringidaObRem) {
		this.codigoAgrupacionRestringidaObRem = codigoAgrupacionRestringidaObRem;
	}
	public BooleanDataType getEsActivoPrincipalRestringidaObRem() {
		return esActivoPrincipalRestringidaObRem;
	}
	public void setEsActivoPrincipalRestringidaObRem(BooleanDataType esActivoPrincipalRestringidaObRem) {
		this.esActivoPrincipalRestringidaObRem = esActivoPrincipalRestringidaObRem;
	}
	public StringDataType getIdActivoBc() {
		return idActivoBc;
	}
	public void setIdActivoBc(StringDataType idActivoBc) {
		this.idActivoBc = idActivoBc;
	}
	public StringDataType getCodigoPortalPublicacion() {
		return codigoPortalPublicacion;
	}
	public void setCodigoPortalPublicacion(StringDataType codigoPortalPublicacion) {
		this.codigoPortalPublicacion = codigoPortalPublicacion;
	}
	public StringDataType getCodigoCanalDistVenta() {
		return codigoCanalDistVenta;
	}
	public void setCodigoCanalDistVenta(StringDataType codigoCanalDistVenta) {
		this.codigoCanalDistVenta = codigoCanalDistVenta;
	}
	public StringDataType getCodigoCanalDistAlquiler() {
		return codigoCanalDistAlquiler;
	}
	public void setCodigoCanalDistAlquiler(StringDataType codigoCanalDistAlquiler) {
		this.codigoCanalDistAlquiler = codigoCanalDistAlquiler;
	}
	public DoubleDataType getTestigoOblPorcentajeDesc() {
		return testigoOblPorcentajeDesc;
	}
	public void setTestigoOblPorcentajeDesc(DoubleDataType testigoOblPorcentajeDesc) {
		this.testigoOblPorcentajeDesc = testigoOblPorcentajeDesc;
	}
	public DoubleDataType getTestigoOblImporteMin() {
		return testigoOblImporteMin;
	}
	public void setTestigoOblImporteMin(DoubleDataType testigoOblImporteMin) {
		this.testigoOblImporteMin = testigoOblImporteMin;
	}
	public BooleanDataType getRequiereTestigo() {
		return requiereTestigo;
	}
	public void setRequiereTestigo(BooleanDataType requiereTestigo) {
		this.requiereTestigo = requiereTestigo;
	}
	public DoubleDataType getRecomendacionPorcenDescuentoVenta() {
		return recomendacionPorcenDescuentoVenta;
	}
	public void setRecomendacionPorcenDescuentoVenta(DoubleDataType recomendacionPorcenDescuentoVenta) {
		this.recomendacionPorcenDescuentoVenta = recomendacionPorcenDescuentoVenta;
	}
	public DoubleDataType getRecomendacionPrecioMinimoVenta() {
		return recomendacionPrecioMinimoVenta;
	}
	public void setRecomendacionPrecioMinimoVenta(DoubleDataType recomendacionPrecioMinimoVenta) {
		this.recomendacionPrecioMinimoVenta = recomendacionPrecioMinimoVenta;
	}
	public StringDataType getRecomendacionInternaRequerida() {
		return recomendacionInternaRequerida;
	}
	public void setRecomendacionInternaRequerida(StringDataType recomendacionInternaRequerida) {
		this.recomendacionInternaRequerida = recomendacionInternaRequerida;
	}
	public StringDataType getProDocidentif() {
		return proDocidentif;
	}
	public void setProDocidentif(StringDataType proDocidentif) {
		this.proDocidentif = proDocidentif;
	}
	public StringDataType getProNombre() {
		return proNombre;
	}
	public void setProNombre(StringDataType proNombre) {
		this.proNombre = proNombre;
	}
}
