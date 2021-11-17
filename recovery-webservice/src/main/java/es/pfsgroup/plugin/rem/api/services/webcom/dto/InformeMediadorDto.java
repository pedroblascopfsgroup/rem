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
	private LongDataType idInformeMediadorWebcom;
	private LongDataType idProveedorRemAnterior;
	@WebcomRequired
	private LongDataType idProveedorRem;
	private BooleanDataType posibleInforme;
	private StringDataType motivoNoPosibleInforme;
	private DateDataType recepcionLlavesHaya;
	@WebcomRequired
	private DateDataType envioLlavesAApi;
	@WebcomRequired
	private StringDataType fincaRegistral;
	private LongDataType numeroRegistro;
	@WebcomRequired
	private StringDataType referenciaCatastral;
	private DoubleDataType valorAprobadoVenta;
	private DateDataType fechaValorAprobadoVenta;
	private DoubleDataType valorAprobadoRenta;
	private DateDataType fechaValorAprobadoRenta;
	private BooleanDataType riesgoOcupacion;
	@WebcomRequired
	private DateDataType fechaPosesion;
	@WebcomRequired
	@MappedColumn("ULTIMA_MODIFICACION")
	private DateDataType ultimaModificacionInforme;
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
	@WebcomRequired
	private StringDataType codTipoActivo;
	@WebcomRequired
	private StringDataType codSubtipoInmueble;
	private StringDataType codTipoVivienda;
	private DateDataType fechaUltimaVisita;
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
	private StringDataType codPedania;
	@WebcomRequired
	private StringDataType codProvincia;
	@WebcomRequired
	private StringDataType codigoPostal;
	private StringDataType zona;
	private StringDataType codUbicacion;
	private StringDataType codDistrito;
	@WebcomRequired
	private DoubleDataType lat;
	@WebcomRequired
	private DoubleDataType lng;
	@WebcomRequired
	private DateDataType fechaRecepcionLlavesApi;
	private StringDataType codMunicipioRegistro;
	private StringDataType codRegimenProteccion;
	private DoubleDataType valorMaximoVpo;
	private StringDataType codTipoPropiedad;
	@WebcomRequired
	private DoubleDataType porcentajePropiedad;
	private DoubleDataType valorEstimadoVenta;
	private DateDataType fechaValorEstimadoVenta;
	@MappedColumn("JUSTIFICACION_VALOR_EST_VENTA")
	private StringDataType justificacionValorEstimadoVenta;
	private DoubleDataType valorEstimadoRenta;
	private DateDataType fechaValorEstimadoRenta;
	@MappedColumn("JUSTIFICACION_VALOR_EST_RENTA")
	private StringDataType justificacionValorEstimadoRenta;
	@WebcomRequired
	private DoubleDataType utilSuperficie;
	@WebcomRequired
	private DoubleDataType construidaSuperficie;
	@WebcomRequired
	private DoubleDataType registralSuperficie;
	private DoubleDataType parcelaSuperficie;
	private StringDataType codEstadoConservacion;
	@WebcomRequired
	private LongDataType anyoConstruccion;
	@WebcomRequired
	private LongDataType anyoRehabilitacion;
	private StringDataType codOrientacion;
	private BooleanDataType ultimaPlanta;
	private BooleanDataType ocupado;
	private LongDataType numeroPlantas;
	private StringDataType codNivelRenta;
	private LongDataType numeroTerrazasDescubiertas;
	@MappedColumn("DESC_TERRAZAS_DESCUBIERTAS")
	private StringDataType descripcionTerrazasDescubiertas;
	private LongDataType numeroTerrazasCubiertas;
	@MappedColumn("DESC_TERRAZAS_CUBIERTAS")
	private StringDataType descripcionTerrazasCubiertas;
	private BooleanDataType despensaOtrasDependencias;
	private BooleanDataType lavaderoOtrasDependencias;
	private BooleanDataType azoteaOtrasDependencias;
	private StringDataType otrosOtrasDependencias;
	/*private BooleanDataType instalacionElectricidadInstalaciones;
	private BooleanDataType contadorElectricidadInstalaciones;
	private BooleanDataType instalacionAguaInstalaciones;
	private BooleanDataType contadorAguaInstalaciones;
	private BooleanDataType gasInstalaciones;
	private BooleanDataType contadorGasInstalacion;*/
	@MappedColumn("EXTERIOR_CARP_REFORMAS_NEC")
	private BooleanDataType exteriorCarpinteriaReformasNecesarias;
	@MappedColumn("INTERIOR_CARP_REFORMAS_NEC")
	private BooleanDataType interiorCarpinteriaReformasNecesarias;
	@MappedColumn("COCINA_REFORMAS_NEC")
	private BooleanDataType cocinaReformasNecesarias;
	@MappedColumn("SUELOS_REFORMAS_NEC")
	private BooleanDataType suelosReformasNecesarias;
	@MappedColumn("PINTURA_REFORMAS_NEC")
	private BooleanDataType pinturaReformasNecesarias;
	@MappedColumn("INTEGRAL_REFORMAS_NEC")
	private BooleanDataType integralReformasNecesarias;
	@MappedColumn("BANYOS_REFORMAS_NEC")
	private BooleanDataType banyosReformasNecesarias;
	@MappedColumn("OTRAS_REFORMAS_NEC")
	private StringDataType otrasReformasNecesarias;
	@MappedColumn("OTRAS_REFORMAS_NEC_IMPORTE")
	private DoubleDataType otrasReformasNecesariasImporteAproximado;
	private StringDataType distribucionInterior;
	private BooleanDataType divisible;
	@WebcomRequired
	private BooleanDataType ascensor;
	private LongDataType numeroAscensores;
	private StringDataType descripcionPlantas;
	private StringDataType otrasCaracteristicas;
	private BooleanDataType fachadaReformasNecesarias;
	private BooleanDataType escaleraReformasNecesarias;
	private BooleanDataType portalReformasNecesarias;
	private BooleanDataType ascensorReformasNecesarias;
	private BooleanDataType cubierta;
	@MappedColumn("OTRAS_ZNC_REFORMAS_NECESARIAS")
	private BooleanDataType otrasZonasComunesReformasNecesarias;
	@MappedColumn("OTRAS_REFORMAS_NECESARIAS")
	private StringDataType otrosReformasNecesarias;
	private StringDataType descripcionEdificio;
	private StringDataType infraestructurasEntorno;
	private StringDataType comunicacionesEntorno;
	private StringDataType idoneoUso;
	private BooleanDataType existeAnteriorUso;
	private StringDataType anteriorUso;
	private LongDataType numeroEstancias;
	@WebcomRequired
	private LongDataType numeroBanyos;
	@WebcomRequired
	private LongDataType numeroAseos;
	@MappedColumn("MTS_LINEALES_FACHADA_PPAL")
	private DoubleDataType metrosLinealesFachadaPrincipal;
	private DoubleDataType altura;
	private BooleanDataType existeAnejoTrastero;
	private StringDataType anejoTrastero;
	private StringDataType anejoGarage;
	@WebcomRequired
	private LongDataType numeroPlazasGaraje;
	private DoubleDataType superficiePlazasGaraje;
	private StringDataType codSubtipoPlazasGaraje;
	@MappedColumn("SALIDA_HUMOS_OTRAS_CARAC")
	private BooleanDataType salidaHumosOtrasCaracteristicas;
	@MappedColumn("SALIDA_EMERGENCIA_OTRAS_CARAC")
	private BooleanDataType salidaEmergenciaOtrasCaracteristicas;
	@MappedColumn("ACCESO_MINUSVAL_OTRAS_CARAC")
	private BooleanDataType accesoMinusvalidosOtrasCaracteristicas;
	@MappedColumn("OTROS_OTRAS_CARAC")
	private StringDataType otrosOtrasCaracteristicas;
	private StringDataType codTipoVario;
	private DoubleDataType ancho;
	private DoubleDataType alto;
	private DoubleDataType largo;
	private StringDataType codUso;
	private StringDataType codManiobrabilidad;
	@MappedColumn("LICENCIA_OTRAS_CARAC")
	private BooleanDataType licenciaOtrasCaracteristicas;
	@MappedColumn("SERVIDUMBRE_OTRAS_CARAC")
	private BooleanDataType servidumbreOtrasCaracteristicas;
	@MappedColumn("ASCENSOR_MONT_OTRAS_CARAC")
	private BooleanDataType ascensorOMontacargasOtrasCaracteristicas;
	@MappedColumn("COLUMNAS_OTRAS_CARAC")
	private BooleanDataType columnasOtrasCaracteristicas;
	@MappedColumn("SREGURIDAD_OTRAS_CARAC")
	private BooleanDataType seguridadOtrasCaracteristicas;
	@MappedColumn("BUEN_EST_INST_ELECT_INST")
	private BooleanDataType buenEstadoInstalacionElectricidadInstalaciones;
	@MappedColumn("BUEN_EST_CONT_ELECT_INST")
	private BooleanDataType buenEstadoContadorElectricidadInstalaciones;
	@MappedColumn("BUEN_EST_INST_AGUA_INST")
	private BooleanDataType buenEstadoInstalacionAguaInstalaciones;
	@MappedColumn("BUEN_EST_CONT_AGUA_INST")
	private BooleanDataType buenEstadoContadorAguaInstalaciones;
	@MappedColumn("BUEN_EST_INST_GAS_INST")
	private BooleanDataType buenEstadoGasInstalaciones;
	@MappedColumn("BUEN_EST_CONT_GAS_INST")
	private BooleanDataType buenEstadoContadorGasInstalacion;
	@MappedColumn("ESTADO_CONSERVACION_EDI")
	private StringDataType codEstadoConservacionEdificio;
	//private BooleanDataType buenEstadoConservacionEdificio;
	private LongDataType anyoRehabilitacionEdificio;
	private LongDataType numeroPlantasEdificio;
	private BooleanDataType ascensorEdificio;
	private LongDataType numeroAscensoresEdificio;
	private BooleanDataType existeComunidadEdificio;
	private DoubleDataType cuotaComunidadEdificio;
	@MappedColumn("NOM_PRESIDENTE_COM_EDIFICIO")
	private StringDataType nombrePresidenteComunidadEdificio;
	@MappedColumn("TELF_PRESIDENTE_COM_EDIFICIO")
	private StringDataType telefonoPresidenteComunidadEdificio;
	@MappedColumn("NOM_ADMIN_COM_EDIFICIO")
	private StringDataType nombreAdministradorComunidadEdificio;
	@MappedColumn("TELF_ADMIN_COM_EDIFICIO")
	private StringDataType telefonoAdministradorComunidadEdificio;
	@MappedColumn("DESC_DERRAMA_COM_EDIFICIO")
	private StringDataType descripcionDerramaComunidadEdificio;
	@MappedColumn("FACHADA_REFORMAS_NEC_EDI")
	private BooleanDataType fachadaReformasNecesariasEdificio;
	@MappedColumn("ESCALERA_REFORMAS_NEC_EDI")
	private BooleanDataType escaleraReformasNecesariasEdificio;
	@MappedColumn("PORTAL_REFORMAS_NEC_EDI")
	private BooleanDataType portalReformasNecesariasEdificio;
	@MappedColumn("ASCENSOR_REFORMAS_NEC_EDI")
	private BooleanDataType ascensorReformasNecesariasEdificio;
	@MappedColumn("CUBIERTA_REFORMAS_NEC_EDI")
	private BooleanDataType cubiertaReformasNecesariasEdificio;
	@MappedColumn("OTRAS_ZCO_REFORMAS_NEC_EDI")
	private BooleanDataType otrasZonasComunesReformasNecesariasEdificio;
	@MappedColumn("OTRAS_REFORMAS_NEC_EDI")
	private StringDataType otrosReformasNecesariasEdificio;
	@MappedColumn("INFRAESTRUCTURAS_ENTORNO_EDI")
	private StringDataType infraestructurasEntornoEdificio;
	@MappedColumn("COMUNICACIONES_ENTORNO_EDI")
	private StringDataType comunicacionesEntornoEdificio;
	private BooleanDataType existeOcio;
	private BooleanDataType existenHoteles;
	private StringDataType hoteles;
	private BooleanDataType existenTeatros;
	private StringDataType teatros;
	private BooleanDataType existenSalasDeCine;
	private StringDataType salasDeCine;
	@MappedColumn("EXISTEN_INST_DEPORTIVAS")
	private BooleanDataType existenInstalacionesDeportivas;
	@MappedColumn("INST_DEPORTIVAS")
	private StringDataType instalacionesDeportivas;
	private BooleanDataType existenCentrosComerciales;
	private StringDataType centrosComerciales;
	private StringDataType otrosOcio;
	private BooleanDataType existenCentrosEducativos;
	private BooleanDataType existenEscuelasInfantiles;
	private StringDataType escuelasInfantiles;
	private BooleanDataType existenColegios;
	private StringDataType colegios;
	private BooleanDataType existenInstitutos;
	private StringDataType institutos;
	private BooleanDataType existenUniversidades;
	private StringDataType universidades;
	private StringDataType otrosCentrosEducativos;
	private BooleanDataType existenCentrosSanitarios;
	private BooleanDataType existenCentrosDeSalud;
	private StringDataType centrosDeSalud;
	private BooleanDataType existenClinicas;
	private StringDataType clinicas;
	private BooleanDataType existenHospitales;
	private StringDataType hospitales;
	@MappedColumn("EXISTEN_OTROS_CENTROS_SANIT")
	private BooleanDataType existenOtrosCentrosSanitarios;
	private StringDataType otrosCentrosSanitarios;
	@MappedColumn("SUFI_APARCAMIENTO_SUPERFICIE")
	private BooleanDataType suficienteAparcamientoEnSuperficie;
	private BooleanDataType existenComunicaciones;
	@MappedColumn("EXISTE_FACIL_ACCESO_CARRETERA")
	private BooleanDataType existeFacilAccesoPorCarretera;
	@MappedColumn("FACIL_ACCESO_POR_CARRETERA")
	private StringDataType facilAccesoPorCarretera;
	private BooleanDataType existeLineasDeAutobus;
	private StringDataType lineasDeAutobus;
	private BooleanDataType existeMetro;
	private StringDataType metro;
	private BooleanDataType existeEstacionesDeTren;
	private StringDataType estacionesDeTren;
	private StringDataType otrosComunicaciones;
	@MappedColumn("BUEN_ESTADO_PTA_ENT_NORMAL")
	private BooleanDataType buenEstadoPuertaEntradaNormal;
	@MappedColumn("BUEN_ESTADO_PTA_ENT_BLINDADA")
	private BooleanDataType buenEstadoPuertaEntradaBlindada;
	@MappedColumn("BUEN_ESTADO_PTA_ENT_ACORAZADA")
	private BooleanDataType buenEstadoPuertaEntradaAcorazada;
	@MappedColumn("BUEN_ESTADO_PTA_PASO_MACIZA")
	private BooleanDataType buenEstadoPuertaPasoMaciza;
	@MappedColumn("BUEN_ESTADO_PTA_PASO_HUECA")
	private BooleanDataType buenEstadoPuertaPasoHueca;
	@MappedColumn("BUEN_ESTADO_PTA_PASO_LACADA")
	private BooleanDataType buenEstadoPuertaPasoLacada;
	private BooleanDataType existenArmariosEmpotrados;
	private StringDataType codAcabadoCarpinteria;
	private StringDataType otrosCarpinteriaInterior;
	private BooleanDataType buenEstadoVentanaHierro;
	private BooleanDataType buenEstadoVentanaAnodizado;
	private BooleanDataType buenEstadoVentanaLacado;
	private BooleanDataType buenEstadoVentanaPvc;
	private BooleanDataType buenEstadoVentanaMadera;
	private BooleanDataType buenEstadoPersianaPlastico;
	private BooleanDataType buenEstadoPersianaAluminio;
	@MappedColumn("BUEN_ESTADO_VTNAS_CORREDERAS")
	private BooleanDataType buenEstadoAperturaVentanaCorrederas;
	@MappedColumn("BUEN_ESTADO_VTNAS_ABATIBLES")
	private BooleanDataType buenEstadoAperturaVentanaAbatibles;
	@MappedColumn("BUEN_ESTADO_VTNAS_OSCILOBAT")
	private BooleanDataType buenEstadoAperturaVentanaOscilobat;
	@MappedColumn("BUEN_ESTADO_DOBLE_CRISTAL")
	private BooleanDataType buenEstadoDobleAcristalamientoOClimalit;
	private StringDataType otrosCarpinteriaExterior;
	private BooleanDataType humedadesPared;
	private BooleanDataType humedadesTecho;
	private BooleanDataType grietasPared;
	private BooleanDataType grietasTecho;
	@MappedColumn("ESTADO_PINTURA_PAREDES_GOTELE")
	private BooleanDataType buenEstadoPinturaParedesGotele;
	@MappedColumn("ESTADO_PINTURA_PAREDES_LISA")
	private BooleanDataType buenEstadoPinturaParedesLisa;
	@MappedColumn("ESTADO_PINTURA_PAREDES_PINTADO")
	private BooleanDataType buenEstadoPinturaParedesPintado;
	@MappedColumn("ESTADO_PINTURA_TECHO_GOTELE")
	private BooleanDataType buenEstadoPinturaTechoGotele;
	@MappedColumn("ESTADO_PINTURA_TECHO_LISA")
	private BooleanDataType buenEstadoPinturaTechoLisa;
	@MappedColumn("ESTADO_PINTURA_TECHO_PINTADO")
	private BooleanDataType buenEstadoPinturaTechoPintado;
	@MappedColumn("ESTADO_MOLDURA_ESCAYOLA")
	private BooleanDataType buenEstadoMolduraEscayola;
	private StringDataType otrosParamentosVerticales;
	@MappedColumn("ESTADO_TARIMA_FLOTANTE_SOLADOS")
	private BooleanDataType buenEstadoTarimaFlotanteSolados;
	@MappedColumn("ESTADO_PARQUE_SOLADOS")
	private BooleanDataType buenEstadoParqueSolados;
	@MappedColumn("ESTADO_MARMOL_SOLADOS")
	private BooleanDataType buenEstadoMarmolSolados;
	@MappedColumn("ESTADO_PLAQUETA_SOLADOS")
	private BooleanDataType buenEstadoPlaquetaSolados;
	private StringDataType otrosSolados;
	@MappedColumn("ESTADO_COCINA_AMUEBLADA_COCINA")
	private BooleanDataType buenEstadoCocinaAmuebladaCocina;
	@MappedColumn("ESTADO_ENCIMERA_GRANITO_COCINA")
	private BooleanDataType buenEstadoEncimeraGranitoCocina;
	@MappedColumn("ESTADO_ENCIMERA_MARMOL_COCINA")
	private BooleanDataType buenEstadoEncimeraMarmolCocina;
	@MappedColumn("ESTADO_ENCIMERA_MATERIAL_COC")
	private BooleanDataType buenEstadoEncimeraMaterialCocina;
	@MappedColumn("ESTADO_VITROCERAMICA_COCINA")
	private BooleanDataType buenEstadoVitroceramicaCocina;
	@MappedColumn("ESTADO_LABADORA_COCINA")
	private BooleanDataType buenEstadoLavadoraCocina;
	@MappedColumn("ESTADO_FRIGORIFICO_COCINA")
	private BooleanDataType buenEstadoFrigorificoCocina;
	@MappedColumn("ESTADO_LAVAVAJILLAS_COCINA")
	private BooleanDataType buenEstadoLavavajillasCocina;
	@MappedColumn("ESTADO_MICROONDAS_COCINA")
	private BooleanDataType buenEstadoMicroondasCocina;
	@MappedColumn("ESTADO_HORNO_COCINA")
	private BooleanDataType buenEstadoHornoCocina;
	@MappedColumn("ESTADO_SUELO_COCINA")
	private BooleanDataType buenEstadoSueloCocina;
	@MappedColumn("ESTADO_AZULEJOS_COCINA")
	private BooleanDataType buenEstadoAzulejosCocina;
	@MappedColumn("ESTADO_GRIFERIA_MONOMANDO_COC")
	private BooleanDataType buenEstadoGriferiaMonomandoCocina;
	private StringDataType otrosCocina;
	@MappedColumn("ESTADO_DUCHA_BNY")
	private BooleanDataType buenEstadoDuchaBanyo;
	@MappedColumn("ESTADO_BANYERA_NORMAL_BNY")
	private BooleanDataType buenEstadoBanyeraNormalBanyo;
	@MappedColumn("ESTADO_BANYERA_HIDROMASAJE_BNY")
	private BooleanDataType buenEstadoBanyeraHidromasajeBanyo;
	@MappedColumn("ESTADO_COLUMNA_HIDROMASAJE_BNY")
	private BooleanDataType buenEstadoColumnaHidromasajeBanyo;
	@MappedColumn("ESTADO_ALICATADO_MARMOL_BNY")
	private BooleanDataType buenEstadoAlicatadoMarmolBanyo;
	@MappedColumn("ESTADO_ALICATADO_GRANITO_BNY")
	private BooleanDataType buenEstadoAlicatadoGranitoBanyo;
	@MappedColumn("ESTADO_ALICATADO_AZULEJO_BNY")
	private BooleanDataType buenEstadoAlicatadoAzulejoBanyo;
	@MappedColumn("ESTADO_ENCIMERA_MARMOL_BNY")
	private BooleanDataType buenEstadoEncimeraMarmolBanyo;
	@MappedColumn("ESTADO_ENCIMERA_GRANITO_BNY")
	private BooleanDataType buenEstadoEncimeraGranitoBanyo;
	@MappedColumn("ESTADO_ENCIMERA_MATERIAL_BNY")
	private BooleanDataType buenEstadoEncimeraMaterialBanyo;
	@MappedColumn("ESTADO_SANITARIOS_BNY")
	private BooleanDataType buenEstadoSanitariosBanyo;
	@MappedColumn("ESTADO_SUELO_BNY")
	private BooleanDataType buenEstadoSueloBanyo;
	@MappedColumn("ESTADO_GRIFERIA_MONOMANDO_BNY")
	private BooleanDataType buenEstadoGriferiaMonomandoBanyo;
	private StringDataType otrosBanyo;
	@MappedColumn("ESTADO_INS_ELECTR")
	private BooleanDataType buenEstadoInstalacionElectrica;
	@MappedColumn("INS_ELECTR_ANTIGUA_DEFECTUOSA")
	private BooleanDataType instalacionElectricaAntiguaODefectuosa;
	private BooleanDataType existeCalefaccionGasNatural;
	private BooleanDataType existenRadiadoresDeAluminio;
	private BooleanDataType existeAguaCalienteCentral;
	@MappedColumn("EXISTE_AGUA_CALIENTE_GAS_NAT")
	private BooleanDataType existeAguaCalienteGasNatural;
	@MappedColumn("EXISTE_AIRE_PREINSTALACION")
	private BooleanDataType existeAireAcondicionadoPreinstalacion;
	@MappedColumn("EXISTE_AIRE_INSTALACION")
	private BooleanDataType existeAireAcondicionadoInstalacion;
	@MappedColumn("EXISTE_AIRE_CALOR")
	private BooleanDataType existeAireAcondicionadoCalor;
	private StringDataType otrosInstalaciones;
	private BooleanDataType existenJardinesZonasVerdes;
	private BooleanDataType existePiscina;
	private BooleanDataType existePistaPadel;
	private BooleanDataType existePistaTenis;
	private BooleanDataType existePistaPolideportiva;
	private BooleanDataType existeGimnasio;
	private StringDataType otrosInstalacionesDeportivas;
	private BooleanDataType existeZonaInfantil;
	private BooleanDataType existeConserjeVigilancia;
	private StringDataType otrosZonasComunes;
	@MappedColumn("COD_TIPO_ADMITE_MASCOTA")
	private StringDataType codTipoAdmiteMascota;
	
	//Solicitud HREOS-1398
	private BooleanDataType aceptado;
	@WebcomRequired
	private StringDataType motivoRechazo;
	
	@WebcomRequired
	private LongDataType idInformeMediadorRem;
	@WebcomRequired
	private StringDataType codTipoVenta; 
	@WebcomRequired
	private StringDataType estadoInforme;
	@WebcomRequired
	private StringDataType codCartera;
	@WebcomRequired
	private StringDataType codSubCartera;
	@WebcomRequired
	private BooleanDataType perimetroMacc;
	@WebcomRequired
	private StringDataType codEstadoPublicacion;
	@WebcomRequired
	private StringDataType codSubfasePublicacion;
	@WebcomRequired
	private LongDataType codigoAgrupacionObraNueva;
	@WebcomRequired
	private LongDataType idLoteRem;
	@WebcomRequired
	private BooleanDataType esActivoPrincipal;
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
	private BooleanDataType publicado;
	@WebcomRequired
	private StringDataType codDetallePublicacion;
	@WebcomRequired
	private StringDataType codEstadoComercial;
	@WebcomRequired
	private StringDataType codEstadoOcupacional;
	@WebcomRequired
	private StringDataType codCee;
	@WebcomRequired
	private LongDataType numeroDormitorios;
	@WebcomRequired
	private BooleanDataType terraza;
	@WebcomRequired
	private BooleanDataType patio;
	@WebcomRequired
	private BooleanDataType rehabilitado;
	@WebcomRequired
	private StringDataType licenciaApertura;
	@WebcomRequired
	private DateDataType fechaRecepcionInforme;
	@WebcomRequired
	private StringDataType ultimaModificacionInformePor;
	@WebcomRequired
	private StringDataType primerEnvioInformeCompletado;
	
	@NestedDto(groupBy="idActivoHaya", type=PlantaDto.class)
	private List<PlantaDto> plantas;
	
	@NestedDto(groupBy="idActivoHaya", type=ActivoVinculadoDto.class)
	private List<ActivoVinculadoDto> activosVinculados;
	
	
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
	public LongDataType getIdInformeMediadorWebcom() {
		return idInformeMediadorWebcom;
	}
	public void setIdInformeMediadorWebcom(LongDataType idInformeMediadorWebcom) {
		this.idInformeMediadorWebcom = idInformeMediadorWebcom;
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
	public BooleanDataType getPosibleInforme() {
		return posibleInforme;
	}
	public void setPosibleInforme(BooleanDataType posibleInforme) {
		this.posibleInforme = posibleInforme;
	}
	public StringDataType getMotivoNoPosibleInforme() {
		return motivoNoPosibleInforme;
	}
	public void setMotivoNoPosibleInforme(StringDataType motivoNoPosibleInforme) {
		this.motivoNoPosibleInforme = motivoNoPosibleInforme;
	}
	public DateDataType getRecepcionLlavesHaya() {
		return recepcionLlavesHaya;
	}
	public void setRecepcionLlavesHaya(DateDataType recepcionLlavesHaya) {
		this.recepcionLlavesHaya = recepcionLlavesHaya;
	}
	public DateDataType getEnvioLlavesAApi() {
		return envioLlavesAApi;
	}
	public void setEnvioLlavesAApi(DateDataType envioLlavesAApi) {
		this.envioLlavesAApi = envioLlavesAApi;
	}
	public StringDataType getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(StringDataType fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	public LongDataType getNumeroRegistro() {
		return numeroRegistro;
	}
	public void setNumeroRegistro(LongDataType numeroRegistro) {
		this.numeroRegistro = numeroRegistro;
	}
	public StringDataType getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(StringDataType referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
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
	public DateDataType getUltimaModificacionInforme() {
		return ultimaModificacionInforme;
	}
	public void setUltimaModificacionInforme(DateDataType ultimaModificacionInforme) {
		this.ultimaModificacionInforme = ultimaModificacionInforme;
	}
	public DateDataType getFechaContratoDatosOcupacionales() {
		return fechaContratoDatosOcupacionales;
	}
	public void setFechaContratoDatosOcupacionales(DateDataType fechaContratoDatosOcupacionales) {
		this.fechaContratoDatosOcupacionales = fechaContratoDatosOcupacionales;
	}
	public DateDataType getPlazoContratoDatosOcupacionales() {
		return plazoContratoDatosOcupacionales;
	}
	public void setPlazoContratoDatosOcupacionales(DateDataType plazoContratoDatosOcupacionales) {
		this.plazoContratoDatosOcupacionales = plazoContratoDatosOcupacionales;
	}
	public DoubleDataType getRentaMensualDatosOcupacionales() {
		return rentaMensualDatosOcupacionales;
	}
	public void setRentaMensualDatosOcupacionales(DoubleDataType rentaMensualDatosOcupacionales) {
		this.rentaMensualDatosOcupacionales = rentaMensualDatosOcupacionales;
	}
	public DoubleDataType getRecibidoImporteDatosAdministracion() {
		return recibidoImporteDatosAdministracion;
	}
	public void setRecibidoImporteDatosAdministracion(DoubleDataType recibidoImporteDatosAdministracion) {
		this.recibidoImporteDatosAdministracion = recibidoImporteDatosAdministracion;
	}
	public DoubleDataType getIbiImporteDatosAdministracion() {
		return ibiImporteDatosAdministracion;
	}
	public void setIbiImporteDatosAdministracion(DoubleDataType ibiImporteDatosAdministracion) {
		this.ibiImporteDatosAdministracion = ibiImporteDatosAdministracion;
	}
	public DoubleDataType getDerramaImporteDatosAdministracion() {
		return derramaImporteDatosAdministracion;
	}
	public void setDerramaImporteDatosAdministracion(DoubleDataType derramaImporteDatosAdministracion) {
		this.derramaImporteDatosAdministracion = derramaImporteDatosAdministracion;
	}
	public StringDataType getDetalleDerramaDatosAdministracion() {
		return detalleDerramaDatosAdministracion;
	}
	public void setDetalleDerramaDatosAdministracion(StringDataType detalleDerramaDatosAdministracion) {
		this.detalleDerramaDatosAdministracion = detalleDerramaDatosAdministracion;
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
	public StringDataType getCodTipoVivienda() {
		return codTipoVivienda;
	}
	public void setCodTipoVivienda(StringDataType codTipoVivienda) {
		this.codTipoVivienda = codTipoVivienda;
	}
	public DateDataType getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}
	public void setFechaUltimaVisita(DateDataType fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
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
	public StringDataType getZona() {
		return zona;
	}
	public void setZona(StringDataType zona) {
		this.zona = zona;
	}
	public StringDataType getCodUbicacion() {
		return codUbicacion;
	}
	public void setCodUbicacion(StringDataType codUbicacion) {
		this.codUbicacion = codUbicacion;
	}
	public StringDataType getCodDistrito() {
		return codDistrito;
	}
	public void setCodDistrito(StringDataType codDistrito) {
		this.codDistrito = codDistrito;
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
	public DateDataType getFechaRecepcionLlavesApi() {
		return fechaRecepcionLlavesApi;
	}
	public void setFechaRecepcionLlavesApi(DateDataType fechaRecepcionLlavesApi) {
		this.fechaRecepcionLlavesApi = fechaRecepcionLlavesApi;
	}
	public StringDataType getCodMunicipioRegistro() {
		return codMunicipioRegistro;
	}
	public void setCodMunicipioRegistro(StringDataType codMunicipioRegistro) {
		this.codMunicipioRegistro = codMunicipioRegistro;
	}
	public StringDataType getCodRegimenProteccion() {
		return codRegimenProteccion;
	}
	public void setCodRegimenProteccion(StringDataType codRegimenProteccion) {
		this.codRegimenProteccion = codRegimenProteccion;
	}
	public DoubleDataType getValorMaximoVpo() {
		return valorMaximoVpo;
	}
	public void setValorMaximoVpo(DoubleDataType valorMaximoVpo) {
		this.valorMaximoVpo = valorMaximoVpo;
	}
	public StringDataType getCodTipoPropiedad() {
		return codTipoPropiedad;
	}
	public void setCodTipoPropiedad(StringDataType codTipoPropiedad) {
		this.codTipoPropiedad = codTipoPropiedad;
	}
	public DoubleDataType getPorcentajePropiedad() {
		return porcentajePropiedad;
	}
	public void setPorcentajePropiedad(DoubleDataType porcentajePropiedad) {
		this.porcentajePropiedad = porcentajePropiedad;
	}
	public DoubleDataType getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}
	public void setValorEstimadoVenta(DoubleDataType valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}
	public DateDataType getFechaValorEstimadoVenta() {
		return fechaValorEstimadoVenta;
	}
	public void setFechaValorEstimadoVenta(DateDataType fechaValorEstimadoVenta) {
		this.fechaValorEstimadoVenta = fechaValorEstimadoVenta;
	}
	public StringDataType getJustificacionValorEstimadoVenta() {
		return justificacionValorEstimadoVenta;
	}
	public void setJustificacionValorEstimadoVenta(StringDataType justificacionValorEstimadoVenta) {
		this.justificacionValorEstimadoVenta = justificacionValorEstimadoVenta;
	}
	public DoubleDataType getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}
	public void setValorEstimadoRenta(DoubleDataType valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}
	public DateDataType getFechaValorEstimadoRenta() {
		return fechaValorEstimadoRenta;
	}
	public void setFechaValorEstimadoRenta(DateDataType fechaValorEstimadoRenta) {
		this.fechaValorEstimadoRenta = fechaValorEstimadoRenta;
	}
	public StringDataType getJustificacionValorEstimadoRenta() {
		return justificacionValorEstimadoRenta;
	}
	public void setJustificacionValorEstimadoRenta(StringDataType justificacionValorEstimadoRenta) {
		this.justificacionValorEstimadoRenta = justificacionValorEstimadoRenta;
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
	public StringDataType getCodEstadoConservacion() {
		return codEstadoConservacion;
	}
	public void setCodEstadoConservacion(StringDataType codEstadoConservacion) {
		this.codEstadoConservacion = codEstadoConservacion;
	}
	public LongDataType getAnyoConstruccion() {
		return anyoConstruccion;
	}
	public void setAnyoConstruccion(LongDataType anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}
	public LongDataType getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}
	public void setAnyoRehabilitacion(LongDataType anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}
	public StringDataType getCodOrientacion() {
		return codOrientacion;
	}
	public void setCodOrientacion(StringDataType codOrientacion) {
		this.codOrientacion = codOrientacion;
	}
	public BooleanDataType getUltimaPlanta() {
		return ultimaPlanta;
	}
	public void setUltimaPlanta(BooleanDataType ultimaPlanta) {
		this.ultimaPlanta = ultimaPlanta;
	}
	public BooleanDataType getOcupado() {
		return ocupado;
	}
	public void setOcupado(BooleanDataType ocupado) {
		this.ocupado = ocupado;
	}
	public LongDataType getNumeroPlantas() {
		return numeroPlantas;
	}
	public void setNumeroPlantas(LongDataType numeroPlantas) {
		this.numeroPlantas = numeroPlantas;
	}
	public StringDataType getCodNivelRenta() {
		return codNivelRenta;
	}
	public void setCodNivelRenta(StringDataType codNivelRenta) {
		this.codNivelRenta = codNivelRenta;
	}
	public LongDataType getNumeroTerrazasDescubiertas() {
		return numeroTerrazasDescubiertas;
	}
	public void setNumeroTerrazasDescubiertas(LongDataType numeroTerrazasDescubiertas) {
		this.numeroTerrazasDescubiertas = numeroTerrazasDescubiertas;
	}
	public StringDataType getDescripcionTerrazasDescubiertas() {
		return descripcionTerrazasDescubiertas;
	}
	public void setDescripcionTerrazasDescubiertas(StringDataType descripcionTerrazasDescubiertas) {
		this.descripcionTerrazasDescubiertas = descripcionTerrazasDescubiertas;
	}
	public LongDataType getNumeroTerrazasCubiertas() {
		return numeroTerrazasCubiertas;
	}
	public void setNumeroTerrazasCubiertas(LongDataType numeroTerrazasCubiertas) {
		this.numeroTerrazasCubiertas = numeroTerrazasCubiertas;
	}
	public StringDataType getDescripcionTerrazasCubiertas() {
		return descripcionTerrazasCubiertas;
	}
	public void setDescripcionTerrazasCubiertas(StringDataType descripcionTerrazasCubiertas) {
		this.descripcionTerrazasCubiertas = descripcionTerrazasCubiertas;
	}
	public BooleanDataType getDespensaOtrasDependencias() {
		return despensaOtrasDependencias;
	}
	public void setDespensaOtrasDependencias(BooleanDataType despensaOtrasDependencias) {
		this.despensaOtrasDependencias = despensaOtrasDependencias;
	}
	public BooleanDataType getLavaderoOtrasDependencias() {
		return lavaderoOtrasDependencias;
	}
	public void setLavaderoOtrasDependencias(BooleanDataType lavaderoOtrasDependencias) {
		this.lavaderoOtrasDependencias = lavaderoOtrasDependencias;
	}
	public BooleanDataType getAzoteaOtrasDependencias() {
		return azoteaOtrasDependencias;
	}
	public void setAzoteaOtrasDependencias(BooleanDataType azoteaOtrasDependencias) {
		this.azoteaOtrasDependencias = azoteaOtrasDependencias;
	}
	public StringDataType getOtrosOtrasDependencias() {
		return otrosOtrasDependencias;
	}
	public void setOtrosOtrasDependencias(StringDataType otrosOtrasDependencias) {
		this.otrosOtrasDependencias = otrosOtrasDependencias;
	}
	/*public BooleanDataType getInstalacionElectricidadInstalaciones() {
		return instalacionElectricidadInstalaciones;
	}
	public void setInstalacionElectricidadInstalaciones(BooleanDataType instalacionElectricidadInstalaciones) {
		this.instalacionElectricidadInstalaciones = instalacionElectricidadInstalaciones;
	}
	public BooleanDataType getContadorElectricidadInstalaciones() {
		return contadorElectricidadInstalaciones;
	}
	public void setContadorElectricidadInstalaciones(BooleanDataType contadorElectricidadInstalaciones) {
		this.contadorElectricidadInstalaciones = contadorElectricidadInstalaciones;
	}
	public BooleanDataType getInstalacionAguaInstalaciones() {
		return instalacionAguaInstalaciones;
	}
	public void setInstalacionAguaInstalaciones(BooleanDataType instalacionAguaInstalaciones) {
		this.instalacionAguaInstalaciones = instalacionAguaInstalaciones;
	}
	public BooleanDataType getContadorAguaInstalaciones() {
		return contadorAguaInstalaciones;
	}
	public void setContadorAguaInstalaciones(BooleanDataType contadorAguaInstalaciones) {
		this.contadorAguaInstalaciones = contadorAguaInstalaciones;
	}
	public BooleanDataType getGasInstalaciones() {
		return gasInstalaciones;
	}
	public void setGasInstalaciones(BooleanDataType gasInstalaciones) {
		this.gasInstalaciones = gasInstalaciones;
	}
	public BooleanDataType getContadorGasInstalacion() {
		return contadorGasInstalacion;
	}
	public void setContadorGasInstalacion(BooleanDataType contadorGasInstalacion) {
		this.contadorGasInstalacion = contadorGasInstalacion;
	}*/
	public BooleanDataType getExteriorCarpinteriaReformasNecesarias() {
		return exteriorCarpinteriaReformasNecesarias;
	}
	public void setExteriorCarpinteriaReformasNecesarias(BooleanDataType exteriorCarpinteriaReformasNecesarias) {
		this.exteriorCarpinteriaReformasNecesarias = exteriorCarpinteriaReformasNecesarias;
	}
	public BooleanDataType getInteriorCarpinteriaReformasNecesarias() {
		return interiorCarpinteriaReformasNecesarias;
	}
	public void setInteriorCarpinteriaReformasNecesarias(BooleanDataType interiorCarpinteriaReformasNecesarias) {
		this.interiorCarpinteriaReformasNecesarias = interiorCarpinteriaReformasNecesarias;
	}
	public BooleanDataType getCocinaReformasNecesarias() {
		return cocinaReformasNecesarias;
	}
	public void setCocinaReformasNecesarias(BooleanDataType cocinaReformasNecesarias) {
		this.cocinaReformasNecesarias = cocinaReformasNecesarias;
	}
	public BooleanDataType getSuelosReformasNecesarias() {
		return suelosReformasNecesarias;
	}
	public void setSuelosReformasNecesarias(BooleanDataType suelosReformasNecesarias) {
		this.suelosReformasNecesarias = suelosReformasNecesarias;
	}
	public BooleanDataType getPinturaReformasNecesarias() {
		return pinturaReformasNecesarias;
	}
	public void setPinturaReformasNecesarias(BooleanDataType pinturaReformasNecesarias) {
		this.pinturaReformasNecesarias = pinturaReformasNecesarias;
	}
	public BooleanDataType getIntegralReformasNecesarias() {
		return integralReformasNecesarias;
	}
	public void setIntegralReformasNecesarias(BooleanDataType integralReformasNecesarias) {
		this.integralReformasNecesarias = integralReformasNecesarias;
	}
	public BooleanDataType getBanyosReformasNecesarias() {
		return banyosReformasNecesarias;
	}
	public void setBanyosReformasNecesarias(BooleanDataType banyosReformasNecesarias) {
		this.banyosReformasNecesarias = banyosReformasNecesarias;
	}
	public StringDataType getOtrasReformasNecesarias() {
		return otrasReformasNecesarias;
	}
	public void setOtrasReformasNecesarias(StringDataType otrasReformasNecesarias) {
		this.otrasReformasNecesarias = otrasReformasNecesarias;
	}
	public DoubleDataType getOtrasReformasNecesariasImporteAproximado() {
		return otrasReformasNecesariasImporteAproximado;
	}
	public void setOtrasReformasNecesariasImporteAproximado(DoubleDataType otrasReformasNecesariasImporteAproximado) {
		this.otrasReformasNecesariasImporteAproximado = otrasReformasNecesariasImporteAproximado;
	}
	public StringDataType getDistribucionInterior() {
		return distribucionInterior;
	}
	public void setDistribucionInterior(StringDataType distribucionInterior) {
		this.distribucionInterior = distribucionInterior;
	}
	public BooleanDataType getDivisible() {
		return divisible;
	}
	public void setDivisible(BooleanDataType divisible) {
		this.divisible = divisible;
	}
	public BooleanDataType getAscensor() {
		return ascensor;
	}
	public void setAscensor(BooleanDataType ascensor) {
		this.ascensor = ascensor;
	}
	public LongDataType getNumeroAscensores() {
		return numeroAscensores;
	}
	public void setNumeroAscensores(LongDataType numeroAscensores) {
		this.numeroAscensores = numeroAscensores;
	}
	public StringDataType getDescripcionPlantas() {
		return descripcionPlantas;
	}
	public void setDescripcionPlantas(StringDataType descripcionPlantas) {
		this.descripcionPlantas = descripcionPlantas;
	}
	public StringDataType getOtrasCaracteristicas() {
		return otrasCaracteristicas;
	}
	public void setOtrasCaracteristicas(StringDataType otrasCaracteristicas) {
		this.otrasCaracteristicas = otrasCaracteristicas;
	}
	public BooleanDataType getFachadaReformasNecesarias() {
		return fachadaReformasNecesarias;
	}
	public void setFachadaReformasNecesarias(BooleanDataType fachadaReformasNecesarias) {
		this.fachadaReformasNecesarias = fachadaReformasNecesarias;
	}
	public BooleanDataType getEscaleraReformasNecesarias() {
		return escaleraReformasNecesarias;
	}
	public void setEscaleraReformasNecesarias(BooleanDataType escaleraReformasNecesarias) {
		this.escaleraReformasNecesarias = escaleraReformasNecesarias;
	}
	public BooleanDataType getPortalReformasNecesarias() {
		return portalReformasNecesarias;
	}
	public void setPortalReformasNecesarias(BooleanDataType portalReformasNecesarias) {
		this.portalReformasNecesarias = portalReformasNecesarias;
	}
	public BooleanDataType getAscensorReformasNecesarias() {
		return ascensorReformasNecesarias;
	}
	public void setAscensorReformasNecesarias(BooleanDataType ascensorReformasNecesarias) {
		this.ascensorReformasNecesarias = ascensorReformasNecesarias;
	}
	public BooleanDataType getCubierta() {
		return cubierta;
	}
	public void setCubierta(BooleanDataType cubierta) {
		this.cubierta = cubierta;
	}
	public BooleanDataType getOtrasZonasComunesReformasNecesarias() {
		return otrasZonasComunesReformasNecesarias;
	}
	public void setOtrasZonasComunesReformasNecesarias(BooleanDataType otrasZonasComunesReformasNecesarias) {
		this.otrasZonasComunesReformasNecesarias = otrasZonasComunesReformasNecesarias;
	}
	public StringDataType getOtrosReformasNecesarias() {
		return otrosReformasNecesarias;
	}
	public void setOtrosReformasNecesarias(StringDataType otrosReformasNecesarias) {
		this.otrosReformasNecesarias = otrosReformasNecesarias;
	}
	public StringDataType getDescripcionEdificio() {
		return descripcionEdificio;
	}
	public void setDescripcionEdificio(StringDataType descripcionEdificio) {
		this.descripcionEdificio = descripcionEdificio;
	}
	public StringDataType getInfraestructurasEntorno() {
		return infraestructurasEntorno;
	}
	public void setInfraestructurasEntorno(StringDataType infraestructurasEntorno) {
		this.infraestructurasEntorno = infraestructurasEntorno;
	}
	public StringDataType getComunicacionesEntorno() {
		return comunicacionesEntorno;
	}
	public void setComunicacionesEntorno(StringDataType comunicacionesEntorno) {
		this.comunicacionesEntorno = comunicacionesEntorno;
	}
	public StringDataType getIdoneoUso() {
		return idoneoUso;
	}
	public void setIdoneoUso(StringDataType idoneoUso) {
		this.idoneoUso = idoneoUso;
	}
	public BooleanDataType getExisteAnteriorUso() {
		return existeAnteriorUso;
	}
	public void setExisteAnteriorUso(BooleanDataType existeAnteriorUso) {
		this.existeAnteriorUso = existeAnteriorUso;
	}
	public StringDataType getAnteriorUso() {
		return anteriorUso;
	}
	public void setAnteriorUso(StringDataType anteriorUso) {
		this.anteriorUso = anteriorUso;
	}
	public LongDataType getNumeroEstancias() {
		return numeroEstancias;
	}
	public void setNumeroEstancias(LongDataType numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}
	public LongDataType getNumeroBanyos() {
		return numeroBanyos;
	}
	public void setNumeroBanyos(LongDataType numeroBanyos) {
		this.numeroBanyos = numeroBanyos;
	}
	public LongDataType getNumeroAseos() {
		return numeroAseos;
	}
	public void setNumeroAseos(LongDataType numeroAseos) {
		this.numeroAseos = numeroAseos;
	}
	public DoubleDataType getMetrosLinealesFachadaPrincipal() {
		return metrosLinealesFachadaPrincipal;
	}
	public void setMetrosLinealesFachadaPrincipal(DoubleDataType metrosLinealesFachadaPrincipal) {
		this.metrosLinealesFachadaPrincipal = metrosLinealesFachadaPrincipal;
	}
	public DoubleDataType getAltura() {
		return altura;
	}
	public void setAltura(DoubleDataType altura) {
		this.altura = altura;
	}
	public BooleanDataType getExisteAnejoTrastero() {
		return existeAnejoTrastero;
	}
	public void setExisteAnejoTrastero(BooleanDataType existeAnejoTrastero) {
		this.existeAnejoTrastero = existeAnejoTrastero;
	}
	public StringDataType getAnejoTrastero() {
		return anejoTrastero;
	}
	public void setAnejoTrastero(StringDataType anejoTrastero) {
		this.anejoTrastero = anejoTrastero;
	}
	public StringDataType getAnejoGarage() {
		return anejoGarage;
	}
	public void setAnejoGarage(StringDataType anejoGarage) {
		this.anejoGarage = anejoGarage;
	}
	public LongDataType getNumeroPlazasGaraje() {
		return numeroPlazasGaraje;
	}
	public void setNumeroPlazasGaraje(LongDataType numeroPlazasGaraje) {
		this.numeroPlazasGaraje = numeroPlazasGaraje;
	}
	public DoubleDataType getSuperficiePlazasGaraje() {
		return superficiePlazasGaraje;
	}
	public void setSuperficiePlazasGaraje(DoubleDataType superficiePlazasGaraje) {
		this.superficiePlazasGaraje = superficiePlazasGaraje;
	}
	public StringDataType getCodSubtipoPlazasGaraje() {
		return codSubtipoPlazasGaraje;
	}
	public void setCodSubtipoPlazasGaraje(StringDataType codSubtipoPlazasGaraje) {
		this.codSubtipoPlazasGaraje = codSubtipoPlazasGaraje;
	}
	public BooleanDataType getSalidaHumosOtrasCaracteristicas() {
		return salidaHumosOtrasCaracteristicas;
	}
	public void setSalidaHumosOtrasCaracteristicas(BooleanDataType salidaHumosOtrasCaracteristicas) {
		this.salidaHumosOtrasCaracteristicas = salidaHumosOtrasCaracteristicas;
	}
	public BooleanDataType getSalidaEmergenciaOtrasCaracteristicas() {
		return salidaEmergenciaOtrasCaracteristicas;
	}
	public void setSalidaEmergenciaOtrasCaracteristicas(BooleanDataType salidaEmergenciaOtrasCaracteristicas) {
		this.salidaEmergenciaOtrasCaracteristicas = salidaEmergenciaOtrasCaracteristicas;
	}
	public BooleanDataType getAccesoMinusvalidosOtrasCaracteristicas() {
		return accesoMinusvalidosOtrasCaracteristicas;
	}
	public void setAccesoMinusvalidosOtrasCaracteristicas(BooleanDataType accesoMinusvalidosOtrasCaracteristicas) {
		this.accesoMinusvalidosOtrasCaracteristicas = accesoMinusvalidosOtrasCaracteristicas;
	}
	public StringDataType getOtrosOtrasCaracteristicas() {
		return otrosOtrasCaracteristicas;
	}
	public void setOtrosOtrasCaracteristicas(StringDataType otrosOtrasCaracteristicas) {
		this.otrosOtrasCaracteristicas = otrosOtrasCaracteristicas;
	}
	public StringDataType getCodTipoVario() {
		return codTipoVario;
	}
	public void setCodTipoVario(StringDataType codTipoVario) {
		this.codTipoVario = codTipoVario;
	}
	public DoubleDataType getAncho() {
		return ancho;
	}
	public void setAncho(DoubleDataType ancho) {
		this.ancho = ancho;
	}
	public DoubleDataType getAlto() {
		return alto;
	}
	public void setAlto(DoubleDataType alto) {
		this.alto = alto;
	}
	public DoubleDataType getLargo() {
		return largo;
	}
	public void setLargo(DoubleDataType largo) {
		this.largo = largo;
	}
	public StringDataType getCodUso() {
		return codUso;
	}
	public void setCodUso(StringDataType codUso) {
		this.codUso = codUso;
	}
	public StringDataType getCodManiobrabilidad() {
		return codManiobrabilidad;
	}
	public void setCodManiobrabilidad(StringDataType codManiobrabilidad) {
		this.codManiobrabilidad = codManiobrabilidad;
	}
	public BooleanDataType getLicenciaOtrasCaracteristicas() {
		return licenciaOtrasCaracteristicas;
	}
	public void setLicenciaOtrasCaracteristicas(BooleanDataType licenciaOtrasCaracteristicas) {
		this.licenciaOtrasCaracteristicas = licenciaOtrasCaracteristicas;
	}
	public BooleanDataType getServidumbreOtrasCaracteristicas() {
		return servidumbreOtrasCaracteristicas;
	}
	public void setServidumbreOtrasCaracteristicas(BooleanDataType servidumbreOtrasCaracteristicas) {
		this.servidumbreOtrasCaracteristicas = servidumbreOtrasCaracteristicas;
	}
	public BooleanDataType getAscensorOMontacargasOtrasCaracteristicas() {
		return ascensorOMontacargasOtrasCaracteristicas;
	}
	public void setAscensorOMontacargasOtrasCaracteristicas(BooleanDataType ascensorOMontacargasOtrasCaracteristicas) {
		this.ascensorOMontacargasOtrasCaracteristicas = ascensorOMontacargasOtrasCaracteristicas;
	}
	public BooleanDataType getColumnasOtrasCaracteristicas() {
		return columnasOtrasCaracteristicas;
	}
	public void setColumnasOtrasCaracteristicas(BooleanDataType columnasOtrasCaracteristicas) {
		this.columnasOtrasCaracteristicas = columnasOtrasCaracteristicas;
	}
	public BooleanDataType getSeguridadOtrasCaracteristicas() {
		return seguridadOtrasCaracteristicas;
	}
	public void setSeguridadOtrasCaracteristicas(BooleanDataType seguridadOtrasCaracteristicas) {
		this.seguridadOtrasCaracteristicas = seguridadOtrasCaracteristicas;
	}
	public BooleanDataType getBuenEstadoInstalacionElectricidadInstalaciones() {
		return buenEstadoInstalacionElectricidadInstalaciones;
	}
	public void setBuenEstadoInstalacionElectricidadInstalaciones(
			BooleanDataType buenEstadoInstalacionElectricidadInstalaciones) {
		this.buenEstadoInstalacionElectricidadInstalaciones = buenEstadoInstalacionElectricidadInstalaciones;
	}
	public BooleanDataType getBuenEstadoContadorElectricidadInstalaciones() {
		return buenEstadoContadorElectricidadInstalaciones;
	}
	public void setBuenEstadoContadorElectricidadInstalaciones(
			BooleanDataType buenEstadoContadorElectricidadInstalaciones) {
		this.buenEstadoContadorElectricidadInstalaciones = buenEstadoContadorElectricidadInstalaciones;
	}
	public BooleanDataType getBuenEstadoInstalacionAguaInstalaciones() {
		return buenEstadoInstalacionAguaInstalaciones;
	}
	public void setBuenEstadoInstalacionAguaInstalaciones(BooleanDataType buenEstadoInstalacionAguaInstalaciones) {
		this.buenEstadoInstalacionAguaInstalaciones = buenEstadoInstalacionAguaInstalaciones;
	}
	public BooleanDataType getBuenEstadoContadorAguaInstalaciones() {
		return buenEstadoContadorAguaInstalaciones;
	}
	public void setBuenEstadoContadorAguaInstalaciones(BooleanDataType buenEstadoContadorAguaInstalaciones) {
		this.buenEstadoContadorAguaInstalaciones = buenEstadoContadorAguaInstalaciones;
	}
	public BooleanDataType getBuenEstadoGasInstalaciones() {
		return buenEstadoGasInstalaciones;
	}
	public void setBuenEstadoGasInstalaciones(BooleanDataType buenEstadoGasInstalaciones) {
		this.buenEstadoGasInstalaciones = buenEstadoGasInstalaciones;
	}
	public BooleanDataType getBuenEstadoContadorGasInstalacion() {
		return buenEstadoContadorGasInstalacion;
	}
	public void setBuenEstadoContadorGasInstalacion(BooleanDataType buenEstadoContadorGasInstalacion) {
		this.buenEstadoContadorGasInstalacion = buenEstadoContadorGasInstalacion;
	}
	public StringDataType getCodEstadoConservacionEdificio() {
		return codEstadoConservacionEdificio;
	}
	public void setCodEstadoConservacionEdificio(
			StringDataType codEstadoConservacionEdificio) {
		this.codEstadoConservacionEdificio = codEstadoConservacionEdificio;
	}
	/*	public BooleanDataType getBuenEstadoConservacionEdificio() {
		return buenEstadoConservacionEdificio;
	}
	public void setBuenEstadoConservacionEdificio(BooleanDataType buenEstadoConservacionEdificio) {
		this.buenEstadoConservacionEdificio = buenEstadoConservacionEdificio;
	}*/
	public LongDataType getAnyoRehabilitacionEdificio() {
		return anyoRehabilitacionEdificio;
	}
	public void setAnyoRehabilitacionEdificio(LongDataType anyoRehabilitacionEdificio) {
		this.anyoRehabilitacionEdificio = anyoRehabilitacionEdificio;
	}
	public LongDataType getNumeroPlantasEdificio() {
		return numeroPlantasEdificio;
	}
	public void setNumeroPlantasEdificio(LongDataType numeroPlantasEdificio) {
		this.numeroPlantasEdificio = numeroPlantasEdificio;
	}
	public BooleanDataType getAscensorEdificio() {
		return ascensorEdificio;
	}
	public void setAscensorEdificio(BooleanDataType ascensorEdificio) {
		this.ascensorEdificio = ascensorEdificio;
	}
	public LongDataType getNumeroAscensoresEdificio() {
		return numeroAscensoresEdificio;
	}
	public void setNumeroAscensoresEdificio(LongDataType numeroAscensoresEdificio) {
		this.numeroAscensoresEdificio = numeroAscensoresEdificio;
	}
	public BooleanDataType getExisteComunidadEdificio() {
		return existeComunidadEdificio;
	}
	public void setExisteComunidadEdificio(BooleanDataType existeComunidadEdificio) {
		this.existeComunidadEdificio = existeComunidadEdificio;
	}
	public DoubleDataType getCuotaComunidadEdificio() {
		return cuotaComunidadEdificio;
	}
	public void setCuotaComunidadEdificio(DoubleDataType cuotaComunidadEdificio) {
		this.cuotaComunidadEdificio = cuotaComunidadEdificio;
	}
	public StringDataType getNombrePresidenteComunidadEdificio() {
		return nombrePresidenteComunidadEdificio;
	}
	public void setNombrePresidenteComunidadEdificio(StringDataType nombrePresidenteComunidadEdificio) {
		this.nombrePresidenteComunidadEdificio = nombrePresidenteComunidadEdificio;
	}
	public StringDataType getTelefonoPresidenteComunidadEdificio() {
		return telefonoPresidenteComunidadEdificio;
	}
	public void setTelefonoPresidenteComunidadEdificio(StringDataType telefonoPresidenteComunidadEdificio) {
		this.telefonoPresidenteComunidadEdificio = telefonoPresidenteComunidadEdificio;
	}
	public StringDataType getNombreAdministradorComunidadEdificio() {
		return nombreAdministradorComunidadEdificio;
	}
	public void setNombreAdministradorComunidadEdificio(StringDataType nombreAdministradorComunidadEdificio) {
		this.nombreAdministradorComunidadEdificio = nombreAdministradorComunidadEdificio;
	}
	public StringDataType getTelefonoAdministradorComunidadEdificio() {
		return telefonoAdministradorComunidadEdificio;
	}
	public void setTelefonoAdministradorComunidadEdificio(StringDataType telefonoAdministradorComunidadEdificio) {
		this.telefonoAdministradorComunidadEdificio = telefonoAdministradorComunidadEdificio;
	}
	public StringDataType getDescripcionDerramaComunidadEdificio() {
		return descripcionDerramaComunidadEdificio;
	}
	public void setDescripcionDerramaComunidadEdificio(StringDataType descripcionDerramaComunidadEdificio) {
		this.descripcionDerramaComunidadEdificio = descripcionDerramaComunidadEdificio;
	}
	public BooleanDataType getFachadaReformasNecesariasEdificio() {
		return fachadaReformasNecesariasEdificio;
	}
	public void setFachadaReformasNecesariasEdificio(BooleanDataType fachadaReformasNecesariasEdificio) {
		this.fachadaReformasNecesariasEdificio = fachadaReformasNecesariasEdificio;
	}
	public BooleanDataType getEscaleraReformasNecesariasEdificio() {
		return escaleraReformasNecesariasEdificio;
	}
	public void setEscaleraReformasNecesariasEdificio(BooleanDataType escaleraReformasNecesariasEdificio) {
		this.escaleraReformasNecesariasEdificio = escaleraReformasNecesariasEdificio;
	}
	public BooleanDataType getPortalReformasNecesariasEdificio() {
		return portalReformasNecesariasEdificio;
	}
	public void setPortalReformasNecesariasEdificio(BooleanDataType portalReformasNecesariasEdificio) {
		this.portalReformasNecesariasEdificio = portalReformasNecesariasEdificio;
	}
	public BooleanDataType getAscensorReformasNecesariasEdificio() {
		return ascensorReformasNecesariasEdificio;
	}
	public void setAscensorReformasNecesariasEdificio(BooleanDataType ascensorReformasNecesariasEdificio) {
		this.ascensorReformasNecesariasEdificio = ascensorReformasNecesariasEdificio;
	}
	public BooleanDataType getCubiertaReformasNecesariasEdificio() {
		return cubiertaReformasNecesariasEdificio;
	}
	public void setCubiertaReformasNecesariasEdificio(BooleanDataType cubiertaReformasNecesariasEdificio) {
		this.cubiertaReformasNecesariasEdificio = cubiertaReformasNecesariasEdificio;
	}
	public BooleanDataType getOtrasZonasComunesReformasNecesariasEdificio() {
		return otrasZonasComunesReformasNecesariasEdificio;
	}
	public void setOtrasZonasComunesReformasNecesariasEdificio(
			BooleanDataType otrasZonasComunesReformasNecesariasEdificio) {
		this.otrasZonasComunesReformasNecesariasEdificio = otrasZonasComunesReformasNecesariasEdificio;
	}
	public StringDataType getOtrosReformasNecesariasEdificio() {
		return otrosReformasNecesariasEdificio;
	}
	public void setOtrosReformasNecesariasEdificio(StringDataType otrosReformasNecesariasEdificio) {
		this.otrosReformasNecesariasEdificio = otrosReformasNecesariasEdificio;
	}
	public StringDataType getInfraestructurasEntornoEdificio() {
		return infraestructurasEntornoEdificio;
	}
	public void setInfraestructurasEntornoEdificio(StringDataType infraestructurasEntornoEdificio) {
		this.infraestructurasEntornoEdificio = infraestructurasEntornoEdificio;
	}
	public StringDataType getComunicacionesEntornoEdificio() {
		return comunicacionesEntornoEdificio;
	}
	public void setComunicacionesEntornoEdificio(StringDataType comunicacionesEntornoEdificio) {
		this.comunicacionesEntornoEdificio = comunicacionesEntornoEdificio;
	}
	public BooleanDataType getExisteOcio() {
		return existeOcio;
	}
	public void setExisteOcio(BooleanDataType existeOcio) {
		this.existeOcio = existeOcio;
	}
	public BooleanDataType getExistenHoteles() {
		return existenHoteles;
	}
	public void setExistenHoteles(BooleanDataType existenHoteles) {
		this.existenHoteles = existenHoteles;
	}
	public StringDataType getHoteles() {
		return hoteles;
	}
	public void setHoteles(StringDataType hoteles) {
		this.hoteles = hoteles;
	}
	public BooleanDataType getExistenTeatros() {
		return existenTeatros;
	}
	public void setExistenTeatros(BooleanDataType existenTeatros) {
		this.existenTeatros = existenTeatros;
	}
	public StringDataType getTeatros() {
		return teatros;
	}
	public void setTeatros(StringDataType teatros) {
		this.teatros = teatros;
	}
	public BooleanDataType getExistenSalasDeCine() {
		return existenSalasDeCine;
	}
	public void setExistenSalasDeCine(BooleanDataType existenSalasDeCine) {
		this.existenSalasDeCine = existenSalasDeCine;
	}
	public StringDataType getSalasDeCine() {
		return salasDeCine;
	}
	public void setSalasDeCine(StringDataType salasDeCine) {
		this.salasDeCine = salasDeCine;
	}
	public BooleanDataType getExistenInstalacionesDeportivas() {
		return existenInstalacionesDeportivas;
	}
	public void setExistenInstalacionesDeportivas(BooleanDataType existenInstalacionesDeportivas) {
		this.existenInstalacionesDeportivas = existenInstalacionesDeportivas;
	}
	public StringDataType getInstalacionesDeportivas() {
		return instalacionesDeportivas;
	}
	public void setInstalacionesDeportivas(StringDataType instalacionesDeportivas) {
		this.instalacionesDeportivas = instalacionesDeportivas;
	}
	public BooleanDataType getExistenCentrosComerciales() {
		return existenCentrosComerciales;
	}
	public void setExistenCentrosComerciales(BooleanDataType existenCentrosComerciales) {
		this.existenCentrosComerciales = existenCentrosComerciales;
	}
	public StringDataType getCentrosComerciales() {
		return centrosComerciales;
	}
	public void setCentrosComerciales(StringDataType centrosComerciales) {
		this.centrosComerciales = centrosComerciales;
	}
	public StringDataType getOtrosOcio() {
		return otrosOcio;
	}
	public void setOtrosOcio(StringDataType otrosOcio) {
		this.otrosOcio = otrosOcio;
	}
	public BooleanDataType getExistenCentrosEducativos() {
		return existenCentrosEducativos;
	}
	public void setExistenCentrosEducativos(BooleanDataType existenCentrosEducativos) {
		this.existenCentrosEducativos = existenCentrosEducativos;
	}
	public BooleanDataType getExistenEscuelasInfantiles() {
		return existenEscuelasInfantiles;
	}
	public void setExistenEscuelasInfantiles(BooleanDataType existenEscuelasInfantiles) {
		this.existenEscuelasInfantiles = existenEscuelasInfantiles;
	}
	public StringDataType getEscuelasInfantiles() {
		return escuelasInfantiles;
	}
	public void setEscuelasInfantiles(StringDataType escuelasInfantiles) {
		this.escuelasInfantiles = escuelasInfantiles;
	}
	public BooleanDataType getExistenColegios() {
		return existenColegios;
	}
	public void setExistenColegios(BooleanDataType existenColegios) {
		this.existenColegios = existenColegios;
	}
	public StringDataType getColegios() {
		return colegios;
	}
	public void setColegios(StringDataType colegios) {
		this.colegios = colegios;
	}
	public BooleanDataType getExistenInstitutos() {
		return existenInstitutos;
	}
	public void setExistenInstitutos(BooleanDataType existenInstitutos) {
		this.existenInstitutos = existenInstitutos;
	}
	public StringDataType getInstitutos() {
		return institutos;
	}
	public void setInstitutos(StringDataType institutos) {
		this.institutos = institutos;
	}
	public BooleanDataType getExistenUniversidades() {
		return existenUniversidades;
	}
	public void setExistenUniversidades(BooleanDataType existenUniversidades) {
		this.existenUniversidades = existenUniversidades;
	}
	public StringDataType getUniversidades() {
		return universidades;
	}
	public void setUniversidades(StringDataType universidades) {
		this.universidades = universidades;
	}
	public StringDataType getOtrosCentrosEducativos() {
		return otrosCentrosEducativos;
	}
	public void setOtrosCentrosEducativos(StringDataType otrosCentrosEducativos) {
		this.otrosCentrosEducativos = otrosCentrosEducativos;
	}
	public BooleanDataType getExistenCentrosSanitarios() {
		return existenCentrosSanitarios;
	}
	public void setExistenCentrosSanitarios(BooleanDataType existenCentrosSanitarios) {
		this.existenCentrosSanitarios = existenCentrosSanitarios;
	}
	public BooleanDataType getExistenCentrosDeSalud() {
		return existenCentrosDeSalud;
	}
	public void setExistenCentrosDeSalud(BooleanDataType existenCentrosDeSalud) {
		this.existenCentrosDeSalud = existenCentrosDeSalud;
	}
	public StringDataType getCentrosDeSalud() {
		return centrosDeSalud;
	}
	public void setCentrosDeSalud(StringDataType centrosDeSalud) {
		this.centrosDeSalud = centrosDeSalud;
	}
	public BooleanDataType getExistenClinicas() {
		return existenClinicas;
	}
	public void setExistenClinicas(BooleanDataType existenClinicas) {
		this.existenClinicas = existenClinicas;
	}
	public StringDataType getClinicas() {
		return clinicas;
	}
	public void setClinicas(StringDataType clinicas) {
		this.clinicas = clinicas;
	}
	public BooleanDataType getExistenHospitales() {
		return existenHospitales;
	}
	public void setExistenHospitales(BooleanDataType existenHospitales) {
		this.existenHospitales = existenHospitales;
	}
	public StringDataType getHospitales() {
		return hospitales;
	}
	public void setHospitales(StringDataType hospitales) {
		this.hospitales = hospitales;
	}
	public BooleanDataType getExistenOtrosCentrosSanitarios() {
		return existenOtrosCentrosSanitarios;
	}
	public void setExistenOtrosCentrosSanitarios(BooleanDataType existenOtrosCentrosSanitarios) {
		this.existenOtrosCentrosSanitarios = existenOtrosCentrosSanitarios;
	}
	public StringDataType getOtrosCentrosSanitarios() {
		return otrosCentrosSanitarios;
	}
	public void setOtrosCentrosSanitarios(StringDataType otrosCentrosSanitarios) {
		this.otrosCentrosSanitarios = otrosCentrosSanitarios;
	}
/*	public StringDataType getCodTipoAparcamientoEnSuperficie() {
		return codTipoAparcamientoEnSuperficie;
	}
	public void setCodTipoAparcamientoEnSuperficie(StringDataType codTipoAparcamientoEnSuperficie) {
		this.codTipoAparcamientoEnSuperficie = codTipoAparcamientoEnSuperficie;
	}*/
	public BooleanDataType getSuficienteAparcamientoEnSuperficie() {
		return suficienteAparcamientoEnSuperficie;
	}
	public void setSuficienteAparcamientoEnSuperficie(
			BooleanDataType suficienteAparcamientoEnSuperficie) {
		this.suficienteAparcamientoEnSuperficie = suficienteAparcamientoEnSuperficie;
	}
	public BooleanDataType getExistenComunicaciones() {
		return existenComunicaciones;
	}
	public void setExistenComunicaciones(BooleanDataType existenComunicaciones) {
		this.existenComunicaciones = existenComunicaciones;
	}
	public BooleanDataType getExisteFacilAccesoPorCarretera() {
		return existeFacilAccesoPorCarretera;
	}
	public void setExisteFacilAccesoPorCarretera(BooleanDataType existeFacilAccesoPorCarretera) {
		this.existeFacilAccesoPorCarretera = existeFacilAccesoPorCarretera;
	}
	public StringDataType getFacilAccesoPorCarretera() {
		return facilAccesoPorCarretera;
	}
	public void setFacilAccesoPorCarretera(StringDataType facilAccesoPorCarretera) {
		this.facilAccesoPorCarretera = facilAccesoPorCarretera;
	}
	public BooleanDataType getExisteLineasDeAutobus() {
		return existeLineasDeAutobus;
	}
	public void setExisteLineasDeAutobus(BooleanDataType existeLineasDeAutobus) {
		this.existeLineasDeAutobus = existeLineasDeAutobus;
	}
	public StringDataType getLineasDeAutobus() {
		return lineasDeAutobus;
	}
	public void setLineasDeAutobus(StringDataType lineasDeAutobus) {
		this.lineasDeAutobus = lineasDeAutobus;
	}
	public BooleanDataType getExisteMetro() {
		return existeMetro;
	}
	public void setExisteMetro(BooleanDataType existeMetro) {
		this.existeMetro = existeMetro;
	}
	public StringDataType getMetro() {
		return metro;
	}
	public void setMetro(StringDataType metro) {
		this.metro = metro;
	}
	public BooleanDataType getExisteEstacionesDeTren() {
		return existeEstacionesDeTren;
	}
	public void setExisteEstacionesDeTren(BooleanDataType existeEstacionesDeTren) {
		this.existeEstacionesDeTren = existeEstacionesDeTren;
	}
	public StringDataType getEstacionesDeTren() {
		return estacionesDeTren;
	}
	public void setEstacionesDeTren(StringDataType estacionesDeTren) {
		this.estacionesDeTren = estacionesDeTren;
	}
	public StringDataType getOtrosComunicaciones() {
		return otrosComunicaciones;
	}
	public void setOtrosComunicaciones(StringDataType otrosComunicaciones) {
		this.otrosComunicaciones = otrosComunicaciones;
	}
	public BooleanDataType getBuenEstadoPuertaEntradaNormal() {
		return buenEstadoPuertaEntradaNormal;
	}
	public void setBuenEstadoPuertaEntradaNormal(BooleanDataType buenEstadoPuertaEntradaNormal) {
		this.buenEstadoPuertaEntradaNormal = buenEstadoPuertaEntradaNormal;
	}
	public BooleanDataType getBuenEstadoPuertaEntradaBlindada() {
		return buenEstadoPuertaEntradaBlindada;
	}
	public void setBuenEstadoPuertaEntradaBlindada(BooleanDataType buenEstadoPuertaEntradaBlindada) {
		this.buenEstadoPuertaEntradaBlindada = buenEstadoPuertaEntradaBlindada;
	}
	public BooleanDataType getBuenEstadoPuertaEntradaAcorazada() {
		return buenEstadoPuertaEntradaAcorazada;
	}
	public void setBuenEstadoPuertaEntradaAcorazada(BooleanDataType buenEstadoPuertaEntradaAcorazada) {
		this.buenEstadoPuertaEntradaAcorazada = buenEstadoPuertaEntradaAcorazada;
	}
	public BooleanDataType getBuenEstadoPuertaPasoMaciza() {
		return buenEstadoPuertaPasoMaciza;
	}
	public void setBuenEstadoPuertaPasoMaciza(BooleanDataType buenEstadoPuertaPasoMaciza) {
		this.buenEstadoPuertaPasoMaciza = buenEstadoPuertaPasoMaciza;
	}
	public BooleanDataType getBuenEstadoPuertaPasoHueca() {
		return buenEstadoPuertaPasoHueca;
	}
	public void setBuenEstadoPuertaPasoHueca(BooleanDataType buenEstadoPuertaPasoHueca) {
		this.buenEstadoPuertaPasoHueca = buenEstadoPuertaPasoHueca;
	}
	public BooleanDataType getBuenEstadoPuertaPasoLacada() {
		return buenEstadoPuertaPasoLacada;
	}
	public void setBuenEstadoPuertaPasoLacada(BooleanDataType buenEstadoPuertaPasoLacada) {
		this.buenEstadoPuertaPasoLacada = buenEstadoPuertaPasoLacada;
	}
	public BooleanDataType getExistenArmariosEmpotrados() {
		return existenArmariosEmpotrados;
	}
	public void setExistenArmariosEmpotrados(BooleanDataType existenArmariosEmpotrados) {
		this.existenArmariosEmpotrados = existenArmariosEmpotrados;
	}
	public StringDataType getCodAcabadoCarpinteria() {
		return codAcabadoCarpinteria;
	}
	public void setCodAcabadoCarpinteria(StringDataType codAcabadoCarpinteria) {
		this.codAcabadoCarpinteria = codAcabadoCarpinteria;
	}
	public StringDataType getOtrosCarpinteriaInterior() {
		return otrosCarpinteriaInterior;
	}
	public void setOtrosCarpinteriaInterior(StringDataType otrosCarpinteriaInterior) {
		this.otrosCarpinteriaInterior = otrosCarpinteriaInterior;
	}
	public BooleanDataType getBuenEstadoVentanaHierro() {
		return buenEstadoVentanaHierro;
	}
	public void setBuenEstadoVentanaHierro(BooleanDataType buenEstadoVentanaHierro) {
		this.buenEstadoVentanaHierro = buenEstadoVentanaHierro;
	}
	public BooleanDataType getBuenEstadoVentanaAnodizado() {
		return buenEstadoVentanaAnodizado;
	}
	public void setBuenEstadoVentanaAnodizado(BooleanDataType buenEstadoVentanaAnodizado) {
		this.buenEstadoVentanaAnodizado = buenEstadoVentanaAnodizado;
	}
	public BooleanDataType getBuenEstadoVentanaLacado() {
		return buenEstadoVentanaLacado;
	}
	public void setBuenEstadoVentanaLacado(BooleanDataType buenEstadoVentanaLacado) {
		this.buenEstadoVentanaLacado = buenEstadoVentanaLacado;
	}
	public BooleanDataType getBuenEstadoVentanaPvc() {
		return buenEstadoVentanaPvc;
	}
	public void setBuenEstadoVentanaPvc(BooleanDataType buenEstadoVentanaPvc) {
		this.buenEstadoVentanaPvc = buenEstadoVentanaPvc;
	}
	public BooleanDataType getBuenEstadoVentanaMadera() {
		return buenEstadoVentanaMadera;
	}
	public void setBuenEstadoVentanaMadera(BooleanDataType buenEstadoVentanaMadera) {
		this.buenEstadoVentanaMadera = buenEstadoVentanaMadera;
	}
	public BooleanDataType getBuenEstadoPersianaPlastico() {
		return buenEstadoPersianaPlastico;
	}
	public void setBuenEstadoPersianaPlastico(BooleanDataType buenEstadoPersianaPlastico) {
		this.buenEstadoPersianaPlastico = buenEstadoPersianaPlastico;
	}
	public BooleanDataType getBuenEstadoPersianaAluminio() {
		return buenEstadoPersianaAluminio;
	}
	public void setBuenEstadoPersianaAluminio(BooleanDataType buenEstadoPersianaAluminio) {
		this.buenEstadoPersianaAluminio = buenEstadoPersianaAluminio;
	}
	public BooleanDataType getBuenEstadoAperturaVentanaCorrederas() {
		return buenEstadoAperturaVentanaCorrederas;
	}
	public void setBuenEstadoAperturaVentanaCorrederas(BooleanDataType buenEstadoAperturaVentanaCorrederas) {
		this.buenEstadoAperturaVentanaCorrederas = buenEstadoAperturaVentanaCorrederas;
	}
	public BooleanDataType getBuenEstadoAperturaVentanaAbatibles() {
		return buenEstadoAperturaVentanaAbatibles;
	}
	public void setBuenEstadoAperturaVentanaAbatibles(BooleanDataType buenEstadoAperturaVentanaAbatibles) {
		this.buenEstadoAperturaVentanaAbatibles = buenEstadoAperturaVentanaAbatibles;
	}
	public BooleanDataType getBuenEstadoAperturaVentanaOscilobat() {
		return buenEstadoAperturaVentanaOscilobat;
	}
	public void setBuenEstadoAperturaVentanaOscilobat(BooleanDataType buenEstadoAperturaVentanaOscilobat) {
		this.buenEstadoAperturaVentanaOscilobat = buenEstadoAperturaVentanaOscilobat;
	}
	public BooleanDataType getBuenEstadoDobleAcristalamientoOClimalit() {
		return buenEstadoDobleAcristalamientoOClimalit;
	}
	public void setBuenEstadoDobleAcristalamientoOClimalit(BooleanDataType buenEstadoDobleAcristalamientoOClimalit) {
		this.buenEstadoDobleAcristalamientoOClimalit = buenEstadoDobleAcristalamientoOClimalit;
	}
	public StringDataType getOtrosCarpinteriaExterior() {
		return otrosCarpinteriaExterior;
	}
	public void setOtrosCarpinteriaExterior(StringDataType otrosCarpinteriaExterior) {
		this.otrosCarpinteriaExterior = otrosCarpinteriaExterior;
	}
	public BooleanDataType getHumedadesPared() {
		return humedadesPared;
	}
	public void setHumedadesPared(BooleanDataType humedadesPared) {
		this.humedadesPared = humedadesPared;
	}
	public BooleanDataType getHumedadesTecho() {
		return humedadesTecho;
	}
	public void setHumedadesTecho(BooleanDataType humedadesTecho) {
		this.humedadesTecho = humedadesTecho;
	}
	public BooleanDataType getGrietasPared() {
		return grietasPared;
	}
	public void setGrietasPared(BooleanDataType grietasPared) {
		this.grietasPared = grietasPared;
	}
	public BooleanDataType getGrietasTecho() {
		return grietasTecho;
	}
	public void setGrietasTecho(BooleanDataType grietasTecho) {
		this.grietasTecho = grietasTecho;
	}
	public BooleanDataType getBuenEstadoPinturaParedesGotele() {
		return buenEstadoPinturaParedesGotele;
	}
	public void setBuenEstadoPinturaParedesGotele(BooleanDataType buenEstadoPinturaParedesGotele) {
		this.buenEstadoPinturaParedesGotele = buenEstadoPinturaParedesGotele;
	}
	public BooleanDataType getBuenEstadoPinturaParedesLisa() {
		return buenEstadoPinturaParedesLisa;
	}
	public void setBuenEstadoPinturaParedesLisa(BooleanDataType buenEstadoPinturaParedesLisa) {
		this.buenEstadoPinturaParedesLisa = buenEstadoPinturaParedesLisa;
	}
	public BooleanDataType getBuenEstadoPinturaParedesPintado() {
		return buenEstadoPinturaParedesPintado;
	}
	public void setBuenEstadoPinturaParedesPintado(BooleanDataType buenEstadoPinturaParedesPintado) {
		this.buenEstadoPinturaParedesPintado = buenEstadoPinturaParedesPintado;
	}
	public BooleanDataType getBuenEstadoPinturaTechoGotele() {
		return buenEstadoPinturaTechoGotele;
	}
	public void setBuenEstadoPinturaTechoGotele(BooleanDataType buenEstadoPinturaTechoGotele) {
		this.buenEstadoPinturaTechoGotele = buenEstadoPinturaTechoGotele;
	}
	public BooleanDataType getBuenEstadoPinturaTechoLisa() {
		return buenEstadoPinturaTechoLisa;
	}
	public void setBuenEstadoPinturaTechoLisa(BooleanDataType buenEstadoPinturaTechoLisa) {
		this.buenEstadoPinturaTechoLisa = buenEstadoPinturaTechoLisa;
	}
	public BooleanDataType getBuenEstadoPinturaTechoPintado() {
		return buenEstadoPinturaTechoPintado;
	}
	public void setBuenEstadoPinturaTechoPintado(BooleanDataType buenEstadoPinturaTechoPintado) {
		this.buenEstadoPinturaTechoPintado = buenEstadoPinturaTechoPintado;
	}
	public BooleanDataType getBuenEstadoMolduraEscayola() {
		return buenEstadoMolduraEscayola;
	}
	public void setBuenEstadoMolduraEscayola(BooleanDataType buenEstadoMolduraEscayola) {
		this.buenEstadoMolduraEscayola = buenEstadoMolduraEscayola;
	}
	public StringDataType getOtrosParamentosVerticales() {
		return otrosParamentosVerticales;
	}
	public void setOtrosParamentosVerticales(StringDataType otrosParamentosVerticales) {
		this.otrosParamentosVerticales = otrosParamentosVerticales;
	}
	public BooleanDataType getBuenEstadoTarimaFlotanteSolados() {
		return buenEstadoTarimaFlotanteSolados;
	}
	public void setBuenEstadoTarimaFlotanteSolados(BooleanDataType buenEstadoTarimaFlotanteSolados) {
		this.buenEstadoTarimaFlotanteSolados = buenEstadoTarimaFlotanteSolados;
	}
	public BooleanDataType getBuenEstadoParqueSolados() {
		return buenEstadoParqueSolados;
	}
	public void setBuenEstadoParqueSolados(BooleanDataType buenEstadoParqueSolados) {
		this.buenEstadoParqueSolados = buenEstadoParqueSolados;
	}
	public BooleanDataType getBuenEstadoMarmolSolados() {
		return buenEstadoMarmolSolados;
	}
	public void setBuenEstadoMarmolSolados(BooleanDataType buenEstadoMarmolSolados) {
		this.buenEstadoMarmolSolados = buenEstadoMarmolSolados;
	}
	public BooleanDataType getBuenEstadoPlaquetaSolados() {
		return buenEstadoPlaquetaSolados;
	}
	public void setBuenEstadoPlaquetaSolados(BooleanDataType buenEstadoPlaquetaSolados) {
		this.buenEstadoPlaquetaSolados = buenEstadoPlaquetaSolados;
	}
	public StringDataType getOtrosSolados() {
		return otrosSolados;
	}
	public void setOtrosSolados(StringDataType otrosSolados) {
		this.otrosSolados = otrosSolados;
	}
	public BooleanDataType getBuenEstadoCocinaAmuebladaCocina() {
		return buenEstadoCocinaAmuebladaCocina;
	}
	public void setBuenEstadoCocinaAmuebladaCocina(BooleanDataType buenEstadoCocinaAmuebladaCocina) {
		this.buenEstadoCocinaAmuebladaCocina = buenEstadoCocinaAmuebladaCocina;
	}
	public BooleanDataType getBuenEstadoEncimeraGranitoCocina() {
		return buenEstadoEncimeraGranitoCocina;
	}
	public void setBuenEstadoEncimeraGranitoCocina(BooleanDataType buenEstadoEncimeraGranitoCocina) {
		this.buenEstadoEncimeraGranitoCocina = buenEstadoEncimeraGranitoCocina;
	}
	public BooleanDataType getBuenEstadoEncimeraMarmolCocina() {
		return buenEstadoEncimeraMarmolCocina;
	}
	public void setBuenEstadoEncimeraMarmolCocina(BooleanDataType buenEstadoEncimeraMarmolCocina) {
		this.buenEstadoEncimeraMarmolCocina = buenEstadoEncimeraMarmolCocina;
	}
	public BooleanDataType getBuenEstadoEncimeraMaterialCocina() {
		return buenEstadoEncimeraMaterialCocina;
	}
	public void setBuenEstadoEncimeraMaterialCocina(BooleanDataType buenEstadoEncimeraMaterialCocina) {
		this.buenEstadoEncimeraMaterialCocina = buenEstadoEncimeraMaterialCocina;
	}
	public BooleanDataType getBuenEstadoVitroceramicaCocina() {
		return buenEstadoVitroceramicaCocina;
	}
	public void setBuenEstadoVitroceramicaCocina(BooleanDataType buenEstadoVitroceramicaCocina) {
		this.buenEstadoVitroceramicaCocina = buenEstadoVitroceramicaCocina;
	}
	public BooleanDataType getBuenEstadoLavadoraCocina() {
		return buenEstadoLavadoraCocina;
	}
	public void setBuenEstadoLavadoraCocina(BooleanDataType buenEstadoLavadoraCocina) {
		this.buenEstadoLavadoraCocina = buenEstadoLavadoraCocina;
	}
	public BooleanDataType getBuenEstadoFrigorificoCocina() {
		return buenEstadoFrigorificoCocina;
	}
	public void setBuenEstadoFrigorificoCocina(BooleanDataType buenEstadoFrigorificoCocina) {
		this.buenEstadoFrigorificoCocina = buenEstadoFrigorificoCocina;
	}
	public BooleanDataType getBuenEstadoLavavajillasCocina() {
		return buenEstadoLavavajillasCocina;
	}
	public void setBuenEstadoLavavajillasCocina(BooleanDataType buenEstadoLavavajillasCocina) {
		this.buenEstadoLavavajillasCocina = buenEstadoLavavajillasCocina;
	}
	public BooleanDataType getBuenEstadoMicroondasCocina() {
		return buenEstadoMicroondasCocina;
	}
	public void setBuenEstadoMicroondasCocina(BooleanDataType buenEstadoMicroondasCocina) {
		this.buenEstadoMicroondasCocina = buenEstadoMicroondasCocina;
	}
	public BooleanDataType getBuenEstadoHornoCocina() {
		return buenEstadoHornoCocina;
	}
	public void setBuenEstadoHornoCocina(BooleanDataType buenEstadoHornoCocina) {
		this.buenEstadoHornoCocina = buenEstadoHornoCocina;
	}
	public BooleanDataType getBuenEstadoSueloCocina() {
		return buenEstadoSueloCocina;
	}
	public void setBuenEstadoSueloCocina(BooleanDataType buenEstadoSueloCocina) {
		this.buenEstadoSueloCocina = buenEstadoSueloCocina;
	}
	public BooleanDataType getBuenEstadoAzulejosCocina() {
		return buenEstadoAzulejosCocina;
	}
	public void setBuenEstadoAzulejosCocina(BooleanDataType buenEstadoAzulejosCocina) {
		this.buenEstadoAzulejosCocina = buenEstadoAzulejosCocina;
	}
	public BooleanDataType getBuenEstadoGriferiaMonomandoCocina() {
		return buenEstadoGriferiaMonomandoCocina;
	}
	public void setBuenEstadoGriferiaMonomandoCocina(BooleanDataType buenEstadoGriferiaMonomandoCocina) {
		this.buenEstadoGriferiaMonomandoCocina = buenEstadoGriferiaMonomandoCocina;
	}
	public StringDataType getOtrosCocina() {
		return otrosCocina;
	}
	public void setOtrosCocina(StringDataType otrosCocina) {
		this.otrosCocina = otrosCocina;
	}
	public BooleanDataType getBuenEstadoDuchaBanyo() {
		return buenEstadoDuchaBanyo;
	}
	public void setBuenEstadoDuchaBanyo(BooleanDataType buenEstadoDuchaBanyo) {
		this.buenEstadoDuchaBanyo = buenEstadoDuchaBanyo;
	}
	public BooleanDataType getBuenEstadoBanyeraNormalBanyo() {
		return buenEstadoBanyeraNormalBanyo;
	}
	public void setBuenEstadoBanyeraNormalBanyo(BooleanDataType buenEstadoBanyeraNormalBanyo) {
		this.buenEstadoBanyeraNormalBanyo = buenEstadoBanyeraNormalBanyo;
	}
	public BooleanDataType getBuenEstadoBanyeraHidromasajeBanyo() {
		return buenEstadoBanyeraHidromasajeBanyo;
	}
	public void setBuenEstadoBanyeraHidromasajeBanyo(BooleanDataType buenEstadoBanyeraHidromasajeBanyo) {
		this.buenEstadoBanyeraHidromasajeBanyo = buenEstadoBanyeraHidromasajeBanyo;
	}
	public BooleanDataType getBuenEstadoColumnaHidromasajeBanyo() {
		return buenEstadoColumnaHidromasajeBanyo;
	}
	public void setBuenEstadoColumnaHidromasajeBanyo(BooleanDataType buenEstadoColumnaHidromasajeBanyo) {
		this.buenEstadoColumnaHidromasajeBanyo = buenEstadoColumnaHidromasajeBanyo;
	}
	public BooleanDataType getBuenEstadoAlicatadoMarmolBanyo() {
		return buenEstadoAlicatadoMarmolBanyo;
	}
	public void setBuenEstadoAlicatadoMarmolBanyo(BooleanDataType buenEstadoAlicatadoMarmolBanyo) {
		this.buenEstadoAlicatadoMarmolBanyo = buenEstadoAlicatadoMarmolBanyo;
	}
	public BooleanDataType getBuenEstadoAlicatadoGranitoBanyo() {
		return buenEstadoAlicatadoGranitoBanyo;
	}
	public void setBuenEstadoAlicatadoGranitoBanyo(BooleanDataType buenEstadoAlicatadoGranitoBanyo) {
		this.buenEstadoAlicatadoGranitoBanyo = buenEstadoAlicatadoGranitoBanyo;
	}
	public BooleanDataType getBuenEstadoAlicatadoAzulejoBanyo() {
		return buenEstadoAlicatadoAzulejoBanyo;
	}
	public void setBuenEstadoAlicatadoAzulejoBanyo(BooleanDataType buenEstadoAlicatadoAzulejoBanyo) {
		this.buenEstadoAlicatadoAzulejoBanyo = buenEstadoAlicatadoAzulejoBanyo;
	}
	public BooleanDataType getBuenEstadoEncimeraMarmolBanyo() {
		return buenEstadoEncimeraMarmolBanyo;
	}
	public void setBuenEstadoEncimeraMarmolBanyo(BooleanDataType buenEstadoEncimeraMarmolBanyo) {
		this.buenEstadoEncimeraMarmolBanyo = buenEstadoEncimeraMarmolBanyo;
	}
	public BooleanDataType getBuenEstadoEncimeraGranitoBanyo() {
		return buenEstadoEncimeraGranitoBanyo;
	}
	public void setBuenEstadoEncimeraGranitoBanyo(BooleanDataType buenEstadoEncimeraGranitoBanyo) {
		this.buenEstadoEncimeraGranitoBanyo = buenEstadoEncimeraGranitoBanyo;
	}
	public BooleanDataType getBuenEstadoEncimeraMaterialBanyo() {
		return buenEstadoEncimeraMaterialBanyo;
	}
	public void setBuenEstadoEncimeraMaterialBanyo(BooleanDataType buenEstadoEncimeraMaterialBanyo) {
		this.buenEstadoEncimeraMaterialBanyo = buenEstadoEncimeraMaterialBanyo;
	}
	public BooleanDataType getBuenEstadoSanitariosBanyo() {
		return buenEstadoSanitariosBanyo;
	}
	public void setBuenEstadoSanitariosBanyo(BooleanDataType buenEstadoSanitariosBanyo) {
		this.buenEstadoSanitariosBanyo = buenEstadoSanitariosBanyo;
	}
	public BooleanDataType getBuenEstadoSueloBanyo() {
		return buenEstadoSueloBanyo;
	}
	public void setBuenEstadoSueloBanyo(BooleanDataType buenEstadoSueloBanyo) {
		this.buenEstadoSueloBanyo = buenEstadoSueloBanyo;
	}
	public BooleanDataType getBuenEstadoGriferiaMonomandoBanyo() {
		return buenEstadoGriferiaMonomandoBanyo;
	}
	public void setBuenEstadoGriferiaMonomandoBanyo(BooleanDataType buenEstadoGriferiaMonomandoBanyo) {
		this.buenEstadoGriferiaMonomandoBanyo = buenEstadoGriferiaMonomandoBanyo;
	}
	public StringDataType getOtrosBanyo() {
		return otrosBanyo;
	}
	public void setOtrosBanyo(StringDataType otrosBanyo) {
		this.otrosBanyo = otrosBanyo;
	}
	public BooleanDataType getBuenEstadoInstalacionElectrica() {
		return buenEstadoInstalacionElectrica;
	}
	public void setBuenEstadoInstalacionElectrica(BooleanDataType buenEstadoInstalacionElectrica) {
		this.buenEstadoInstalacionElectrica = buenEstadoInstalacionElectrica;
	}
	public BooleanDataType getInstalacionElectricaAntiguaODefectuosa() {
		return instalacionElectricaAntiguaODefectuosa;
	}
	public void setInstalacionElectricaAntiguaODefectuosa(BooleanDataType instalacionElectricaAntiguaODefectuosa) {
		this.instalacionElectricaAntiguaODefectuosa = instalacionElectricaAntiguaODefectuosa;
	}
	public BooleanDataType getExisteCalefaccionGasNatural() {
		return existeCalefaccionGasNatural;
	}
	public void setExisteCalefaccionGasNatural(BooleanDataType existeCalefaccionGasNatural) {
		this.existeCalefaccionGasNatural = existeCalefaccionGasNatural;
	}
	public BooleanDataType getExistenRadiadoresDeAluminio() {
		return existenRadiadoresDeAluminio;
	}
	public void setExistenRadiadoresDeAluminio(BooleanDataType existenRadiadoresDeAluminio) {
		this.existenRadiadoresDeAluminio = existenRadiadoresDeAluminio;
	}
	public BooleanDataType getExisteAguaCalienteCentral() {
		return existeAguaCalienteCentral;
	}
	public void setExisteAguaCalienteCentral(BooleanDataType existeAguaCalienteCentral) {
		this.existeAguaCalienteCentral = existeAguaCalienteCentral;
	}
	public BooleanDataType getExisteAguaCalienteGasNatural() {
		return existeAguaCalienteGasNatural;
	}
	public void setExisteAguaCalienteGasNatural(BooleanDataType existeAguaCalienteGasNatural) {
		this.existeAguaCalienteGasNatural = existeAguaCalienteGasNatural;
	}
	public BooleanDataType getExisteAireAcondicionadoPreinstalacion() {
		return existeAireAcondicionadoPreinstalacion;
	}
	public void setExisteAireAcondicionadoPreinstalacion(BooleanDataType existeAireAcondicionadoPreinstalacion) {
		this.existeAireAcondicionadoPreinstalacion = existeAireAcondicionadoPreinstalacion;
	}
	public BooleanDataType getExisteAireAcondicionadoInstalacion() {
		return existeAireAcondicionadoInstalacion;
	}
	public void setExisteAireAcondicionadoInstalacion(BooleanDataType existeAireAcondicionadoInstalacion) {
		this.existeAireAcondicionadoInstalacion = existeAireAcondicionadoInstalacion;
	}
	public BooleanDataType getExisteAireAcondicionadoCalor() {
		return existeAireAcondicionadoCalor;
	}
	public void setExisteAireAcondicionadoCalor(BooleanDataType existeAireAcondicionadoCalor) {
		this.existeAireAcondicionadoCalor = existeAireAcondicionadoCalor;
	}
	public StringDataType getOtrosInstalaciones() {
		return otrosInstalaciones;
	}
	public void setOtrosInstalaciones(StringDataType otrosInstalaciones) {
		this.otrosInstalaciones = otrosInstalaciones;
	}
	public BooleanDataType getExistenJardinesZonasVerdes() {
		return existenJardinesZonasVerdes;
	}
	public void setExistenJardinesZonasVerdes(BooleanDataType existenJardinesZonasVerdes) {
		this.existenJardinesZonasVerdes = existenJardinesZonasVerdes;
	}
	public BooleanDataType getExistePiscina() {
		return existePiscina;
	}
	public void setExistePiscina(BooleanDataType existePiscina) {
		this.existePiscina = existePiscina;
	}
	public BooleanDataType getExistePistaPadel() {
		return existePistaPadel;
	}
	public void setExistePistaPadel(BooleanDataType existePistaPadel) {
		this.existePistaPadel = existePistaPadel;
	}
	public BooleanDataType getExistePistaTenis() {
		return existePistaTenis;
	}
	public void setExistePistaTenis(BooleanDataType existePistaTenis) {
		this.existePistaTenis = existePistaTenis;
	}
	public BooleanDataType getExistePistaPolideportiva() {
		return existePistaPolideportiva;
	}
	public void setExistePistaPolideportiva(BooleanDataType existePistaPolideportiva) {
		this.existePistaPolideportiva = existePistaPolideportiva;
	}
	public BooleanDataType getExisteGimnasio() {
		return existeGimnasio;
	}
	public void setExisteGimnasio(BooleanDataType existeGimnasio) {
		this.existeGimnasio = existeGimnasio;
	}
	public StringDataType getOtrosInstalacionesDeportivas() {
		return otrosInstalacionesDeportivas;
	}
	public void setOtrosInstalacionesDeportivas(StringDataType otrosInstalacionesDeportivas) {
		this.otrosInstalacionesDeportivas = otrosInstalacionesDeportivas;
	}
	public BooleanDataType getExisteZonaInfantil() {
		return existeZonaInfantil;
	}
	public void setExisteZonaInfantil(BooleanDataType existeZonaInfantil) {
		this.existeZonaInfantil = existeZonaInfantil;
	}
	public BooleanDataType getExisteConserjeVigilancia() {
		return existeConserjeVigilancia;
	}
	public void setExisteConserjeVigilancia(BooleanDataType existeConserjeVigilancia) {
		this.existeConserjeVigilancia = existeConserjeVigilancia;
	}
	public StringDataType getOtrosZonasComunes() {
		return otrosZonasComunes;
	}
	public void setOtrosZonasComunes(StringDataType otrosZonasComunes) {
		this.otrosZonasComunes = otrosZonasComunes;
	}
	public List<PlantaDto> getPlantas() {
		return plantas;
	}
	public void setPlantas(List<PlantaDto> plantas) {
		this.plantas = plantas;
	}
	public List<ActivoVinculadoDto> getActivosVinculados() {
		return activosVinculados;
	}
	public void setActivosVinculados(List<ActivoVinculadoDto> activosVinculados) {
		this.activosVinculados = activosVinculados;
	}
	public BooleanDataType getAceptado() {
		return aceptado;
	}
	public void setAceptado(BooleanDataType aceptado) {
		this.aceptado = aceptado;
	}
	public StringDataType getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(StringDataType motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public StringDataType getCodTipoAdmiteMascota() {
		return codTipoAdmiteMascota;
	}
	public void setCodTipoAdmiteMascota(StringDataType codTipoAdmiteMascota) {
		this.codTipoAdmiteMascota = codTipoAdmiteMascota;
	}
	
}
