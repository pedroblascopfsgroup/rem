package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class StockDto implements WebcomRESTDto{
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idActivoHaya;
	private LongDataType idActivoSareb;
	private LongDataType idActivoPrinex;
	private LongDataType idActivoRem;
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
	private StringDataType codEstadoComercial;
	private StringDataType codTipoVenta;
	@DecimalDataTypeFormat(decimals=8)
	private DoubleDataType lat;
	@DecimalDataTypeFormat(decimals=8)
	private DoubleDataType lng;
	private StringDataType codEstadoConstruccion;
	private LongDataType terrazas;
	private StringDataType codEstadoPublicacion;
	private DateDataType publicadoDesde;
	private BooleanDataType reformas;
	private StringDataType codRegimenProteccion;
	private StringDataType distribucion;
	private StringDataType codDetallePublicacion;
	private LongDataType codigoAgrupacionObraNueva;
	private LongDataType codigoCabeceraObraNueva;
	private LongDataType idProveedorRemAnterior;
	private LongDataType idProveedorRem;
	private StringDataType nombreGestorComercial;
	private StringDataType telefonoGestorComercial;
	private StringDataType emailGestorComercial;
	private StringDataType codCee;
	private LongDataType antiguedad;
	private StringDataType codCartera;
	private StringDataType codRatio;
	
	//Petición HREOS-1399
	//@WebcomRequired
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
	private LongDataType idLoteRem;
	private BooleanDataType esActivoPrincipal;
	
	//HREOS-1478
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType actualImporteDescuentoWeb;
	private DateDataType desdeImporteDescuentoWeb;
	private DateDataType hastaImporteDescuentoWeb;
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType valorAprobadoRenta;
	private DateDataType fechaValorAprobadoRenta;	
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType anteriorValorAprobadoRenta;
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType valorAprobadoVenta;
	private DateDataType fechaValorAprobadoVenta;
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType anteriorValorAprobadoVenta;
	
	//Petición HREOS-1551
	private LongDataType idAsistida;
	private LongDataType codigoCabeceraAsistida;
	
	//HREOS-1630
	private StringDataType codSubtipoTitulo;
	
	//HREOS-1809
	private StringDataType codSubCartera;
	
	//Petición HREOS-1930 - Se amplia campo de 500 a 3000
	private StringDataType condicionesEspecificas;
	private StringDataType descripcion;
	
	//HREOS-3955
	@MappedColumn("cod_estado_pub_alquiler")
	private StringDataType codEstadoPublicacionAlquiler;
	
	@MappedColumn("cod_subestado_pub_venta")
	private StringDataType codSubEstadoPublicacionVenta;
    
	@MappedColumn("cod_subestado_pub_alquiler")
	private StringDataType codSubEstadoPublicacionAlquiler;

	private BooleanDataType indOcultarPrecioVenta;
	
	private BooleanDataType indOcultarPrecioAlquiler;
    
	private StringDataType arrCodDetallePublicacion;
	
	@MappedColumn("COD_AGRUPACION_COMERCIAL_REM")
	private LongDataType codigoAgrupacionComercialRem;
	
	private StringDataType descripcionOtros;

	private LongDataType activoProveedorTecnico;
	
	// Modificaciones WS Stock
	private StringDataType codTipoAlquiler;

	//@MappedColumn("COD_ESTADO_FIS_ACTIVO")
	private StringDataType codEstadoFisico;

	private StringDataType codTipoUsoDestino;
	
	

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
	public StringDataType getCodTipoAlquiler() {
		return codTipoAlquiler;
	}
	public void setCodTipoAlquiler(StringDataType codTipoAlquiler) {
		this.codTipoAlquiler = codTipoAlquiler;
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
	
	public LongDataType getCodigoAgrupacionComercialRem() {
		return codigoAgrupacionComercialRem;
	}
	public void setCodigoAgrupacionComercialRem(LongDataType codigoAgrupacionComercialRem) {
		this.codigoAgrupacionComercialRem = codigoAgrupacionComercialRem;
	}
}
