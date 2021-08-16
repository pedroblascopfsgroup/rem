package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDAcabadoCarpinteria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoPlazaGaraje;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOrientacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSiniSiNoIndiferente;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TRANSFORM_TYPE;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class InformeMediadorDto implements Serializable {

	@EntityDefinition(procesar = false)
	private static final long serialVersionUID = 1L;

	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "idWebcom")
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
	
	//Guarda idProveedorRem como mediador del activo
	//@NotNull(groups = { Insert.class, Update.class })
 	@Diccionary(clase = ActivoProveedor.class, foreingField="codigoProveedorRem",message = "El idProveedorRem no existe", groups = { Insert.class,
 			Update.class })
 	@EntityDefinition(procesar = false)
 	//@EntityDefinition(propertyName = "mediadorInforme", classObj = ActivoProveedor.class, foreingField = "codigoProveedorRem")
	private Long idProveedorRem;
 	
	@EntityDefinition(procesar = false)
	@Diccionary(clase = ActivoProveedor.class, foreingField="codigoProveedorRem",message = "El idProveedorRemAnterior no existe", groups = { Insert.class,
		Update.class })
	private Long idProveedorRemAnterior;
	
	@EntityDefinition(propertyName = "posibleInforme" ,transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean posibleInforme;

	@EntityDefinition(propertyName = "motivoNoPosibleInforme")
	private String motivoNoPosibleInforme;

	//@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoVivienda.class, message = "El codTipoVivienda de activo no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "tipoVivienda", classObj = DDTipoVivienda.class)
	private String codTipoVivienda;

	// ok
	@NotNull(groups = Insert.class)
	private Date fechaUltimaVisita;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoVia.class, message = "El codTipoVia de activo no existe", groups = { Insert.class,
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
	@Size(max=100,groups = { Insert.class, Update.class })
	private String zona;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDUbicacionActivo.class, message = "El codUbicacion no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "ubicacionActivo", classObj = DDUbicacionActivo.class)
	private String codUbicacion;

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

	@NotNull(groups = Insert.class)
	@Diccionary(clase = Localidad.class, message = "El codMunicipioRegistro no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "localidadRegistro", classObj = Localidad.class)
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
	@EntityDefinition(propertyName = "tipoGradoPropiedad", classObj = DDTipoGradoPropiedad.class)
	private String codTipoPropiedad;

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

	@Diccionary(clase = DDEstadoConservacion.class, message = "El codEstadoConservacion no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "estadoConservacion", classObj = DDEstadoConservacion.class)
	private String codEstadoConservacion;

	// ok
	@EntityDefinition(propertyName = "anyoConstruccion")
	private Integer anyoConstruccion;

	@EntityDefinition(propertyName = "anyoRehabilitacion")
	private Integer anyoRehabilitacion;

	@EntityDefinition(propertyName = "ultimaPlanta", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean ultimaPlanta;

	@EntityDefinition(propertyName = "ocupado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
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

	// lo procesamos de forma no generica
	@EntityDefinition(procesar = false)
	private List<PlantaDto> plantas;

	private Integer numeroTerrazasDescubiertas;

	private String descripcionTerrazasDescubiertas;

	private Integer numeroTerrazasCubiertas;

	private String descripcionTerrazasCubiertas;

	@EntityDefinition(propertyName = "despensaOtrasDependencias", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean despensaOtrasDependencias;

	@EntityDefinition(propertyName = "lavaderoOtrasDependencias", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean lavaderoOtrasDependencias;

	@EntityDefinition(propertyName = "azoteaOtrasDependencias", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
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
	@Size(max=3000,groups = { Insert.class, Update.class })
	private String distribucionInterior;

	@EntityDefinition(propertyName = "edificioDivisible")
	private Boolean divisible;

	@EntityDefinition(propertyName = "ascensor", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean ascensor;

	@EntityDefinition(propertyName = "numAscensores")
	private Integer numeroAscensores;

	@EntityDefinition(propertyName = "edificioDescPlantas")
	private String descripcionPlantas;

	@EntityDefinition(propertyName = "edificioOtrasCaracteristicas")
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

	@EntityDefinition(propertyName = "entornoComunicacion")
	private String comunicacionesEntorno;

	@EntityDefinition(propertyName = "usuIdoneo")
	private String idoneoUso;

	@EntityDefinition(procesar = false)
	private Boolean existeAnteriorUso;

	@EntityDefinition(propertyName = "usuAnterior")
	private String anteriorUso;

	@EntityDefinition(propertyName = "comercialNumEstancias")
	private Integer numeroEstancias;

	@EntityDefinition(propertyName = "comercialNumBanyos")
	private Integer numeroBanyos;

	@EntityDefinition(propertyName = "comercialNumAseos")
	private Integer numeroAseos;

	@EntityDefinition(propertyName = "mtsFachadaPpal")
	private Float metrosLinealesFachadaPrincipal;

	//@EntityDefinition(propertyName = "mtsAlturaLibre")
	@EntityDefinition(procesar = false)
	private Float altura;

	@Diccionary(clase = DDSubtipoPlazaGaraje.class, message = "El codSubtipoPlazasGaraje no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "subTipo", classObj = DDSubtipoPlazaGaraje.class)
	private String codSubtipoPlazasGaraje;

	@EntityDefinition(propertyName = "existeSalidaHumos", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean salidaHumosOtrasCaracteristicas;

	@EntityDefinition(propertyName = "existeSalidaEmergencias", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean salidaEmergenciaOtrasCaracteristicas;

	@EntityDefinition(propertyName = "existeAccesoMinusvalidos", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean accesoMinusvalidosOtrasCaracteristicas;

	@EntityDefinition(propertyName = "otrosOtrasCaracteristicas")
	private String otrosOtrasCaracteristicas;

	@Diccionary(clase = DDTipoVivienda.class, message = "El codTipoVario no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "aparcamientoTipoVario", classObj = DDTipoVivienda.class)
	private String codTipoVario;

	@EntityDefinition(propertyName = "anchura")
	private Float ancho;

	//@EntityDefinition(propertyName = "aparcamientoAltura")
	@EntityDefinition(procesar = false)
	private Float alto;

	@EntityDefinition(propertyName = "profundidad")
	private Float largo;

	@Diccionary(clase = DDSubtipoPlazaGaraje.class, message = "El codUso no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "subtipoPlazagaraje", classObj = DDSubtipoPlazaGaraje.class)
	private String codUso;

	@Diccionary(clase = DDTipoCalidad.class, message = "El codNivelRenta no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "tipoCalidad", classObj = DDTipoCalidad.class)
	private String codManiobrabilidad;

	@EntityDefinition(propertyName = "aparcamientoLicencia", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean licenciaOtrasCaracteristicas;

	@EntityDefinition(propertyName = "aparcamientoSerbidumbre", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean servidumbreOtrasCaracteristicas;

	@EntityDefinition(propertyName = "aparcamientoMontacarga", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean ascensorOMontacargasOtrasCaracteristicas;

	@EntityDefinition(propertyName = "aparcamientoColumnas", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean columnasOtrasCaracteristicas;

	@EntityDefinition(propertyName = "aparcamientoSeguridad", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean seguridadOtrasCaracteristicas;

	@EntityDefinition(propertyName = "electricidadBuenEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoInstalacionElectricidadInstalaciones;

	@EntityDefinition(propertyName = "electricidadConContador", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoContadorElectricidadInstalaciones;

	@EntityDefinition(propertyName = "aguaBuenEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoInstalacionAguaInstalaciones;

	@EntityDefinition(propertyName = "aguaConContador", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoContadorAguaInstalaciones;

	@EntityDefinition(propertyName = "gasBuenEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoInstalacionGasInstalaciones;

	@EntityDefinition(propertyName = "gasConContador", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoContadorGasInstalaciones;

	@Diccionary(clase = DDEstadoConservacion.class, message = "El codEstadoConservacionEdificio no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "estadoConservacionEdificio", classObj = DDEstadoConservacion.class)
	private String codEstadoConservacionEdificio;

	@EntityDefinition(propertyName = "anyoRehabilitacionEdificio")
	private Integer anyoRehabilitacionEdificio;

	@EntityDefinition(propertyName = "numPlantas")
	private Integer numeroPlantasEdificio;

	@EntityDefinition(propertyName = "ascensorEdificio", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean ascensorEdificio;

	@EntityDefinition(propertyName = "numAscensores")
	private Integer numeroAscensoresEdificio;

	@EntityDefinition(propertyName = "existeComunidadEdificio", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean existeComunidadEdificio;

	@EntityDefinition(propertyName = "cuotaOrientativaComunidad")
	private Float cuotaComunidadEdificio;

	private String nombrePresidenteComunidadEdificio;

	private String telefonoPresidenteComunidadEdificio;

	private String nombreAdministradorComunidadEdificio;

	private String telefonoAdministradorComunidadEdificio;

	@EntityDefinition(propertyName = "reformaFachada")
	private Boolean fachadaReformasNecesariasEdificio;

	@EntityDefinition(propertyName = "reformaEscalera", procesar = false)
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

	@Diccionary(clase = DDAcabadoCarpinteria.class, message = "El codAcabadoCarpinteria no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "acabadoCarpinteria", classObj = DDAcabadoCarpinteria.class)
	private String codAcabadoCarpinteria;

	@EntityDefinition(propertyName = "carpinteriaInteriorOtros")
	private String otrosCarpinteriaInterior;

	@EntityDefinition(propertyName = "ventanasHierro", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoVentanaHierro;

	@EntityDefinition(propertyName = "ventanasAluAnodizado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoVentanaAnodizado;

	@EntityDefinition(propertyName = "ventanasAluLacado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoVentanaLacado;

	@EntityDefinition(propertyName = "ventanasPVC", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoVentanaPvc;

	@EntityDefinition(propertyName = "ventanasMadera", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoVentanaMadera;

	@EntityDefinition(propertyName = "persianasPlatico", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoPersianaPlastico;

	@EntityDefinition(propertyName = "persianasAluminio", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoPersianaAluminio;

	@EntityDefinition(propertyName = "ventanasCorrederas", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoAperturaVentanaCorrederas;

	@EntityDefinition(propertyName = "ventanasAbatibles", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoAperturaVentanaAbatibles;

	@EntityDefinition(propertyName = "ventanasOscilobatientes", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoAperturaVentanaOscilobat;

	@EntityDefinition(propertyName = "dobleCristal", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	private Boolean buenEstadoDobleAcristalamientoOClimalit;

	@EntityDefinition(propertyName = "carpinteriaExteriorOtros")
	private String otrosCarpinteriaExterior;

	@EntityDefinition(propertyName = "humedadPared", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean humedadesPared;

	@EntityDefinition(propertyName = "humedadTecho", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean humedadesTecho;

	@EntityDefinition(propertyName = "grietaPared", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean grietasPared;

	@EntityDefinition(propertyName = "grietoTecho", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean grietasTecho;

	@EntityDefinition(propertyName = "gotele", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPinturaParedesGotele;

	@EntityDefinition(propertyName = "plasticaLisa", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPinturaParedesLisa;

	@EntityDefinition(propertyName = "papelPintado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPinturaParedesPintado;

	@EntityDefinition(propertyName = "pinturaTechoGoteleEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPinturaTechoGotele;

	@EntityDefinition(propertyName = "pinturaLisaTechoEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPinturaTechoLisa;

	@EntityDefinition(propertyName = "pinturaTechoPapelEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPinturaTechoPintado;

	@EntityDefinition(propertyName = "molduraEscayolaEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoMolduraEscayola;

	@EntityDefinition(propertyName = "paramentosOtros")
	public String otrosParamentosVerticales;

	@EntityDefinition(propertyName = "tarimaFlotante", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoTarimaFlotanteSolados;

	@EntityDefinition(propertyName = "parque", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoParqueSolados;

	@EntityDefinition(propertyName = "soladoMarmol", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoMarmolSolados;

	@EntityDefinition(propertyName = "plaqueta", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoPlaquetaSolados;

	@EntityDefinition(propertyName = "soladoOtros")
	public String otrosSolados;

	@EntityDefinition(propertyName = "estadoAmueblada", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoCocinaAmuebladaCocina;

	@EntityDefinition(propertyName = "encimeraGranito", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoEncimeraGranitoCocina;

	@EntityDefinition(propertyName = "encimeraMarmol", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoEncimeraMarmolCocina;

	@EntityDefinition(propertyName = "encimeraOtroMaterial", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoEncimeraMaterialCocina;

	@EntityDefinition(propertyName = "vitro", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoVitroceramicaCocina;

	@EntityDefinition(propertyName = "lavadora", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoLavadoraCocina;

	@EntityDefinition(propertyName = "frigorifico", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoFrigorificoCocina;

	@EntityDefinition(propertyName = "lavavajillas", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoLavavajillasCocina;

	@EntityDefinition(propertyName = "microondas", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoMicroondasCocina;

	@EntityDefinition(propertyName = "horno", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoHornoCocina;

	@EntityDefinition(propertyName = "suelosCocina", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoSueloCocina;

	@EntityDefinition(propertyName = "azulejos", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoAzulejosCocina;

	@EntityDefinition(propertyName = "grifosMonomandos", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoGriferiaMonomandoCocina;

	@EntityDefinition(propertyName = "cocinaOtros")
	public String otrosCocina;

	@EntityDefinition(propertyName = "ducha", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoDuchaBanyo;

	@EntityDefinition(propertyName = "banyera", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoBanyeraNormalBanyo;

	@EntityDefinition(propertyName = "banyeraHidromasaje", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoBanyeraHidromasajeBanyo;

	@EntityDefinition(propertyName = "columnaHidromasaje", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoColumnaHidromasajeBanyo;

	@EntityDefinition(propertyName = "alicatadoMarmol", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoAlicatadoMarmolBanyo;

	@EntityDefinition(propertyName = "alicatadoGrafito", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoAlicatadoGranitoBanyo;

	@EntityDefinition(propertyName = "alicatadoAzulejo", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoAlicatadoAzulejoBanyo;

	@EntityDefinition(propertyName = "marmol", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoEncimeraMarmolBanyo;

	@EntityDefinition(propertyName = "granito", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoEncimeraGranitoBanyo;

	@EntityDefinition(propertyName = "otroMaterial", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoEncimeraMaterialBanyo;

	@EntityDefinition(propertyName = "estadoSanitarios", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoSanitariosBanyo;

	@EntityDefinition(propertyName = "suelos", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoSueloBanyo;

	@EntityDefinition(propertyName = "estadoGrifoMonomando", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoGriferiaMonomandoBanyo;

	@EntityDefinition(propertyName = "banyoOtros")
	public String otrosBanyo;

	@EntityDefinition(propertyName = "electricidadBuenEstado", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean buenEstadoInstalacionElectrica;

	@EntityDefinition(propertyName = "electricidadDefectuosa", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean instalacionElectricaAntiguaODefectuosa;

	@EntityDefinition(propertyName = "calefaccionGasNat", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeCalefaccionGasNatural;

	@EntityDefinition(propertyName = "calefaccionRadiadorAlu", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existenRadiadoresDeAluminio;

	@EntityDefinition(propertyName = "aguaCalienteCentral", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeAguaCalienteCentral;

	@EntityDefinition(propertyName = "aguaCalienteGasNat", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeAguaCalienteGasNatural;

	@EntityDefinition(propertyName = "airePreinstalacion", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeAireAcondicionadoPreinstalacion;

	@EntityDefinition(propertyName = "aireInstalacion", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeAireAcondicionadoInstalacion;

	@EntityDefinition(propertyName = "aireFrioCalor", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeAireAcondicionadoCalor;

	@EntityDefinition(propertyName = "instalacionOtros")
	public String otrosInstalaciones;

	@EntityDefinition(propertyName = "jardines", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existenJardinesZonasVerdes;

	@EntityDefinition(propertyName = "piscina", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existePiscina;

	@EntityDefinition(propertyName = "padel", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existePistaPadel;

	@EntityDefinition(propertyName = "tenis", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existePistaTenis;

	@EntityDefinition(propertyName = "pistaPolideportiva", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existePistaPolideportiva;

	@EntityDefinition(propertyName = "gimnasio", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeGimnasio;

	@EntityDefinition(propertyName = "instalacionesDeportivasOtros")
	public String otrosInstalacionesDeportivas;

	@EntityDefinition(propertyName = "zonaInfantil", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeZonaInfantil;

	@EntityDefinition(propertyName = "conserjeVigilancia", transform = TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)
	public Boolean existeConserjeVigilancia;

	@EntityDefinition(propertyName = "zonaComunOtros")
	public String otrosZonasComunes;

	@EntityDefinition(procesar = false)
	private Boolean existeAnejoTrastero;
	
	@EntityDefinition(procesar = false)
	private String anejoTrastero;
	
	@EntityDefinition(procesar = false)
	private String anejoGarage;
	
	@EntityDefinition(procesar = false)
	private Integer numeroPlazasGaraje;

	@EntityDefinition(procesar = false)
	private Float superficiePlazasGaraje;
	
	@Diccionary(clase = DDSiniSiNoIndiferente.class, message = "El codTipoAdmiteMascota no existe", groups = { Insert.class,
			Update.class })
	@EntityDefinition(propertyName = "admiteMascotaOtrasCaracteristicas", classObj = DDSiniSiNoIndiferente.class)
	private String codTipoAdmiteMascota;
	
	@EntityDefinition(procesar = false)
	private List<TestigosOpcionalesDto> testigos;
	
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

	public Integer getNumeroEstancias() {
		return numeroEstancias;
	}

	public void setNumeroEstancias(Integer numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}

	public Integer getNumeroBanyos() {
		return numeroBanyos;
	}

	public void setNumeroBanyos(Integer numeroBanyos) {
		this.numeroBanyos = numeroBanyos;
	}

	public Integer getNumeroAseos() {
		return numeroAseos;
	}

	public void setNumeroAseos(Integer numeroAseos) {
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

	public Boolean getExisteAnejoTrastero() {
		return existeAnejoTrastero;
	}

	public void setExisteAnejoTrastero(Boolean existeAnejoTrastero) {
		this.existeAnejoTrastero = existeAnejoTrastero;
	}

	public String getAnejoTrastero() {
		return anejoTrastero;
	}

	public void setAnejoTrastero(String anejoTrastero) {
		this.anejoTrastero = anejoTrastero;
	}

	public String getAnejoGarage() {
		return anejoGarage;
	}

	public void setAnejoGarage(String anejoGarage) {
		this.anejoGarage = anejoGarage;
	}

	public Integer getNumeroPlazasGaraje() {
		return numeroPlazasGaraje;
	}

	public void setNumeroPlazasGaraje(Integer numeroPlazasGaraje) {
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

	public Boolean getBuenEstadoInstalacionGasInstalaciones() {
		return buenEstadoInstalacionGasInstalaciones;
	}

	public void setBuenEstadoInstalacionGasInstalaciones(Boolean buenEstadoInstalacionGasInstalaciones) {
		this.buenEstadoInstalacionGasInstalaciones = buenEstadoInstalacionGasInstalaciones;
	}

	public Boolean getBuenEstadoContadorGasInstalaciones() {
		return buenEstadoContadorGasInstalaciones;
	}

	public void setBuenEstadoContadorGasInstalaciones(Boolean buenEstadoContadorGasInstalaciones) {
		this.buenEstadoContadorGasInstalaciones = buenEstadoContadorGasInstalaciones;
	}

	public String getCodEstadoConservacionEdificio() {
		return codEstadoConservacionEdificio;
	}

	public void setCodEstadoConservacionEdificio(String codEstadoConservacionEdificio) {
		this.codEstadoConservacionEdificio = codEstadoConservacionEdificio;
	}

	public Integer getAnyoRehabilitacionEdificio() {
		return anyoRehabilitacionEdificio;
	}

	public void setAnyoRehabilitacionEdificio(Integer anyoRehabilitacionEdificio) {
		this.anyoRehabilitacionEdificio = anyoRehabilitacionEdificio;
	}

	public Integer getNumeroPlantasEdificio() {
		return numeroPlantasEdificio;
	}

	public void setNumeroPlantasEdificio(Integer numeroPlantasEdificio) {
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

	public Boolean getHumedadesPared() {
		return humedadesPared;
	}

	public void setHumedadesPared(Boolean humedadesPared) {
		this.humedadesPared = humedadesPared;
	}

	public Boolean getHumedadesTecho() {
		return humedadesTecho;
	}

	public void setHumedadesTecho(Boolean humedadesTecho) {
		this.humedadesTecho = humedadesTecho;
	}

	public Boolean getGrietasPared() {
		return grietasPared;
	}

	public void setGrietasPared(Boolean grietasPared) {
		this.grietasPared = grietasPared;
	}

	public Boolean getGrietasTecho() {
		return grietasTecho;
	}

	public void setGrietasTecho(Boolean grietasTecho) {
		this.grietasTecho = grietasTecho;
	}

	public Boolean getBuenEstadoPinturaParedesGotele() {
		return buenEstadoPinturaParedesGotele;
	}

	public void setBuenEstadoPinturaParedesGotele(Boolean buenEstadoPinturaParedesGotele) {
		this.buenEstadoPinturaParedesGotele = buenEstadoPinturaParedesGotele;
	}

	public Boolean getBuenEstadoPinturaParedesLisa() {
		return buenEstadoPinturaParedesLisa;
	}

	public void setBuenEstadoPinturaParedesLisa(Boolean buenEstadoPinturaParedesLisa) {
		this.buenEstadoPinturaParedesLisa = buenEstadoPinturaParedesLisa;
	}

	public Boolean getBuenEstadoPinturaParedesPintado() {
		return buenEstadoPinturaParedesPintado;
	}

	public void setBuenEstadoPinturaParedesPintado(Boolean buenEstadoPinturaParedesPintado) {
		this.buenEstadoPinturaParedesPintado = buenEstadoPinturaParedesPintado;
	}

	public Boolean getBuenEstadoPinturaTechoGotele() {
		return buenEstadoPinturaTechoGotele;
	}

	public void setBuenEstadoPinturaTechoGotele(Boolean buenEstadoPinturaTechoGotele) {
		this.buenEstadoPinturaTechoGotele = buenEstadoPinturaTechoGotele;
	}

	public Boolean getBuenEstadoPinturaTechoLisa() {
		return buenEstadoPinturaTechoLisa;
	}

	public void setBuenEstadoPinturaTechoLisa(Boolean buenEstadoPinturaTechoLisa) {
		this.buenEstadoPinturaTechoLisa = buenEstadoPinturaTechoLisa;
	}

	public Boolean getBuenEstadoPinturaTechoPintado() {
		return buenEstadoPinturaTechoPintado;
	}

	public void setBuenEstadoPinturaTechoPintado(Boolean buenEstadoPinturaTechoPintado) {
		this.buenEstadoPinturaTechoPintado = buenEstadoPinturaTechoPintado;
	}

	public Boolean getBuenEstadoMolduraEscayola() {
		return buenEstadoMolduraEscayola;
	}

	public void setBuenEstadoMolduraEscayola(Boolean buenEstadoMolduraEscayola) {
		this.buenEstadoMolduraEscayola = buenEstadoMolduraEscayola;
	}

	public String getOtrosParamentosVerticales() {
		return otrosParamentosVerticales;
	}

	public void setOtrosParamentosVerticales(String otrosParamentosVerticales) {
		this.otrosParamentosVerticales = otrosParamentosVerticales;
	}

	public Boolean getBuenEstadoTarimaFlotanteSolados() {
		return buenEstadoTarimaFlotanteSolados;
	}

	public void setBuenEstadoTarimaFlotanteSolados(Boolean buenEstadoTarimaFlotanteSolados) {
		this.buenEstadoTarimaFlotanteSolados = buenEstadoTarimaFlotanteSolados;
	}

	public Boolean getBuenEstadoParqueSolados() {
		return buenEstadoParqueSolados;
	}

	public void setBuenEstadoParqueSolados(Boolean buenEstadoParqueSolados) {
		this.buenEstadoParqueSolados = buenEstadoParqueSolados;
	}

	public Boolean getBuenEstadoMarmolSolados() {
		return buenEstadoMarmolSolados;
	}

	public void setBuenEstadoMarmolSolados(Boolean buenEstadoMarmolSolados) {
		this.buenEstadoMarmolSolados = buenEstadoMarmolSolados;
	}

	public Boolean getBuenEstadoPlaquetaSolados() {
		return buenEstadoPlaquetaSolados;
	}

	public void setBuenEstadoPlaquetaSolados(Boolean buenEstadoPlaquetaSolados) {
		this.buenEstadoPlaquetaSolados = buenEstadoPlaquetaSolados;
	}

	public String getOtrosSolados() {
		return otrosSolados;
	}

	public void setOtrosSolados(String otrosSolados) {
		this.otrosSolados = otrosSolados;
	}

	public Boolean getBuenEstadoCocinaAmuebladaCocina() {
		return buenEstadoCocinaAmuebladaCocina;
	}

	public void setBuenEstadoCocinaAmuebladaCocina(Boolean buenEstadoCocinaAmuebladaCocina) {
		this.buenEstadoCocinaAmuebladaCocina = buenEstadoCocinaAmuebladaCocina;
	}

	public Boolean getBuenEstadoEncimeraGranitoCocina() {
		return buenEstadoEncimeraGranitoCocina;
	}

	public void setBuenEstadoEncimeraGranitoCocina(Boolean buenEstadoEncimeraGranitoCocina) {
		this.buenEstadoEncimeraGranitoCocina = buenEstadoEncimeraGranitoCocina;
	}

	public Boolean getBuenEstadoEncimeraMarmolCocina() {
		return buenEstadoEncimeraMarmolCocina;
	}

	public void setBuenEstadoEncimeraMarmolCocina(Boolean buenEstadoEncimeraMarmolCocina) {
		this.buenEstadoEncimeraMarmolCocina = buenEstadoEncimeraMarmolCocina;
	}

	public Boolean getBuenEstadoEncimeraMaterialCocina() {
		return buenEstadoEncimeraMaterialCocina;
	}

	public void setBuenEstadoEncimeraMaterialCocina(Boolean buenEstadoEncimeraMaterialCocina) {
		this.buenEstadoEncimeraMaterialCocina = buenEstadoEncimeraMaterialCocina;
	}

	public Boolean getBuenEstadoVitroceramicaCocina() {
		return buenEstadoVitroceramicaCocina;
	}

	public void setBuenEstadoVitroceramicaCocina(Boolean buenEstadoVitroceramicaCocina) {
		this.buenEstadoVitroceramicaCocina = buenEstadoVitroceramicaCocina;
	}

	public Boolean getBuenEstadoLavadoraCocina() {
		return buenEstadoLavadoraCocina;
	}

	public void setBuenEstadoLavadoraCocina(Boolean buenEstadoLavadoraCocina) {
		this.buenEstadoLavadoraCocina = buenEstadoLavadoraCocina;
	}

	public Boolean getBuenEstadoFrigorificoCocina() {
		return buenEstadoFrigorificoCocina;
	}

	public void setBuenEstadoFrigorificoCocina(Boolean buenEstadoFrigorificoCocina) {
		this.buenEstadoFrigorificoCocina = buenEstadoFrigorificoCocina;
	}

	public Boolean getBuenEstadoLavavajillasCocina() {
		return buenEstadoLavavajillasCocina;
	}

	public void setBuenEstadoLavavajillasCocina(Boolean buenEstadoLavavajillasCocina) {
		this.buenEstadoLavavajillasCocina = buenEstadoLavavajillasCocina;
	}

	public Boolean getBuenEstadoMicroondasCocina() {
		return buenEstadoMicroondasCocina;
	}

	public void setBuenEstadoMicroondasCocina(Boolean buenEstadoMicroondasCocina) {
		this.buenEstadoMicroondasCocina = buenEstadoMicroondasCocina;
	}

	public Boolean getBuenEstadoHornoCocina() {
		return buenEstadoHornoCocina;
	}

	public void setBuenEstadoHornoCocina(Boolean buenEstadoHornoCocina) {
		this.buenEstadoHornoCocina = buenEstadoHornoCocina;
	}

	public Boolean getBuenEstadoSueloCocina() {
		return buenEstadoSueloCocina;
	}

	public void setBuenEstadoSueloCocina(Boolean buenEstadoSueloCocina) {
		this.buenEstadoSueloCocina = buenEstadoSueloCocina;
	}

	public Boolean getBuenEstadoAzulejosCocina() {
		return buenEstadoAzulejosCocina;
	}

	public void setBuenEstadoAzulejosCocina(Boolean buenEstadoAzulejosCocina) {
		this.buenEstadoAzulejosCocina = buenEstadoAzulejosCocina;
	}

	public Boolean getBuenEstadoGriferiaMonomandoCocina() {
		return buenEstadoGriferiaMonomandoCocina;
	}

	public void setBuenEstadoGriferiaMonomandoCocina(Boolean buenEstadoGriferiaMonomandoCocina) {
		this.buenEstadoGriferiaMonomandoCocina = buenEstadoGriferiaMonomandoCocina;
	}

	public String getOtrosCocina() {
		return otrosCocina;
	}

	public void setOtrosCocina(String otrosCocina) {
		this.otrosCocina = otrosCocina;
	}

	public Boolean getBuenEstadoDuchaBanyo() {
		return buenEstadoDuchaBanyo;
	}

	public void setBuenEstadoDuchaBanyo(Boolean buenEstadoDuchaBanyo) {
		this.buenEstadoDuchaBanyo = buenEstadoDuchaBanyo;
	}

	public Boolean getBuenEstadoBanyeraNormalBanyo() {
		return buenEstadoBanyeraNormalBanyo;
	}

	public void setBuenEstadoBanyeraNormalBanyo(Boolean buenEstadoBanyeraNormalBanyo) {
		this.buenEstadoBanyeraNormalBanyo = buenEstadoBanyeraNormalBanyo;
	}

	public Boolean getBuenEstadoBanyeraHidromasajeBanyo() {
		return buenEstadoBanyeraHidromasajeBanyo;
	}

	public void setBuenEstadoBanyeraHidromasajeBanyo(Boolean buenEstadoBanyeraHidromasajeBanyo) {
		this.buenEstadoBanyeraHidromasajeBanyo = buenEstadoBanyeraHidromasajeBanyo;
	}

	public Boolean getBuenEstadoColumnaHidromasajeBanyo() {
		return buenEstadoColumnaHidromasajeBanyo;
	}

	public void setBuenEstadoColumnaHidromasajeBanyo(Boolean buenEstadoColumnaHidromasajeBanyo) {
		this.buenEstadoColumnaHidromasajeBanyo = buenEstadoColumnaHidromasajeBanyo;
	}

	public Boolean getBuenEstadoAlicatadoMarmolBanyo() {
		return buenEstadoAlicatadoMarmolBanyo;
	}

	public void setBuenEstadoAlicatadoMarmolBanyo(Boolean buenEstadoAlicatadoMarmolBanyo) {
		this.buenEstadoAlicatadoMarmolBanyo = buenEstadoAlicatadoMarmolBanyo;
	}

	public Boolean getBuenEstadoAlicatadoGranitoBanyo() {
		return buenEstadoAlicatadoGranitoBanyo;
	}

	public void setBuenEstadoAlicatadoGranitoBanyo(Boolean buenEstadoAlicatadoGranitoBanyo) {
		this.buenEstadoAlicatadoGranitoBanyo = buenEstadoAlicatadoGranitoBanyo;
	}

	public Boolean getBuenEstadoAlicatadoAzulejoBanyo() {
		return buenEstadoAlicatadoAzulejoBanyo;
	}

	public void setBuenEstadoAlicatadoAzulejoBanyo(Boolean buenEstadoAlicatadoAzulejoBanyo) {
		this.buenEstadoAlicatadoAzulejoBanyo = buenEstadoAlicatadoAzulejoBanyo;
	}

	public Boolean getBuenEstadoEncimeraMarmolBanyo() {
		return buenEstadoEncimeraMarmolBanyo;
	}

	public void setBuenEstadoEncimeraMarmolBanyo(Boolean buenEstadoEncimeraMarmolBanyo) {
		this.buenEstadoEncimeraMarmolBanyo = buenEstadoEncimeraMarmolBanyo;
	}

	public Boolean getBuenEstadoEncimeraGranitoBanyo() {
		return buenEstadoEncimeraGranitoBanyo;
	}

	public void setBuenEstadoEncimeraGranitoBanyo(Boolean buenEstadoEncimeraGranitoBanyo) {
		this.buenEstadoEncimeraGranitoBanyo = buenEstadoEncimeraGranitoBanyo;
	}

	public Boolean getBuenEstadoEncimeraMaterialBanyo() {
		return buenEstadoEncimeraMaterialBanyo;
	}

	public void setBuenEstadoEncimeraMaterialBanyo(Boolean buenEstadoEncimeraMaterialBanyo) {
		this.buenEstadoEncimeraMaterialBanyo = buenEstadoEncimeraMaterialBanyo;
	}

	public Boolean getBuenEstadoSanitariosBanyo() {
		return buenEstadoSanitariosBanyo;
	}

	public void setBuenEstadoSanitariosBanyo(Boolean buenEstadoSanitariosBanyo) {
		this.buenEstadoSanitariosBanyo = buenEstadoSanitariosBanyo;
	}

	public Boolean getBuenEstadoSueloBanyo() {
		return buenEstadoSueloBanyo;
	}

	public void setBuenEstadoSueloBanyo(Boolean buenEstadoSueloBanyo) {
		this.buenEstadoSueloBanyo = buenEstadoSueloBanyo;
	}

	public Boolean getBuenEstadoGriferiaMonomandoBanyo() {
		return buenEstadoGriferiaMonomandoBanyo;
	}

	public void setBuenEstadoGriferiaMonomandoBanyo(Boolean buenEstadoGriferiaMonomandoBanyo) {
		this.buenEstadoGriferiaMonomandoBanyo = buenEstadoGriferiaMonomandoBanyo;
	}

	public String getOtrosBanyo() {
		return otrosBanyo;
	}

	public void setOtrosBanyo(String otrosBanyo) {
		this.otrosBanyo = otrosBanyo;
	}

	public Boolean getBuenEstadoInstalacionElectrica() {
		return buenEstadoInstalacionElectrica;
	}

	public void setBuenEstadoInstalacionElectrica(Boolean buenEstadoInstalacionElectrica) {
		this.buenEstadoInstalacionElectrica = buenEstadoInstalacionElectrica;
	}

	public Boolean getInstalacionElectricaAntiguaODefectuosa() {
		return instalacionElectricaAntiguaODefectuosa;
	}

	public void setInstalacionElectricaAntiguaODefectuosa(Boolean instalacionElectricaAntiguaODefectuosa) {
		this.instalacionElectricaAntiguaODefectuosa = instalacionElectricaAntiguaODefectuosa;
	}

	public Boolean getExisteCalefaccionGasNatural() {
		return existeCalefaccionGasNatural;
	}

	public void setExisteCalefaccionGasNatural(Boolean existeCalefaccionGasNatural) {
		this.existeCalefaccionGasNatural = existeCalefaccionGasNatural;
	}

	public Boolean getExistenRadiadoresDeAluminio() {
		return existenRadiadoresDeAluminio;
	}

	public void setExistenRadiadoresDeAluminio(Boolean existenRadiadoresDeAluminio) {
		this.existenRadiadoresDeAluminio = existenRadiadoresDeAluminio;
	}

	public Boolean getExisteAguaCalienteCentral() {
		return existeAguaCalienteCentral;
	}

	public void setExisteAguaCalienteCentral(Boolean existeAguaCalienteCentral) {
		this.existeAguaCalienteCentral = existeAguaCalienteCentral;
	}

	public Boolean getExisteAguaCalienteGasNatural() {
		return existeAguaCalienteGasNatural;
	}

	public void setExisteAguaCalienteGasNatural(Boolean existeAguaCalienteGasNatural) {
		this.existeAguaCalienteGasNatural = existeAguaCalienteGasNatural;
	}

	public Boolean getExisteAireAcondicionadoPreinstalacion() {
		return existeAireAcondicionadoPreinstalacion;
	}

	public void setExisteAireAcondicionadoPreinstalacion(Boolean existeAireAcondicionadoPreinstalacion) {
		this.existeAireAcondicionadoPreinstalacion = existeAireAcondicionadoPreinstalacion;
	}

	public Boolean getExisteAireAcondicionadoInstalacion() {
		return existeAireAcondicionadoInstalacion;
	}

	public void setExisteAireAcondicionadoInstalacion(Boolean existeAireAcondicionadoInstalacion) {
		this.existeAireAcondicionadoInstalacion = existeAireAcondicionadoInstalacion;
	}

	public Boolean getExisteAireAcondicionadoCalor() {
		return existeAireAcondicionadoCalor;
	}

	public void setExisteAireAcondicionadoCalor(Boolean existeAireAcondicionadoCalor) {
		this.existeAireAcondicionadoCalor = existeAireAcondicionadoCalor;
	}

	public String getOtrosInstalaciones() {
		return otrosInstalaciones;
	}

	public void setOtrosInstalaciones(String otrosInstalaciones) {
		this.otrosInstalaciones = otrosInstalaciones;
	}

	public Boolean getExistenJardinesZonasVerdes() {
		return existenJardinesZonasVerdes;
	}

	public void setExistenJardinesZonasVerdes(Boolean existenJardinesZonasVerdes) {
		this.existenJardinesZonasVerdes = existenJardinesZonasVerdes;
	}

	public Boolean getExistePiscina() {
		return existePiscina;
	}

	public void setExistePiscina(Boolean existePiscina) {
		this.existePiscina = existePiscina;
	}

	public Boolean getExistePistaPadel() {
		return existePistaPadel;
	}

	public void setExistePistaPadel(Boolean existePistaPadel) {
		this.existePistaPadel = existePistaPadel;
	}

	public Boolean getExistePistaTenis() {
		return existePistaTenis;
	}

	public void setExistePistaTenis(Boolean existePistaTenis) {
		this.existePistaTenis = existePistaTenis;
	}

	public Boolean getExistePistaPolideportiva() {
		return existePistaPolideportiva;
	}

	public void setExistePistaPolideportiva(Boolean existePistaPolideportiva) {
		this.existePistaPolideportiva = existePistaPolideportiva;
	}

	public Boolean getExisteGimnasio() {
		return existeGimnasio;
	}

	public void setExisteGimnasio(Boolean existeGimnasio) {
		this.existeGimnasio = existeGimnasio;
	}

	public String getOtrosInstalacionesDeportivas() {
		return otrosInstalacionesDeportivas;
	}

	public void setOtrosInstalacionesDeportivas(String otrosInstalacionesDeportivas) {
		this.otrosInstalacionesDeportivas = otrosInstalacionesDeportivas;
	}

	public Boolean getExisteZonaInfantil() {
		return existeZonaInfantil;
	}

	public void setExisteZonaInfantil(Boolean existeZonaInfantil) {
		this.existeZonaInfantil = existeZonaInfantil;
	}

	public Boolean getExisteConserjeVigilancia() {
		return existeConserjeVigilancia;
	}

	public void setExisteConserjeVigilancia(Boolean existeConserjeVigilancia) {
		this.existeConserjeVigilancia = existeConserjeVigilancia;
	}

	public String getOtrosZonasComunes() {
		return otrosZonasComunes;
	}

	public void setOtrosZonasComunes(String otrosZonasComunes) {
		this.otrosZonasComunes = otrosZonasComunes;
	}

	public Boolean getBuenEstadoVentanaHierro() {
		return buenEstadoVentanaHierro;
	}

	public void setBuenEstadoVentanaHierro(Boolean buenEstadoVentanaHierro) {
		this.buenEstadoVentanaHierro = buenEstadoVentanaHierro;
	}

	public Boolean getBuenEstadoVentanaAnodizado() {
		return buenEstadoVentanaAnodizado;
	}

	public void setBuenEstadoVentanaAnodizado(Boolean buenEstadoVentanaAnodizado) {
		this.buenEstadoVentanaAnodizado = buenEstadoVentanaAnodizado;
	}

	public Boolean getBuenEstadoVentanaLacado() {
		return buenEstadoVentanaLacado;
	}

	public void setBuenEstadoVentanaLacado(Boolean buenEstadoVentanaLacado) {
		this.buenEstadoVentanaLacado = buenEstadoVentanaLacado;
	}

	public Boolean getBuenEstadoVentanaPvc() {
		return buenEstadoVentanaPvc;
	}

	public void setBuenEstadoVentanaPvc(Boolean buenEstadoVentanaPvc) {
		this.buenEstadoVentanaPvc = buenEstadoVentanaPvc;
	}

	public Boolean getBuenEstadoVentanaMadera() {
		return buenEstadoVentanaMadera;
	}

	public void setBuenEstadoVentanaMadera(Boolean buenEstadoVentanaMadera) {
		this.buenEstadoVentanaMadera = buenEstadoVentanaMadera;
	}

	public Boolean getBuenEstadoPersianaPlastico() {
		return buenEstadoPersianaPlastico;
	}

	public void setBuenEstadoPersianaPlastico(Boolean buenEstadoPersianaPlastico) {
		this.buenEstadoPersianaPlastico = buenEstadoPersianaPlastico;
	}

	public Boolean getBuenEstadoPersianaAluminio() {
		return buenEstadoPersianaAluminio;
	}

	public void setBuenEstadoPersianaAluminio(Boolean buenEstadoPersianaAluminio) {
		this.buenEstadoPersianaAluminio = buenEstadoPersianaAluminio;
	}

	public Boolean getBuenEstadoAperturaVentanaCorrederas() {
		return buenEstadoAperturaVentanaCorrederas;
	}

	public void setBuenEstadoAperturaVentanaCorrederas(Boolean buenEstadoAperturaVentanaCorrederas) {
		this.buenEstadoAperturaVentanaCorrederas = buenEstadoAperturaVentanaCorrederas;
	}

	public Boolean getBuenEstadoAperturaVentanaAbatibles() {
		return buenEstadoAperturaVentanaAbatibles;
	}

	public void setBuenEstadoAperturaVentanaAbatibles(Boolean buenEstadoAperturaVentanaAbatibles) {
		this.buenEstadoAperturaVentanaAbatibles = buenEstadoAperturaVentanaAbatibles;
	}

	public Boolean getBuenEstadoAperturaVentanaOscilobat() {
		return buenEstadoAperturaVentanaOscilobat;
	}

	public void setBuenEstadoAperturaVentanaOscilobat(Boolean buenEstadoAperturaVentanaOscilobat) {
		this.buenEstadoAperturaVentanaOscilobat = buenEstadoAperturaVentanaOscilobat;
	}

	public Boolean getBuenEstadoDobleAcristalamientoOClimalit() {
		return buenEstadoDobleAcristalamientoOClimalit;
	}

	public void setBuenEstadoDobleAcristalamientoOClimalit(Boolean buenEstadoDobleAcristalamientoOClimalit) {
		this.buenEstadoDobleAcristalamientoOClimalit = buenEstadoDobleAcristalamientoOClimalit;
	}

	public String getOtrosCarpinteriaExterior() {
		return otrosCarpinteriaExterior;
	}

	public void setOtrosCarpinteriaExterior(String otrosCarpinteriaExterior) {
		this.otrosCarpinteriaExterior = otrosCarpinteriaExterior;
	}
	
	public String getCodTipoAdmiteMascota() {
		return codTipoAdmiteMascota;
	}

	public void setCodTipoAdmiteMascota(String codTipoAdmiteMascota) {
		this.codTipoAdmiteMascota = codTipoAdmiteMascota;
	}

	public List<TestigosOpcionalesDto> getTestigos() {
		return testigos;
	}

	public void setTestigos(List<TestigosOpcionalesDto> testigos) {
		this.testigos = testigos;
	}

}
