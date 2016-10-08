package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDAcabadoCarpinteria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOrientacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDUsosActivo;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TRANSFORM_TYPE;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class InformeMediadorDto implements Serializable {

	/**
	 * 
	 */
	@EntityDefinition(procesar = false)
	private static final long serialVersionUID = 1L;

	@EntityDefinition(procesar = false)
	@NotNull(groups = { Insert.class, Update.class })
	private Long idInformeMediadorWebcom;

	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "fechaEmisionInforme")
	private Date fechaAccion;

	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(procesar = false)
	private Long idUsuarioRemAccion;

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoActivo.class, message = "El codTipoActivo no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "tipoActivo", classObj = DDTipoActivo.class)
	private String codTipoActivo;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDSubtipoActivo.class, message = "El codSubtipoInmueble no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "subtipoActivo", classObj = DDSubtipoActivo.class)
	private String codSubtipoInmueble;

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Activo.class, message = "El activo no existe", foreingField = "numActivo", groups = {
			Insert.class, Update.class })
	@EntityDefinition(procesar = false)
	private Long idActivoHaya;

	@NotNull(groups = Insert.class)
	@EntityDefinition(procesar = false)
	private Long idProveedorRemAnterior;

	@NotNull(groups = Insert.class)
	@EntityDefinition(procesar = false)
	private Long idProveedorRem;

	// ?ACT_HIC_EST_INF_COMER_HIST
	@NotNull(groups = Insert.class)
	@EntityDefinition(procesar = false)
	private Boolean posibleInforme;

	@NotNull(groups = Insert.class)
	@EntityDefinition(procesar = false)
	private String motivoNoPosibleInforme;
	// fin ACT_HIC_EST_INF_COMER_HIST

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDSubtipoActivo.class, message = "El codSubtipoImueble no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "subtipoActivo", classObj = DDSubtipoActivo.class)
	private String codSubtipoImueble;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoVivienda.class, message = "El codTpoVivienda de activo no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "tipoVivienda", classObj = DDTipoVivienda.class)
	private String codTipoVivienda;

	// ok
	@NotNull(groups = Insert.class)
	private Date fechaUltimaVisita;

	@Diccionary(clase = DDTipoVia.class, message = "El codTpoVivienda de activo no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "tipoVia", classObj = DDTipoVia.class)
	private String codTipoVia;

	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "nombreVia")
	private String nombreCalle;

	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "numeroVia")
	private String numeroCalle;

	// ok
	private String escalera;

	// ok
	private String planta;

	// ok
	private String puerta;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = Localidad.class, message = "El codMunicipio no existe", groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "localidad", classObj = Localidad.class)
	private String codMunicipio;

	@Diccionary(clase = DDUnidadPoblacional.class, message = "El codPedania no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "unidadPoblacional", classObj = DDUnidadPoblacional.class)
	private String codPedania;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDProvincia.class, message = "El codProvincia no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "provincia", classObj = DDProvincia.class)
	private String codProvincia;

	// ok
	@NotNull(groups = Insert.class)
	private String codigoPostal;

	// ok
	@NotNull(groups = Insert.class)
	private String zona;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDUbicacionActivo.class, message = "El codUbicacion no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "ubicacionActivo", classObj = DDUbicacionActivo.class)
	private String codUbicacion;

	@NotNull(groups = Insert.class) // <------------------------------------------------------------------------------------------------------Diccionario???
	@EntityDefinition(propertyName = "distrito")
	private String codDistrito;

	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "latitud", transform = TRANSFORM_TYPE.FLOAT_TO_BIGDECIMAL)
	private Float lat;

	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "longitud", transform = TRANSFORM_TYPE.FLOAT_TO_BIGDECIMAL)
	private Float lng;

	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "fechaRecepcionLlaves")
	private Date fechaRecepcionLlavesApi;

	// ? ACT_ICO_INF_COMERCIAL DD_LOC_REGISTRO_ID
	@Diccionary(clase = Localidad.class, message = "El codMunicipioRegistro no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(procesar = false, motivo = "No Existe entity para ACT_INFO_ADMINISTRATIVA")
	private String codMunicipioRegistro;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoVpo.class, message = "El codRegimenProteccion no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "regimenProteccion", classObj = DDTipoVpo.class)
	private String codRegimenProteccion;

	// OK
	private Float valorMaximoVpo;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoGradoPropiedad.class, message = "El codTipoPropiedad no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(procesar = false)
	private String codTipoPropiedad;// <---------------------------------Diccionario???

	@NotNull(groups = Insert.class)
	@EntityDefinition(procesar = false)
	private Float porcentajePropiedad;

	// activo.valoracion.importe
	@NotNull(groups = Insert.class)
	private Float valorEstimadoVenta;

	// activo.valoracion.fechaInicio
	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "fechaEstimacionVenta")
	private Date fechaValorEstimadoVenta;

	// activo.valoracion.observaciones
	@EntityDefinition(propertyName = "justificacionVenta")
	@NotNull(groups = Insert.class)
	private String justificacionValorEstimadoVenta;

	// activo.valoracion.importe
	@NotNull(groups = Insert.class)
	private Float valorEstimadoRenta;

	// activo.valoracion.fechaInicio
	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "fechaEstimacionRenta")
	private Date fechaValorEstimadoRenta;

	@NotNull(groups = Insert.class)
	@EntityDefinition(propertyName = "justificacionRenta")
	private String justificacionValorEstimadoRenta;

	@EntityDefinition(procesar = false)
	private Float utilSuperficie;

	@EntityDefinition(procesar = false)
	private Float construidaSuperficie;

	@EntityDefinition(procesar = false)
	private Float registralSuperficie;

	@EntityDefinition(procesar = false)
	private Float parcelaSuperficie;

	// Fake!! construccion y conservacion cruzados
	@Diccionary(clase = DDEstadoConstruccion.class, message = "El codEstadoConservacion no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "estadoConservacion", classObj = DDEstadoConstruccion.class)
	private String codEstadoConservacion;

	// ok
	@EntityDefinition(propertyName = "anyoConstruccion")
	private Integer anyoConstruccion;

	@EntityDefinition(propertyName = "anyoRehabilitacion")
	private Integer anyoRehabilitacion;

	@EntityDefinition(propertyName = "ultimaPlanta", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean ultimaPlanta;

	@EntityDefinition(procesar = false, motivo = "No existe entity ACT_SPS_SITUACION_POSESORIA")
	private Boolean ocupado;

	@EntityDefinition(propertyName = "numPlantasInter")
	private Integer numeroPlantas;

	@Diccionary(clase = DDTipoOrientacion.class, message = "El codOrientacion no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "tipoOrientacion", classObj = DDTipoOrientacion.class)
	private String codOrientacion;

	@Diccionary(clase = DDTipoRenta.class, message = "El codNivelRenta no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "tipoRenta", classObj = DDTipoRenta.class)
	private String codNivelRenta;

	// ?
	@EntityDefinition(procesar = false, motivo = "no estamos procesando las plantas")
	private List<PlantaDto> plantas;

	private Integer numeroTerrazasDescubiertas;

	private String descripcionTerrazasDescubiertas;

	private Integer numeroTerrazasCubiertas;

	private String descripcionTerrazasCubiertas;

	@EntityDefinition(propertyName = "despensaOtrasDependencias", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean despensaOtrasDependencias;

	@EntityDefinition(propertyName = "despensaOtrasDependencias", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean lavaderoOtrasDependencias;

	@EntityDefinition(propertyName = "despensaOtrasDependencias", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean azoteaOtrasDependencias;

	private String otrosOtrasDependencias;

	@EntityDefinition(propertyName = "reformaCarpExt")
	private Boolean exteriorCarpinteriaReformasNecesarias;

	@EntityDefinition(propertyName = "reformaCarpInt")
	private Boolean interiorCarpinteriaReformasNecesarias;

	@EntityDefinition(propertyName = "reformaCocina")
	private Boolean cocinaReformasNecesarias;

	@EntityDefinition(propertyName = "reformaSuelo")
	private Boolean suelosReformasNecesarias;

	@EntityDefinition(propertyName = "reformaPintura")
	private Boolean pinturaReformasNecesarias;

	@EntityDefinition(propertyName = "reformaIntegral")
	private Boolean integralReformasNecesarias;

	@EntityDefinition(propertyName = "reformaBanyo")
	private Boolean banyosReformasNecesarias;

	@EntityDefinition(propertyName = "reformaOtroDesc")
	private String otrasReformasNecesarias;

	@EntityDefinition(propertyName = "reformaPresupuesto")
	private Double otrasReformasNecesariasImporteAproximado;

	@EntityDefinition(propertyName = "infoDistribucionInterior")
	private String distribucionInterior;

	@EntityDefinition(procesar = false, motivo = "No existe la columna EDI_DIVISIBLE en ACT_EDI_EDIFICIO")
	private Boolean divisible;

	@EntityDefinition(propertyName = "ascensor")
	private Boolean ascensor;

	@EntityDefinition(propertyName = "numAscensores")
	private Integer numeroAscensores;

	@EntityDefinition(procesar = false, motivo = "No existe la columna EDI_DESC_PLANTAS en ACT_EDI_EDIFICIO")
	private String descripcionPlantas;

	@EntityDefinition(procesar = false, motivo = "No existe la columna EDI_OTRAS_CARACTERISTICAS en ACT_EDI_EDIFICIO")
	private String otrasCaracteristicas;

	@EntityDefinition(propertyName = "reformaFachada")
	private Boolean fachadaReformasNecesarias;

	@EntityDefinition(propertyName = "reformaEscalera")
	private Boolean escaleraReformasNecesarias;

	@EntityDefinition(propertyName = "reformaPortal")
	private Boolean portalReformasNecesarias;

	@EntityDefinition(propertyName = "reformaAscensor")
	private Boolean ascensorReformasNecesarias;

	@EntityDefinition(propertyName = "reformaCubierta")
	private Boolean cubierta;

	@EntityDefinition(propertyName = "reformaOtraZona")
	private Boolean otrasZonasComunesReformasNecesarias;

	@EntityDefinition(propertyName = "reformaOtroDescEdificio")
	private String otrosReformasNecesarias;

	@EntityDefinition(propertyName = "ediDescripcion")
	private String descripcionEdificio;

	@EntityDefinition(propertyName = "entornoInfraestructura")
	private String infraestructurasEntorno;

	@EntityDefinition(propertyName = "EDI_ENTORNO_COMUNICACION")
	private String comunicacionesEntorno;

	@EntityDefinition(propertyName = "usuIdoneo")
	private String idoneoUso;

	@EntityDefinition(procesar = false)
	private Boolean existeAnteriorUso;

	@EntityDefinition(propertyName = "usuAnterior")
	private String anteriorUso;

	@EntityDefinition(procesar = false, motivo = "No existe la columna LCO_NUMERO_ESTANCIAS en ACT_LCO_LOCAL_COMERCIAL")
	private Long numeroEstancias;

	@EntityDefinition(procesar = false, motivo = "No existe la columna LCO_NUMERO_BANYOS en ACT_LCO_LOCAL_COMERCIAL")
	private Long numeroBanyos;

	@EntityDefinition(procesar = false, motivo = "No existe la columna LCO_NUMERO_ASEOS en ACT_LCO_LOCAL_COMERCIAL")
	private long numeroAseos;

	@EntityDefinition(propertyName = "mtsFachadaPpal")
	private Float metrosLinealesFachadaPrincipal;

	@EntityDefinition(propertyName = "mtsAlturaLibre")
	private Float altura;

	@EntityDefinition(procesar = false, motivo = "No existe la tabla ACT_ANJ_ANEJOS")
	private Long numeroPlazasGaraje;

	@EntityDefinition(procesar = false, motivo = "No existe la tabla ACT_ANJ_ANEJOS")
	private Float superficiePlazasGaraje;

	@EntityDefinition(procesar = false, motivo = "No existe la tabla ACT_ANJ_ANEJOS")
	private String codSubtipoPlazasGaraje;// <-------------------------------------diccionario?

	@EntityDefinition(propertyName="existeSalidaHumos", transform=TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean salidaHumosOtrasCaracteristicas;

	@EntityDefinition(propertyName="existeSalidaEmergencias", transform=TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean salidaEmergenciaOtrasCaracteristicas;

	@EntityDefinition(propertyName="existeAccesoMinusvalidos", transform=TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean accesoMinusvalidosOtrasCaracteristicas;

	@EntityDefinition(propertyName = "otrosOtrasCaracteristicas")
	private String otrosOtrasCaracteristicas;

	@EntityDefinition(procesar = false, motivo = "No existe la columna ACT_APR_PLAZA_APARCAMIENTO  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private String codTipoVario;// <-------------------------------------diccionario?

	@EntityDefinition(propertyName = "anchura")
	private Float ancho;

	@EntityDefinition(procesar = false, motivo = "No existe la columna APR_ALTURA  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private Float alto;

	@EntityDefinition(propertyName = "profundidad")
	private Float largo;

	@Diccionary(clase = DDUsosActivo.class, message = "El codUso no existe", groups = { Insert.class, Update.class })
	@EntityDefinition(procesar = false, motivo = "No existe la columna DD_SPG_ID  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private String codUso;

	@Diccionary(clase = DDTipoCalidad.class, message = "El codNivelRenta no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "tipoCalidad", classObj = DDTipoCalidad.class)
	private String codManiobrabilidad;

	@EntityDefinition(procesar = false, motivo = "No existe la columna APR_LICENCIA  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private Boolean licenciaOtrasCaracteristicas;

	@EntityDefinition(procesar = false, motivo = "No existe la columna APR_SERVIDUMBRE  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private Boolean servidumbreOtrasCaracteristicas;

	@EntityDefinition(procesar = false, motivo = "No existe la columna APR_ASCENSOR_MONTACARGA  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private Boolean ascensorOMontacargasOtrasCaracteristicas;

	@EntityDefinition(procesar = false, motivo = "No existe la columna APR_COLUMNAS  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private Boolean columnasOtrasCaracteristicas;

	@EntityDefinition(procesar = false, motivo = "No existe la columna APR_SEGURIDAD  en la tabla ACT_APR_PLAZA_APARCAMIENTO")
	private Boolean seguridadOtrasCaracteristicas;

	@EntityDefinition(procesar = false, motivo = "No existe en el modelo")
	private Boolean buenEstadoInstalacionElectricidadInstalaciones;

	@EntityDefinition(procesar = false, motivo = "No existe en el modelo")
	private Boolean buenEstadoContadorElectricidadInstalaciones;

	@EntityDefinition(procesar = false, motivo = "No existe en el modelo")
	private Boolean buenEstadoInstalacionAguaInstalaciones;

	@EntityDefinition(procesar = false, motivo = "No existe en el modelo")
	private Boolean buenEstadoContadorAguaInstalaciones;

	@EntityDefinition(procesar = false, motivo = "No existe en el modelo")
	private Boolean buenEstadoGasInstalaciones;

	@EntityDefinition(procesar = false, motivo = "No existe en el modelo")
	private Boolean buenEstadoContadorGasInstalacion;

	@Diccionary(clase = DDEstadoConservacion.class, message = "El codEstadoConservacionEdificio no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "estadoConservacionEdificio", classObj = DDEstadoConservacion.class)
	private String codEstadoConservacionEdificio;

	@EntityDefinition(propertyName = "anyoRehabilitacion")
	private Date anyoRehabilitacionEdificio;

	@EntityDefinition(propertyName = "numPlantas")
	private Long numeroPlantasEdificio;

	@EntityDefinition(propertyName = "ascensor", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean ascensorEdificio;

	@EntityDefinition(propertyName = "numAscensores")
	private Integer numeroAscensoresEdificio;

	@EntityDefinition(procesar = false)
	private Boolean existeComunidadEdificio;

	@EntityDefinition(propertyName = "cuotaOrientativaComunidad")
	private Float cuotaComunidadEdificio;

	private String nombrePresidenteComunidadEdificio;

	private String telefonoPresidenteComunidadEdificio;

	private String nombreAdministradorComunidadEdificio;

	private String telefonoAdministradorComunidadEdificio;

	@EntityDefinition(propertyName = "derramaOrientativaComunidad")
	private String descripcionDerramaComunidadEdificio;

	@EntityDefinition(propertyName = "reformaFachada")
	private Boolean fachadaReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "reformaEscalera")
	private String escaleraReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "reformaPortal")
	private Boolean portalReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "reformaAscensor")
	private Boolean ascensorReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "reformaCubierta")
	private Boolean cubiertaReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "reformaOtraZona")
	private Boolean otrasZonasComunesReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "reformaOtroDescEdificio")
	private String otrosReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "entornoInfraestructura")
	private String infraestructurasEntornoEdificio;

	@EntityDefinition(propertyName = "entornoComunicacion")
	private String comunicacionesEntornoEdificio;

	@EntityDefinition(propertyName = "ocio", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existeOcio;

	@EntityDefinition(propertyName = "hoteles", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenHoteles;

	@EntityDefinition(propertyName = "hotelesDesc")
	private String hoteles;

	@EntityDefinition(propertyName = "teatros", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenTeatros;

	@EntityDefinition(propertyName = "teatrosDesc")
	private String teatros;

	@EntityDefinition(propertyName = "salasCine", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenSalasDeCine;

	@EntityDefinition(propertyName = "salasCineDesc")
	private String salasDeCine;

	@EntityDefinition(propertyName = "instDeportivas", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenInstalacionesDeportivas;

	@EntityDefinition(propertyName = "instDeportivasDesc")
	private String instalacionesDeportivas;

	@EntityDefinition(propertyName = "centrosComerciales", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenCentrosComerciales;

	@EntityDefinition(propertyName = "centrosComercialesDesc")
	private String centrosComerciales;

	@EntityDefinition(propertyName = "ocioOtros")
	private String otrosOcio;

	@EntityDefinition(propertyName = "centrosEducativos", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenCentrosEducativos;

	@EntityDefinition(propertyName = "escuelasInfantiles", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenEscuelasInfantiles;

	@EntityDefinition(propertyName = "escuelasInfantilesDesc")
	private String escuelasInfantiles;

	@EntityDefinition(propertyName = "colegios", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenColegios;

	@EntityDefinition(propertyName = "colegiosDesc")
	private String colegios;

	@EntityDefinition(propertyName = "institutos", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenInstitutos;

	@EntityDefinition(propertyName = "institutosDesc")
	private String institutos;

	@EntityDefinition(propertyName = "universidades", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenUniversidades;

	@EntityDefinition(propertyName = "universidadesDesc")
	private String universidades;

	@EntityDefinition(propertyName = "centrosEducativosOtros")
	private String otrosCentrosEducativos;

	@EntityDefinition(propertyName = "centrosSanitarios", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenCentrosSanitarios;

	@EntityDefinition(propertyName = "centrosSalud", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenCentrosDeSalud;

	@EntityDefinition(propertyName = "centrosSaludDesc")
	private String centrosDeSalud;

	@EntityDefinition(propertyName = "clinicas", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenClinicas;

	@EntityDefinition(propertyName = "clinicasDesc")
	private String clinicas;

	@EntityDefinition(propertyName = "hospitales", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenHospitales;

	@EntityDefinition(propertyName = "hospitalesDesc")
	private String hospitales;

	@EntityDefinition(procesar = false)
	private Boolean existenOtrosCentrosSanitarios;

	@EntityDefinition(propertyName = "centrosSanitariosOtros")
	private String otrosCentrosSanitarios;

	@EntityDefinition(propertyName = "parkingSuperSufi", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean suficienteAparcamientoEnSuperficie;

	@EntityDefinition(propertyName = "comunicaciones", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existenComunicaciones;

	@EntityDefinition(propertyName = "facilAcceso", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existeFacilAccesoPorCarretera;

	@EntityDefinition(propertyName = "lineasBus", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existeLineasDeAutobus;

	@EntityDefinition(propertyName = "lineasBusDesc")
	private String lineasDeAutobus;

	@EntityDefinition(propertyName = "metro", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existeMetro;

	@EntityDefinition(propertyName = "metroDesc")
	private String metro;

	@EntityDefinition(propertyName = "estacionTren", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existeEstacionesDeTren;

	@EntityDefinition(propertyName = "estacionTrenDesc")
	private String estacionesDeTren;
	
	@EntityDefinition(propertyName = "comunicacionesOtro")
	private String otrosComunicaciones;
	
	@EntityDefinition(propertyName = "puertaEntradaNormal", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPuertaEntradaNormal;
	
	@EntityDefinition(propertyName = "puertaEntradaBlindada", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPuertaEntradaBlindada;
	
	@EntityDefinition(propertyName = "puertaEntradaAcorazada", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPuertaEntradaAcorazada;
	
	@EntityDefinition(propertyName = "puertaPasoMaciza", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPuertaPasoMaciza;
	
	@EntityDefinition(propertyName = "puertaPasoHueca", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPuertaPasoHueca;
	
	@EntityDefinition(propertyName = "puertaPasoLacada", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPuertaPasoLacada;
	
	@EntityDefinition(propertyName = "armariosEmpotrados", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existenArmariosEmpotrados;
	
	@Diccionary(clase = DDAcabadoCarpinteria.class, message = "El codAcabadoCarpinteria no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "acabadoCarpinteria", classObj = DDAcabadoCarpinteria.class)
	private String codAcabadoCarpinteria;
	
	@EntityDefinition(propertyName = "carpinteriaInteriorOtros")
	private String otrosCarpinteriaInterior;

	public Long getIdInformeMediadorWebcom() {
		return idInformeMediadorWebcom;
	}

	public void setIdInformeMediadorWebcom(Long idInformeMediadorWebcom) {
		this.idInformeMediadorWebcom = idInformeMediadorWebcom;
	}

	public String getCodTipoActivo() {
		return codTipoActivo;
	}

	public void setCodTipoActivo(String codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}

	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}

	public Long getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

	public Long getIdProveedorRemAnterior() {
		return idProveedorRemAnterior;
	}

	public void setIdProveedorRemAnterior(Long idProveedorRemAnterior) {
		this.idProveedorRemAnterior = idProveedorRemAnterior;
	}

	public Long getIdProveedorRem() {
		return idProveedorRem;
	}

	public void setIdProveedorRem(Long idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}

	public Boolean getPosibleInforme() {
		return posibleInforme;
	}

	public void setPosibleInforme(Boolean posibleInforme) {
		this.posibleInforme = posibleInforme;
	}

	public String getMotivoNoPosibleInforme() {
		return motivoNoPosibleInforme;
	}

	public void setMotivoNoPosibleInforme(String motivoNoPosibleInforme) {
		this.motivoNoPosibleInforme = motivoNoPosibleInforme;
	}

	public String getCodSubtipoImueble() {
		return codSubtipoImueble;
	}

	public void setCodSubtipoImueble(String codSubtipoImueble) {
		this.codSubtipoImueble = codSubtipoImueble;
	}

	public String getCodTipoVivienda() {
		return codTipoVivienda;
	}

	public void setCodTpoVivienda(String codTpoVivienda) {
		this.codTipoVivienda = codTpoVivienda;
	}

	public Date getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}

	public void setFechaUltimaVisita(Date fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
	}

	public String getCodTipoVia() {
		return codTipoVia;
	}

	public void setCodTipoVia(String codTipoVia) {
		this.codTipoVia = codTipoVia;
	}

	public String getNombreCalle() {
		return nombreCalle;
	}

	public void setNombreCalle(String nombreCalle) {
		this.nombreCalle = nombreCalle;
	}

	public String getNumeroCalle() {
		return numeroCalle;
	}

	public void setNumeroCalle(String numeroCalle) {
		this.numeroCalle = numeroCalle;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPlanta() {
		return planta;
	}

	public void setPlanta(String planta) {
		this.planta = planta;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getCodMunicipio() {
		return codMunicipio;
	}

	public void setCodMunicipio(String codMunicipio) {
		this.codMunicipio = codMunicipio;
	}

	public String getCodPedania() {
		return codPedania;
	}

	public void setCodPedania(String codPedania) {
		this.codPedania = codPedania;
	}

	public String getCodProvincia() {
		return codProvincia;
	}

	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getZona() {
		return zona;
	}

	public void setZona(String zona) {
		this.zona = zona;
	}

	public String getCodUbicacion() {
		return codUbicacion;
	}

	public void setCodUbicacion(String codUbicacion) {
		this.codUbicacion = codUbicacion;
	}

	public String getCodDistrito() {
		return codDistrito;
	}

	public void setCodDistrito(String codDistrito) {
		this.codDistrito = codDistrito;
	}

	public Float getLat() {
		return lat;
	}

	public void setLat(Float lat) {
		this.lat = lat;
	}

	public Float getLng() {
		return lng;
	}

	public void setLng(Float lng) {
		this.lng = lng;
	}

	public Date getFechaRecepcionLlavesApi() {
		return fechaRecepcionLlavesApi;
	}

	public void setFechaRecepcionLlavesApi(Date fechaRecepcionLlavesApi) {
		this.fechaRecepcionLlavesApi = fechaRecepcionLlavesApi;
	}

	public String getCodMunicipioRegistro() {
		return codMunicipioRegistro;
	}

	public void setCodMunicipioRegistro(String codMunicipioRegistro) {
		this.codMunicipioRegistro = codMunicipioRegistro;
	}

	public String getCodRegimenProteccion() {
		return codRegimenProteccion;
	}

	public void setCodRegimenProteccion(String codRegimenProteccion) {
		this.codRegimenProteccion = codRegimenProteccion;
	}

	public Float getValorMaximoVpo() {
		return valorMaximoVpo;
	}

	public void setValorMaximoVpo(Float valorMaximoVpo) {
		this.valorMaximoVpo = valorMaximoVpo;
	}

	public String getCodTipoPropiedad() {
		return codTipoPropiedad;
	}

	public void setCodTipoPropiedad(String codTipoPropiedad) {
		this.codTipoPropiedad = codTipoPropiedad;
	}

	public Float getPorcentajePropiedad() {
		return porcentajePropiedad;
	}

	public void setPorcentajePropiedad(Float porcentajePropiedad) {
		this.porcentajePropiedad = porcentajePropiedad;
	}

	public Float getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}

	public void setValorEstimadoVenta(Float valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}

	public Date getFechaValorEstimadoVenta() {
		return fechaValorEstimadoVenta;
	}

	public void setFechaValorEstimadoVenta(Date fechaValorEstimadoVenta) {
		this.fechaValorEstimadoVenta = fechaValorEstimadoVenta;
	}

	public String getJustificacionValorEstimadoVenta() {
		return justificacionValorEstimadoVenta;
	}

	public void setJustificacionValorEstimadoVenta(String justificacionValorEstimadoVenta) {
		this.justificacionValorEstimadoVenta = justificacionValorEstimadoVenta;
	}

	public Float getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}

	public void setValorEstimadoRenta(Float valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}

	public Date getFechaValorEstimadoRenta() {
		return fechaValorEstimadoRenta;
	}

	public void setFechaValorEstimadoRenta(Date fechaValorEstimadoRenta) {
		this.fechaValorEstimadoRenta = fechaValorEstimadoRenta;
	}

	public String getJustificacionValorEstimadoRenta() {
		return justificacionValorEstimadoRenta;
	}

	public void setJustificacionValorEstimadoRenta(String justificacionValorEstimadoRenta) {
		this.justificacionValorEstimadoRenta = justificacionValorEstimadoRenta;
	}

	public Float getUtilSuperficie() {
		return utilSuperficie;
	}

	public void setUtilSuperficie(Float utilSuperficie) {
		this.utilSuperficie = utilSuperficie;
	}

	public Float getConstruidaSuperficie() {
		return construidaSuperficie;
	}

	public void setConstruidaSuperficie(Float construidaSuperficie) {
		this.construidaSuperficie = construidaSuperficie;
	}

	public Float getRegistralSuperficie() {
		return registralSuperficie;
	}

	public void setRegistralSuperficie(Float registralSuperficie) {
		this.registralSuperficie = registralSuperficie;
	}

	public Float getParcelaSuperficie() {
		return parcelaSuperficie;
	}

	public void setParcelaSuperficie(Float parcelaSuperficie) {
		this.parcelaSuperficie = parcelaSuperficie;
	}

	public String getCodEstadoConservacion() {
		return codEstadoConservacion;
	}

	public void setCodEstadoConservacion(String codEstadoConservacion) {
		this.codEstadoConservacion = codEstadoConservacion;
	}

	public Integer getAnyoConstruccion() {
		return anyoConstruccion;
	}

	public void setAnyoConstruccion(Integer anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}

	public Integer getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}

	public void setAnyoRehabilitacion(Integer anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}

	public String getCodOrientacion() {
		return codOrientacion;
	}

	public void setCodOrientacion(String codOrientacion) {
		this.codOrientacion = codOrientacion;
	}

	public Boolean getUltimaPlanta() {
		return ultimaPlanta;
	}

	public void setUltimaPlanta(Boolean ultimaPlanta) {
		this.ultimaPlanta = ultimaPlanta;
	}

	public Boolean getOcupado() {
		return ocupado;
	}

	public void setOcupado(Boolean ocupado) {
		this.ocupado = ocupado;
	}

	public Integer getNumeroPlantas() {
		return numeroPlantas;
	}

	public void setNumeroPlantas(Integer numeroPlantas) {
		this.numeroPlantas = numeroPlantas;
	}

	public String getCodNivelRenta() {
		return codNivelRenta;
	}

	public void setCodNivelRenta(String codNivelRenta) {
		this.codNivelRenta = codNivelRenta;
	}

	public List<PlantaDto> getPlantas() {
		return plantas;
	}

	public void setPlantas(List<PlantaDto> plantas) {
		this.plantas = plantas;
	}

	public Integer getNumeroTerrazasDescubiertas() {
		return numeroTerrazasDescubiertas;
	}

	public void setNumeroTerrazasDescubiertas(Integer numeroTerrazasDescubiertas) {
		this.numeroTerrazasDescubiertas = numeroTerrazasDescubiertas;
	}

	public String getDescripcionTerrazasDescubiertas() {
		return descripcionTerrazasDescubiertas;
	}

	public void setDescripcionTerrazasDescubiertas(String descripcionTerrazasDescubiertas) {
		this.descripcionTerrazasDescubiertas = descripcionTerrazasDescubiertas;
	}

	public Integer getNumeroTerrazasCubiertas() {
		return numeroTerrazasCubiertas;
	}

	public void setNumeroTerrazasCubiertas(Integer numeroTerrazasCubiertas) {
		this.numeroTerrazasCubiertas = numeroTerrazasCubiertas;
	}

	public String getDescripcionTerrazasCubiertas() {
		return descripcionTerrazasCubiertas;
	}

	public void setDescripcionTerrazasCubiertas(String descripcionTerrazasCubiertas) {
		this.descripcionTerrazasCubiertas = descripcionTerrazasCubiertas;
	}

	public Boolean getDespensaOtrasDependencias() {
		return despensaOtrasDependencias;
	}

	public void setDespensaOtrasDependencias(Boolean despensaOtrasDependencias) {
		this.despensaOtrasDependencias = despensaOtrasDependencias;
	}

	public Boolean getLavaderoOtrasDependencias() {
		return lavaderoOtrasDependencias;
	}

	public void setLavaderoOtrasDependencias(Boolean lavaderoOtrasDependencias) {
		this.lavaderoOtrasDependencias = lavaderoOtrasDependencias;
	}

	public Boolean getAzoteaOtrasDependencias() {
		return azoteaOtrasDependencias;
	}

	public void setAzoteaOtrasDependencias(Boolean azoteaOtrasDependencias) {
		this.azoteaOtrasDependencias = azoteaOtrasDependencias;
	}

	public String getOtrosOtrasDependencias() {
		return otrosOtrasDependencias;
	}

	public void setOtrosOtrasDependencias(String otrosOtrasDependencias) {
		this.otrosOtrasDependencias = otrosOtrasDependencias;
	}

	public Boolean getExteriorCarpinteriaReformasNecesarias() {
		return exteriorCarpinteriaReformasNecesarias;
	}

	public void setExteriorCarpinteriaReformasNecesarias(Boolean exteriorCarpinteriaReformasNecesarias) {
		this.exteriorCarpinteriaReformasNecesarias = exteriorCarpinteriaReformasNecesarias;
	}

	public Boolean getInteriorCarpinteriaReformasNecesarias() {
		return interiorCarpinteriaReformasNecesarias;
	}

	public void setInteriorCarpinteriaReformasNecesarias(Boolean interiorCarpinteriaReformasNecesarias) {
		this.interiorCarpinteriaReformasNecesarias = interiorCarpinteriaReformasNecesarias;
	}

	public Boolean getCocinaReformasNecesarias() {
		return cocinaReformasNecesarias;
	}

	public void setCocinaReformasNecesarias(Boolean cocinaReformasNecesarias) {
		this.cocinaReformasNecesarias = cocinaReformasNecesarias;
	}

	public Boolean getSuelosReformasNecesarias() {
		return suelosReformasNecesarias;
	}

	public void setSuelosReformasNecesarias(Boolean suelosReformasNecesarias) {
		this.suelosReformasNecesarias = suelosReformasNecesarias;
	}

	public Boolean getPinturaReformasNecesarias() {
		return pinturaReformasNecesarias;
	}

	public void setPinturaReformasNecesarias(Boolean pinturaReformasNecesarias) {
		this.pinturaReformasNecesarias = pinturaReformasNecesarias;
	}

	public Boolean getIntegralReformasNecesarias() {
		return integralReformasNecesarias;
	}

	public void setIntegralReformasNecesarias(Boolean integralReformasNecesarias) {
		this.integralReformasNecesarias = integralReformasNecesarias;
	}

	public Boolean getBanyosReformasNecesarias() {
		return banyosReformasNecesarias;
	}

	public void setBanyosReformasNecesarias(Boolean banyosReformasNecesarias) {
		this.banyosReformasNecesarias = banyosReformasNecesarias;
	}

	public String getOtrasReformasNecesarias() {
		return otrasReformasNecesarias;
	}

	public void setOtrasReformasNecesarias(String otrasReformasNecesarias) {
		this.otrasReformasNecesarias = otrasReformasNecesarias;
	}

	public Double getOtrasReformasNecesariasImporteAproximado() {
		return otrasReformasNecesariasImporteAproximado;
	}

	public void setOtrasReformasNecesariasImporteAproximado(Double otrasReformasNecesariasImporteAproximado) {
		this.otrasReformasNecesariasImporteAproximado = otrasReformasNecesariasImporteAproximado;
	}

	public String getDistribucionInterior() {
		return distribucionInterior;
	}

	public void setDistribucionInterior(String distribucionInterior) {
		this.distribucionInterior = distribucionInterior;
	}

	public Boolean getDivisible() {
		return divisible;
	}

	public void setDivisible(Boolean divisible) {
		this.divisible = divisible;
	}

	public Boolean getAscensor() {
		return ascensor;
	}

	public void setAscensor(Boolean ascensor) {
		this.ascensor = ascensor;
	}

	public Integer getNumeroAscensores() {
		return numeroAscensores;
	}

	public void setNumeroAscensores(Integer numeroAscensores) {
		this.numeroAscensores = numeroAscensores;
	}

	public String getDescripcionPlantas() {
		return descripcionPlantas;
	}

	public void setDescripcionPlantas(String descripcionPlantas) {
		this.descripcionPlantas = descripcionPlantas;
	}

	public String getOtrasCaracteristicas() {
		return otrasCaracteristicas;
	}

	public void setOtrasCaracteristicas(String otrasCaracteristicas) {
		this.otrasCaracteristicas = otrasCaracteristicas;
	}

	public Boolean getFachadaReformasNecesarias() {
		return fachadaReformasNecesarias;
	}

	public void setFachadaReformasNecesarias(Boolean fachadaReformasNecesarias) {
		this.fachadaReformasNecesarias = fachadaReformasNecesarias;
	}

	public Boolean getEscaleraReformasNecesarias() {
		return escaleraReformasNecesarias;
	}

	public void setEscaleraReformasNecesarias(Boolean escaleraReformasNecesarias) {
		this.escaleraReformasNecesarias = escaleraReformasNecesarias;
	}

	public Boolean getPortalReformasNecesarias() {
		return portalReformasNecesarias;
	}

	public void setPortalReformasNecesarias(Boolean portalReformasNecesarias) {
		this.portalReformasNecesarias = portalReformasNecesarias;
	}

	public Boolean getAscensorReformasNecesarias() {
		return ascensorReformasNecesarias;
	}

	public void setAscensorReformasNecesarias(Boolean ascensorReformasNecesarias) {
		this.ascensorReformasNecesarias = ascensorReformasNecesarias;
	}

	public Boolean getCubierta() {
		return cubierta;
	}

	public void setCubierta(Boolean cubierta) {
		this.cubierta = cubierta;
	}

	public Boolean getOtrasZonasComunesReformasNecesarias() {
		return otrasZonasComunesReformasNecesarias;
	}

	public void setOtrasZonasComunesReformasNecesarias(Boolean otrasZonasComunesReformasNecesarias) {
		this.otrasZonasComunesReformasNecesarias = otrasZonasComunesReformasNecesarias;
	}

	public String getOtrosReformasNecesarias() {
		return otrosReformasNecesarias;
	}

	public void setOtrosReformasNecesarias(String otrosReformasNecesarias) {
		this.otrosReformasNecesarias = otrosReformasNecesarias;
	}

	public String getDescripcionEdificio() {
		return descripcionEdificio;
	}

	public void setDescripcionEdificio(String descripcionEdificio) {
		this.descripcionEdificio = descripcionEdificio;
	}

	public String getInfraestructurasEntorno() {
		return infraestructurasEntorno;
	}

	public void setInfraestructurasEntorno(String infraestructurasEntorno) {
		this.infraestructurasEntorno = infraestructurasEntorno;
	}

	public String getComunicacionesEntorno() {
		return comunicacionesEntorno;
	}

	public void setComunicacionesEntorno(String comunicacionesEntorno) {
		this.comunicacionesEntorno = comunicacionesEntorno;
	}

	public String getIdoneoUso() {
		return idoneoUso;
	}

	public void setIdoneoUso(String idoneoUso) {
		this.idoneoUso = idoneoUso;
	}

	public Boolean getExisteAnteriorUso() {
		return existeAnteriorUso;
	}

	public void setExisteAnteriorUso(Boolean existeAnteriorUso) {
		this.existeAnteriorUso = existeAnteriorUso;
	}

	public String getAnteriorUso() {
		return anteriorUso;
	}

	public void setAnteriorUso(String anteriorUso) {
		this.anteriorUso = anteriorUso;
	}

	public Long getNumeroEstancias() {
		return numeroEstancias;
	}

	public void setNumeroEstancias(Long numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}

	public Long getNumeroBanyos() {
		return numeroBanyos;
	}

	public void setNumeroBanyos(Long numeroBanyos) {
		this.numeroBanyos = numeroBanyos;
	}

	public long getNumeroAseos() {
		return numeroAseos;
	}

	public void setNumeroAseos(long numeroAseos) {
		this.numeroAseos = numeroAseos;
	}

	public Float getMetrosLinealesFachadaPrincipal() {
		return metrosLinealesFachadaPrincipal;
	}

	public void setMetrosLinealesFachadaPrincipal(Float metrosLinealesFachadaPrincipal) {
		this.metrosLinealesFachadaPrincipal = metrosLinealesFachadaPrincipal;
	}

	public Float getAltura() {
		return altura;
	}

	public void setAltura(Float altura) {
		this.altura = altura;
	}

	public Long getNumeroPlazasGaraje() {
		return numeroPlazasGaraje;
	}

	public void setNumeroPlazasGaraje(Long numeroPlazasGaraje) {
		this.numeroPlazasGaraje = numeroPlazasGaraje;
	}

	public Float getSuperficiePlazasGaraje() {
		return superficiePlazasGaraje;
	}

	public void setSuperficiePlazasGaraje(Float superficiePlazasGaraje) {
		this.superficiePlazasGaraje = superficiePlazasGaraje;
	}

	public String getCodSubtipoPlazasGaraje() {
		return codSubtipoPlazasGaraje;
	}

	public void setCodSubtipoPlazasGaraje(String codSubtipoPlazasGaraje) {
		this.codSubtipoPlazasGaraje = codSubtipoPlazasGaraje;
	}

	public Boolean getSalidaHumosOtrasCaracteristicas() {
		return salidaHumosOtrasCaracteristicas;
	}

	public void setSalidaHumosOtrasCaracteristicas(Boolean salidaHumosOtrasCaracteristicas) {
		this.salidaHumosOtrasCaracteristicas = salidaHumosOtrasCaracteristicas;
	}

	public Boolean getSalidaEmergenciaOtrasCaracteristicas() {
		return salidaEmergenciaOtrasCaracteristicas;
	}

	public void setSalidaEmergenciaOtrasCaracteristicas(Boolean salidaEmergenciaOtrasCaracteristicas) {
		this.salidaEmergenciaOtrasCaracteristicas = salidaEmergenciaOtrasCaracteristicas;
	}

	public Boolean getAccesoMinusvalidosOtrasCaracteristicas() {
		return accesoMinusvalidosOtrasCaracteristicas;
	}

	public void setAccesoMinusvalidosOtrasCaracteristicas(Boolean accesoMinusvalidosOtrasCaracteristicas) {
		this.accesoMinusvalidosOtrasCaracteristicas = accesoMinusvalidosOtrasCaracteristicas;
	}

	public String getOtrosOtrasCaracteristicas() {
		return otrosOtrasCaracteristicas;
	}

	public void setOtrosOtrasCaracteristicas(String otrosOtrasCaracteristicas) {
		this.otrosOtrasCaracteristicas = otrosOtrasCaracteristicas;
	}

	public String getCodTipoVario() {
		return codTipoVario;
	}

	public void setCodTipoVario(String codTipoVario) {
		this.codTipoVario = codTipoVario;
	}

	public Float getAncho() {
		return ancho;
	}

	public void setAncho(Float ancho) {
		this.ancho = ancho;
	}

	public Float getAlto() {
		return alto;
	}

	public void setAlto(Float alto) {
		this.alto = alto;
	}

	public Float getLargo() {
		return largo;
	}

	public void setLargo(Float largo) {
		this.largo = largo;
	}

	public String getCodUso() {
		return codUso;
	}

	public void setCodUso(String codUso) {
		this.codUso = codUso;
	}

	public String getCodManiobrabilidad() {
		return codManiobrabilidad;
	}

	public void setCodManiobrabilidad(String codManiobrabilidad) {
		this.codManiobrabilidad = codManiobrabilidad;
	}

	public Boolean getLicenciaOtrasCaracteristicas() {
		return licenciaOtrasCaracteristicas;
	}

	public void setLicenciaOtrasCaracteristicas(Boolean licenciaOtrasCaracteristicas) {
		this.licenciaOtrasCaracteristicas = licenciaOtrasCaracteristicas;
	}

	public Boolean getServidumbreOtrasCaracteristicas() {
		return servidumbreOtrasCaracteristicas;
	}

	public void setServidumbreOtrasCaracteristicas(Boolean servidumbreOtrasCaracteristicas) {
		this.servidumbreOtrasCaracteristicas = servidumbreOtrasCaracteristicas;
	}

	public Boolean getAscensorOMontacargasOtrasCaracteristicas() {
		return ascensorOMontacargasOtrasCaracteristicas;
	}

	public void setAscensorOMontacargasOtrasCaracteristicas(Boolean ascensorOMontacargasOtrasCaracteristicas) {
		this.ascensorOMontacargasOtrasCaracteristicas = ascensorOMontacargasOtrasCaracteristicas;
	}

	public Boolean getColumnasOtrasCaracteristicas() {
		return columnasOtrasCaracteristicas;
	}

	public void setColumnasOtrasCaracteristicas(Boolean columnasOtrasCaracteristicas) {
		this.columnasOtrasCaracteristicas = columnasOtrasCaracteristicas;
	}

	public Boolean getSeguridadOtrasCaracteristicas() {
		return seguridadOtrasCaracteristicas;
	}

	public void setSeguridadOtrasCaracteristicas(Boolean seguridadOtrasCaracteristicas) {
		this.seguridadOtrasCaracteristicas = seguridadOtrasCaracteristicas;
	}

	public Boolean getBuenEstadoInstalacionElectricidadInstalaciones() {
		return buenEstadoInstalacionElectricidadInstalaciones;
	}

	public void setBuenEstadoInstalacionElectricidadInstalaciones(
			Boolean buenEstadoInstalacionElectricidadInstalaciones) {
		this.buenEstadoInstalacionElectricidadInstalaciones = buenEstadoInstalacionElectricidadInstalaciones;
	}

	public Boolean getBuenEstadoContadorElectricidadInstalaciones() {
		return buenEstadoContadorElectricidadInstalaciones;
	}

	public void setBuenEstadoContadorElectricidadInstalaciones(Boolean buenEstadoContadorElectricidadInstalaciones) {
		this.buenEstadoContadorElectricidadInstalaciones = buenEstadoContadorElectricidadInstalaciones;
	}

	public Boolean getBuenEstadoInstalacionAguaInstalaciones() {
		return buenEstadoInstalacionAguaInstalaciones;
	}

	public void setBuenEstadoInstalacionAguaInstalaciones(Boolean buenEstadoInstalacionAguaInstalaciones) {
		this.buenEstadoInstalacionAguaInstalaciones = buenEstadoInstalacionAguaInstalaciones;
	}

	public Boolean getBuenEstadoContadorAguaInstalaciones() {
		return buenEstadoContadorAguaInstalaciones;
	}

	public void setBuenEstadoContadorAguaInstalaciones(Boolean buenEstadoContadorAguaInstalaciones) {
		this.buenEstadoContadorAguaInstalaciones = buenEstadoContadorAguaInstalaciones;
	}

	public Boolean getBuenEstadoGasInstalaciones() {
		return buenEstadoGasInstalaciones;
	}

	public void setBuenEstadoGasInstalaciones(Boolean buenEstadoGasInstalaciones) {
		this.buenEstadoGasInstalaciones = buenEstadoGasInstalaciones;
	}

	public Boolean getBuenEstadoContadorGasInstalacion() {
		return buenEstadoContadorGasInstalacion;
	}

	public void setBuenEstadoContadorGasInstalacion(Boolean buenEstadoContadorGasInstalacion) {
		this.buenEstadoContadorGasInstalacion = buenEstadoContadorGasInstalacion;
	}

	
	public String getCodEstadoConservacionEdificio() {
		return codEstadoConservacionEdificio;
	}

	public void setCodEstadoConservacionEdificio(String codEstadoConservacionEdificio) {
		this.codEstadoConservacionEdificio = codEstadoConservacionEdificio;
	}

	public Date getAnyoRehabilitacionEdificio() {
		return anyoRehabilitacionEdificio;
	}

	public void setAnyoRehabilitacionEdificio(Date anyoRehabilitacionEdificio) {
		this.anyoRehabilitacionEdificio = anyoRehabilitacionEdificio;
	}

	public Long getNumeroPlantasEdificio() {
		return numeroPlantasEdificio;
	}

	public void setNumeroPlantasEdificio(Long numeroPlantasEdificio) {
		this.numeroPlantasEdificio = numeroPlantasEdificio;
	}

	public Boolean getAscensorEdificio() {
		return ascensorEdificio;
	}

	public void setAscensorEdificio(Boolean ascensorEdificio) {
		this.ascensorEdificio = ascensorEdificio;
	}

	public Integer getNumeroAscensoresEdificio() {
		return numeroAscensoresEdificio;
	}

	public void setNumeroAscensoresEdificio(Integer numeroAscensoresEdificio) {
		this.numeroAscensoresEdificio = numeroAscensoresEdificio;
	}

	public Boolean getExisteComunidadEdificio() {
		return existeComunidadEdificio;
	}

	public void setExisteComunidadEdificio(Boolean existeComunidadEdificio) {
		this.existeComunidadEdificio = existeComunidadEdificio;
	}

	public Float getCuotaComunidadEdificio() {
		return cuotaComunidadEdificio;
	}

	public void setCuotaComunidadEdificio(Float cuotaComunidadEdificio) {
		this.cuotaComunidadEdificio = cuotaComunidadEdificio;
	}

	public String getNombrePresidenteComunidadEdificio() {
		return nombrePresidenteComunidadEdificio;
	}

	public void setNombrePresidenteComunidadEdificio(String nombrePresidenteComunidadEdificio) {
		this.nombrePresidenteComunidadEdificio = nombrePresidenteComunidadEdificio;
	}

	public String getTelefonoPresidenteComunidadEdificio() {
		return telefonoPresidenteComunidadEdificio;
	}

	public void setTelefonoPresidenteComunidadEdificio(String telefonoPresidenteComunidadEdificio) {
		this.telefonoPresidenteComunidadEdificio = telefonoPresidenteComunidadEdificio;
	}

	public String getNombreAdministradorComunidadEdificio() {
		return nombreAdministradorComunidadEdificio;
	}

	public void setNombreAdministradorComunidadEdificio(String nombreAdministradorComunidadEdificio) {
		this.nombreAdministradorComunidadEdificio = nombreAdministradorComunidadEdificio;
	}

	public String getTelefonoAdministradorComunidadEdificio() {
		return telefonoAdministradorComunidadEdificio;
	}

	public void setTelefonoAdministradorComunidadEdificio(String telefonoAdministradorComunidadEdificio) {
		this.telefonoAdministradorComunidadEdificio = telefonoAdministradorComunidadEdificio;
	}

	public String getDescripcionDerramaComunidadEdificio() {
		return descripcionDerramaComunidadEdificio;
	}

	public void setDescripcionDerramaComunidadEdificio(String descripcionDerramaComunidadEdificio) {
		this.descripcionDerramaComunidadEdificio = descripcionDerramaComunidadEdificio;
	}

	public Boolean getAscensorReformasNecesariasEdificio() {
		return ascensorReformasNecesariasEdificio;
	}

	public void setAscensorReformasNecesariasEdificio(Boolean ascensorReformasNecesariasEdificio) {
		this.ascensorReformasNecesariasEdificio = ascensorReformasNecesariasEdificio;
	}

	public Boolean getCubiertaReformasNecesariasEdificio() {
		return cubiertaReformasNecesariasEdificio;
	}

	public void setCubiertaReformasNecesariasEdificio(Boolean cubiertaReformasNecesariasEdificio) {
		this.cubiertaReformasNecesariasEdificio = cubiertaReformasNecesariasEdificio;
	}

	public Boolean getOtrasZonasComunesReformasNecesariasEdificio() {
		return otrasZonasComunesReformasNecesariasEdificio;
	}

	public void setOtrasZonasComunesReformasNecesariasEdificio(Boolean otrasZonasComunesReformasNecesariasEdificio) {
		this.otrasZonasComunesReformasNecesariasEdificio = otrasZonasComunesReformasNecesariasEdificio;
	}

	public String getOtrosReformasNecesariasEdificio() {
		return otrosReformasNecesariasEdificio;
	}

	public void setOtrosReformasNecesariasEdificio(String otrosReformasNecesariasEdificio) {
		this.otrosReformasNecesariasEdificio = otrosReformasNecesariasEdificio;
	}

	public String getInfraestructurasEntornoEdificio() {
		return infraestructurasEntornoEdificio;
	}

	public void setInfraestructurasEntornoEdificio(String infraestructurasEntornoEdificio) {
		this.infraestructurasEntornoEdificio = infraestructurasEntornoEdificio;
	}

	public String getComunicacionesEntornoEdificio() {
		return comunicacionesEntornoEdificio;
	}

	public void setComunicacionesEntornoEdificio(String comunicacionesEntornoEdificio) {
		this.comunicacionesEntornoEdificio = comunicacionesEntornoEdificio;
	}

	public Boolean getExisteOcio() {
		return existeOcio;
	}

	public void setExisteOcio(Boolean existeOcio) {
		this.existeOcio = existeOcio;
	}

	public Boolean getExistenHoteles() {
		return existenHoteles;
	}

	public void setExistenHoteles(Boolean existenHoteles) {
		this.existenHoteles = existenHoteles;
	}

	public String getHoteles() {
		return hoteles;
	}

	public void setHoteles(String hoteles) {
		this.hoteles = hoteles;
	}

	public Boolean getExistenTeatros() {
		return existenTeatros;
	}

	public void setExistenTeatros(Boolean existenTeatros) {
		this.existenTeatros = existenTeatros;
	}

	public String getTeatros() {
		return teatros;
	}

	public void setTeatros(String teatros) {
		this.teatros = teatros;
	}

	public Boolean getExistenSalasDeCine() {
		return existenSalasDeCine;
	}

	public void setExistenSalasDeCine(Boolean existenSalasDeCine) {
		this.existenSalasDeCine = existenSalasDeCine;
	}

	public String getSalasDeCine() {
		return salasDeCine;
	}

	public void setSalasDeCine(String salasDeCine) {
		this.salasDeCine = salasDeCine;
	}

	public Boolean getExistenInstalacionesDeportivas() {
		return existenInstalacionesDeportivas;
	}

	public void setExistenInstalacionesDeportivas(Boolean existenInstalacionesDeportivas) {
		this.existenInstalacionesDeportivas = existenInstalacionesDeportivas;
	}

	public String getInstalacionesDeportivas() {
		return instalacionesDeportivas;
	}

	public void setInstalacionesDeportivas(String instalacionesDeportivas) {
		this.instalacionesDeportivas = instalacionesDeportivas;
	}

	public Boolean getExistenCentrosComerciales() {
		return existenCentrosComerciales;
	}

	public void setExistenCentrosComerciales(Boolean existenCentrosComerciales) {
		this.existenCentrosComerciales = existenCentrosComerciales;
	}

	public String getCentrosComerciales() {
		return centrosComerciales;
	}

	public void setCentrosComerciales(String centrosComerciales) {
		this.centrosComerciales = centrosComerciales;
	}

	public String getOtrosOcio() {
		return otrosOcio;
	}

	public void setOtrosOcio(String otrosOcio) {
		this.otrosOcio = otrosOcio;
	}

	public Boolean getExistenCentrosEducativos() {
		return existenCentrosEducativos;
	}

	public void setExistenCentrosEducativos(Boolean existenCentrosEducativos) {
		this.existenCentrosEducativos = existenCentrosEducativos;
	}

	public Boolean getExistenEscuelasInfantiles() {
		return existenEscuelasInfantiles;
	}

	public void setExistenEscuelasInfantiles(Boolean existenEscuelasInfantiles) {
		this.existenEscuelasInfantiles = existenEscuelasInfantiles;
	}

	public String getEscuelasInfantiles() {
		return escuelasInfantiles;
	}

	public void setEscuelasInfantiles(String escuelasInfantiles) {
		this.escuelasInfantiles = escuelasInfantiles;
	}

	public Boolean getExistenColegios() {
		return existenColegios;
	}

	public void setExistenColegios(Boolean existenColegios) {
		this.existenColegios = existenColegios;
	}

	public String getColegios() {
		return colegios;
	}

	public void setColegios(String colegios) {
		this.colegios = colegios;
	}

	public Boolean getExistenInstitutos() {
		return existenInstitutos;
	}

	public void setExistenInstitutos(Boolean existenInstitutos) {
		this.existenInstitutos = existenInstitutos;
	}

	public String getInstitutos() {
		return institutos;
	}

	public void setInstitutos(String institutos) {
		this.institutos = institutos;
	}

	public Boolean getExistenUniversidades() {
		return existenUniversidades;
	}

	public void setExistenUniversidades(Boolean existenUniversidades) {
		this.existenUniversidades = existenUniversidades;
	}

	public String getUniversidades() {
		return universidades;
	}

	public void setUniversidades(String universidades) {
		this.universidades = universidades;
	}

	public String getOtrosCentrosEducativos() {
		return otrosCentrosEducativos;
	}

	public void setOtrosCentrosEducativos(String otrosCentrosEducativos) {
		this.otrosCentrosEducativos = otrosCentrosEducativos;
	}

	public Boolean getExistenCentrosSanitarios() {
		return existenCentrosSanitarios;
	}

	public void setExistenCentrosSanitarios(Boolean existenCentrosSanitarios) {
		this.existenCentrosSanitarios = existenCentrosSanitarios;
	}

	public Boolean getExistenCentrosDeSalud() {
		return existenCentrosDeSalud;
	}

	public void setExistenCentrosDeSalud(Boolean existenCentrosDeSalud) {
		this.existenCentrosDeSalud = existenCentrosDeSalud;
	}

	public String getCentrosDeSalud() {
		return centrosDeSalud;
	}

	public void setCentrosDeSalud(String centrosDeSalud) {
		this.centrosDeSalud = centrosDeSalud;
	}

	public Boolean getExistenClinicas() {
		return existenClinicas;
	}

	public void setExistenClinicas(Boolean existenClinicas) {
		this.existenClinicas = existenClinicas;
	}

	public String getClinicas() {
		return clinicas;
	}

	public void setClinicas(String clinicas) {
		this.clinicas = clinicas;
	}

	public Boolean getExistenHospitales() {
		return existenHospitales;
	}

	public void setExistenHospitales(Boolean existenHospitales) {
		this.existenHospitales = existenHospitales;
	}

	public String getHospitales() {
		return hospitales;
	}

	public void setHospitales(String hospitales) {
		this.hospitales = hospitales;
	}

	public Boolean getExistenOtrosCentrosSanitarios() {
		return existenOtrosCentrosSanitarios;
	}

	public void setExistenOtrosCentrosSanitarios(Boolean existenOtrosCentrosSanitarios) {
		this.existenOtrosCentrosSanitarios = existenOtrosCentrosSanitarios;
	}

	public String getOtrosCentrosSanitarios() {
		return otrosCentrosSanitarios;
	}

	public void setOtrosCentrosSanitarios(String otrosCentrosSanitarios) {
		this.otrosCentrosSanitarios = otrosCentrosSanitarios;
	}

	public Boolean getExistenComunicaciones() {
		return existenComunicaciones;
	}

	public void setExistenComunicaciones(Boolean existenComunicaciones) {
		this.existenComunicaciones = existenComunicaciones;
	}

	public Boolean getExisteFacilAccesoPorCarretera() {
		return existeFacilAccesoPorCarretera;
	}

	public void setExisteFacilAccesoPorCarretera(Boolean existeFacilAccesoPorCarretera) {
		this.existeFacilAccesoPorCarretera = existeFacilAccesoPorCarretera;
	}

	public Boolean getExisteLineasDeAutobus() {
		return existeLineasDeAutobus;
	}

	public void setExisteLineasDeAutobus(Boolean existeLineasDeAutobus) {
		this.existeLineasDeAutobus = existeLineasDeAutobus;
	}

	public String getLineasDeAutobus() {
		return lineasDeAutobus;
	}

	public void setLineasDeAutobus(String lineasDeAutobus) {
		this.lineasDeAutobus = lineasDeAutobus;
	}

	public Boolean getExisteMetro() {
		return existeMetro;
	}

	public void setExisteMetro(Boolean existeMetro) {
		this.existeMetro = existeMetro;
	}

	public String getMetro() {
		return metro;
	}

	public void setMetro(String metro) {
		this.metro = metro;
	}

	public Boolean getExisteEstacionesDeTren() {
		return existeEstacionesDeTren;
	}

	public void setExisteEstacionesDeTren(Boolean existeEstacionesDeTren) {
		this.existeEstacionesDeTren = existeEstacionesDeTren;
	}

	public String getEstacionesDeTren() {
		return estacionesDeTren;
	}

	public void setEstacionesDeTren(String estacionesDeTren) {
		this.estacionesDeTren = estacionesDeTren;
	}

	public String getCodSubtipoInmueble() {
		return codSubtipoInmueble;
	}

	public void setCodSubtipoInmueble(String codSubtipoInmueble) {
		this.codSubtipoInmueble = codSubtipoInmueble;
	}

	public void setCodTipoVivienda(String codTipoVivienda) {
		this.codTipoVivienda = codTipoVivienda;
	}

	public Boolean getFachadaReformasNecesariasEdificio() {
		return fachadaReformasNecesariasEdificio;
	}

	public void setFachadaReformasNecesariasEdificio(Boolean fachadaReformasNecesariasEdificio) {
		this.fachadaReformasNecesariasEdificio = fachadaReformasNecesariasEdificio;
	}

	public String getEscaleraReformasNecesariasEdificio() {
		return escaleraReformasNecesariasEdificio;
	}

	public void setEscaleraReformasNecesariasEdificio(String escaleraReformasNecesariasEdificio) {
		this.escaleraReformasNecesariasEdificio = escaleraReformasNecesariasEdificio;
	}

	public Boolean getPortalReformasNecesariasEdificio() {
		return portalReformasNecesariasEdificio;
	}

	public void setPortalReformasNecesariasEdificio(Boolean portalReformasNecesariasEdificio) {
		this.portalReformasNecesariasEdificio = portalReformasNecesariasEdificio;
	}

	public Boolean getSuficienteAparcamientoEnSuperficie() {
		return suficienteAparcamientoEnSuperficie;
	}

	public void setSuficienteAparcamientoEnSuperficie(Boolean suficienteAparcamientoEnSuperficie) {
		this.suficienteAparcamientoEnSuperficie = suficienteAparcamientoEnSuperficie;
	}

	public String getOtrosComunicaciones() {
		return otrosComunicaciones;
	}

	public void setOtrosComunicaciones(String otrosComunicaciones) {
		this.otrosComunicaciones = otrosComunicaciones;
	}

	public Boolean getBuenEstadoPuertaEntradaNormal() {
		return buenEstadoPuertaEntradaNormal;
	}

	public void setBuenEstadoPuertaEntradaNormal(Boolean buenEstadoPuertaEntradaNormal) {
		this.buenEstadoPuertaEntradaNormal = buenEstadoPuertaEntradaNormal;
	}

	public Boolean getBuenEstadoPuertaEntradaBlindada() {
		return buenEstadoPuertaEntradaBlindada;
	}

	public void setBuenEstadoPuertaEntradaBlindada(Boolean buenEstadoPuertaEntradaBlindada) {
		this.buenEstadoPuertaEntradaBlindada = buenEstadoPuertaEntradaBlindada;
	}

	public Boolean getBuenEstadoPuertaEntradaAcorazada() {
		return buenEstadoPuertaEntradaAcorazada;
	}

	public void setBuenEstadoPuertaEntradaAcorazada(Boolean buenEstadoPuertaEntradaAcorazada) {
		this.buenEstadoPuertaEntradaAcorazada = buenEstadoPuertaEntradaAcorazada;
	}

	public Boolean getBuenEstadoPuertaPasoMaciza() {
		return buenEstadoPuertaPasoMaciza;
	}

	public void setBuenEstadoPuertaPasoMaciza(Boolean buenEstadoPuertaPasoMaciza) {
		this.buenEstadoPuertaPasoMaciza = buenEstadoPuertaPasoMaciza;
	}

	public Boolean getBuenEstadoPuertaPasoHueca() {
		return buenEstadoPuertaPasoHueca;
	}

	public void setBuenEstadoPuertaPasoHueca(Boolean buenEstadoPuertaPasoHueca) {
		this.buenEstadoPuertaPasoHueca = buenEstadoPuertaPasoHueca;
	}

	public Boolean getBuenEstadoPuertaPasoLacada() {
		return buenEstadoPuertaPasoLacada;
	}

	public void setBuenEstadoPuertaPasoLacada(Boolean buenEstadoPuertaPasoLacada) {
		this.buenEstadoPuertaPasoLacada = buenEstadoPuertaPasoLacada;
	}

	public Boolean getExistenArmariosEmpotrados() {
		return existenArmariosEmpotrados;
	}

	public void setExistenArmariosEmpotrados(Boolean existenArmariosEmpotrados) {
		this.existenArmariosEmpotrados = existenArmariosEmpotrados;
	}

	public String getCodAcabadoCarpinteria() {
		return codAcabadoCarpinteria;
	}

	public void setCodAcabadoCarpinteria(String codAcabadoCarpinteria) {
		this.codAcabadoCarpinteria = codAcabadoCarpinteria;
	}

	public String getOtrosCarpinteriaInterior() {
		return otrosCarpinteriaInterior;
	}

	public void setOtrosCarpinteriaInterior(String otrosCarpinteriaInterior) {
		this.otrosCarpinteriaInterior = otrosCarpinteriaInterior;
	}
	
	

}
