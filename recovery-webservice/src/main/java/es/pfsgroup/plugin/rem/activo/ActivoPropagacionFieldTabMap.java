package es.pfsgroup.plugin.rem.activo;

import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivoPropagacionFieldTabMap {

    public static final Map<String, List<String>> map;

    public static final String TAB_DATOS_BASICOS = "datosbasicos";
    public static final String TAB_SIT_POSESORIA = "sitposesoriallaves";
    public static final String TAB_INFORME_COMERCIAL = "informacioncomercial";
    public static final String TAB_DATOS_REGISTRALES = "datosregistrales";
    public static final String TAB_INFO_ADMINISTRATIVA = "infoadministrativa";
    public static final String TAB_CARGAS_ACTIVO = "cargasactivo";
    public static final String TAB_MEDIADOR_ACTIVO = "mediadoractivo";
    public static final String TAB_CONDICIONES_ESPECIFICAS = "condicionesespecificas";
    public static final String TAB_TASACION = "tasacion";
	public static final String TAB_COMUNIDAD_PROPIETARIOS = "datosComunidad";
	public static final String TAB_PLUSVALIA_VENTA = "plusvaliaVenta";
    public static final String TAB_DATOS_PUBLICACION = "datospublicacion";
    public static final String TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD = "activocondicionantesdisponibilidad";
    public static final String TAB_COMERCIAL = "comercial";
    public static final String TAB_ADMINISTRACION = "administracion";
    public static final String TAB_PATRIMONIO = "patrimonio";
    public static final String TAB_CALIFICACION_NEGATIVA = "calificacionNegativa";
    public static final String TAB_PLUSVALIA = "plusvalia";
    public static final String TAB_FASE_PUBLICACION = "fasepublicacionactivo";
    public static final String TAB_SANEAMIENTO = "saneamiento";
    public static final String TAB_VALORACIONES_PRECIOS = "valoracionesprecios";

    static {
    	Map<String, List<String>> pmap = new HashMap<String, List<String>>();

    	pmap.put(TAB_DATOS_BASICOS,
    			Arrays.asList(
   	    			// identificacion
	    			"tipoActivoCodigo",
	    			"subtipoActivoCodigo",
	    			"estadoActivoCodigo",
	    			"tipoTransmision",
    	    		"tipoSegmentoCodigo",
    	    		"porcentajeConstruccion",
	    			// identificación BBVA
	    			"lineaFactura",
	    			"idOrigenHre",
	    			
	    			// direccion
	    			"tipoUsoDestinoCodigo",
	    			"longitud",
	    			"latitud",
	    			"inferiorMunicipioCodigo",
	    			"municipioCodigo",
	    			"provinciaCodigo",
	    			"selloCalidad",
	    			"tipoViaCodigo",
	    			"codPostal",
	    			"codPostalFormateado",
	    			"nombreVia",
	    			

	    			// perimetro
	    			"motivoAplicaGestion",
	    			"motivoAplicaPublicar",
	    			"motivoAplicaComercializarCodigo",
					"motivoNoAplicaComercializar",
	    			"motivoAplicaFormalizar",
	    			"aplicaGestion",
	    			"aplicaPublicar",
	    			"aplicaFormalizar",
    			

	    			// comercializacion
    				"tipoComercializarCodigo",
    				"tipoComercializacionCodigo",
    				"bloqueoTipoComercializacionAutomatico",
    				"tipoAlquilerCodigo",

    				// Activo bancario
    				"claseActivoCodigo",
    				"subtipoClaseActivoCodigo",
    				"numExpRiesgo",
    				"estadoExpRiesgoCodigo",
    				"productoDescripcion",
    				"estadoExpIncorrienteCodigo",
    				"uicBbva",
    				"cexperBbva",
    				
    				//Activo EPA
    				"activoEpa",
    				
    				//Cuenta de mora
    				"empresa",
    				"oficina",
    				"contrapartida",
    				"folio",
    				"cdpen"
    			));

    	pmap.put(TAB_SIT_POSESORIA,
    			Arrays.asList(
			    	"fechaRevisionEstado",
			    	"ocupado",
			    	"riesgoOcupacion",
			    	"conTituloCodigo",
			    	"conTituloDescripcion",
			    	"accesoTapiado",
			    	"fechaAccesoTapiado",
			    	"accesoAntiocupa",
			    	"fechaAccesoAntiocupa",
			    	"tieneOkTecnico"
    			));

    	pmap.put(TAB_INFORME_COMERCIAL,
    			Arrays.asList(
					"tipoActivoCodigo",
					"subtipoActivoCodigo",
					"tipoViaCodigo",
					"nombreVia",
					"numeroVia",
					"latitud",
					"longitud",
					////"zona",
					////"distrito",
					"municipioCodigo",
					"provinciaCodigo",
					"codigoPostal",
					////"inferiorMunicipioCodigo",
					////"ubicacionActivoCodigo",
					"valorEstimadoVenta",
					"valorEstimadoRenta",
					"valorEstimadoMinVenta",
					"valorEstimadoMinRenta",
					"valorEstimadoMaxVenta",
					"valorEstimadoMaxRenta",
					"codAgrupacionON",
					"idLote",
					"activoPrincipalCod",
					"activoPrincipalDesc",
					"regimenInmuebleCod",
					"regimenInmuebleDesc",
					"estadoOcupacionalCod",
					"estadoOcupacionalDesc",
					"anyoConstruccion",
					"superficieRegistral",
					"dormitorios",
					"banyos",
					"aseos",
					"ascensorCod",
					"plazasGaraje",
					"terrazaCod",
					"patioCod",
					"patioDesc",
					"rehabilitadoCod",
					"anyoRehabilitacion",
					"licenciaAperturaCod",
					"fechaVisita",
					"envioLlavesApi",
					"recepcionLlavesApi",
					"codigoMediador",
					"nombreMediador",
					"emailMediador",
					"telefonoMediador",
					"autorizacionWeb",
					"fechaAutorizacionHasta",
					"descripcionComercial"
    			));

    	pmap.put(TAB_DATOS_REGISTRALES,
    			Arrays.asList(
   					// Esto es un copy&paste del DTO DtoActivoDatosRegistrales
					"numeroActivo",
					"numRegistro",
					"numFinca",
					"tomo",
					"libro",
					"folio",
					"superficie",
					//"superficieConstruida", <-Eliminar según conversacion mantenida con Bruno 14-SEP-2017
					"idufir",
					"hanCambiado",
					"numAnterior",
					"numFincaAnterior",
					"superficieUtil",
					"superficieElementosComunes",
					"superficieParcela",
					"divHorInscrito",
					"divHorizontal",
					"numDepartamento",
					"fechaCfo",
					"gestionHre",
					"porcPropiedad",
					"fechaTitulo",
					"fechaFirmaTitulo",
					"valorAdquisicion",
					"tramitadorTitulo",
					"acreedorId",
					"acreedorNombre",
					"acreedorNif",
					"acreedorDir",
					"importeDeuda",
					"rentaLibre",
					"acreedorNumExp",
					"numReferencia",
					"vpo",
					"fechaEntregaGestoria",
					"fechaPresHacienda",
					"fechaEnvioAuto",
					"fechaPres1Registro",
					"fechaPres2Registro",
					"fechaInscripcion",
					"fechaRetiradaReg",
					"fechaNotaSimple",
					"estadoDivHorizontalCodigo",
					"estadoObraNuevaCodigo",
					"poblacionRegistro",
					"provinciaRegistro",
					"localidadAnteriorCodigo",
					"tipoTituloCodigo", //<-Eliminar según conversacion mantenida con Bruno 14-SEP-2017
					"subtipoTituloCodigo", //<-Eliminar según conversacion mantenida con Bruno 14-SEP-2017
					"propiedadActivoDescripcion",
					"propiedadActivoCodigo",
					"propiedadActivoNif",
					"propiedadActivoDireccion",
					"tipoGradoPropiedadCodigo",
					"estadoTitulo",
					"fechaInscripcionReg",
					"fechaRealizacionPosesion",
					"fechaAdjudicacion",
					"numAuto",
					"procurador",
					"letrado",
					"idAsunto",
					"numExpRiesgoAdj",
					"fechaDecretoFirme",
					"fechaSenalamientoPosesion",
					"importeAdjudicacion",
					"tipoJuzgadoCodigo",
					"estadoAdjudicacionCodigo",
					"tipoPlazaCodigo",
					"entidadAdjudicatariaCodigo",
					"entidadEjecutanteCodigo",
					"calificacionNegativa",
					"motivoCalificacionNegativa",
					"descripcionCalificacionNegativa",
					"estadoMotivoCalificacionNegativa",
					"responsableSubsanar",
					"fechaSubsanacion",
					"codigoMotivoCalificacionNegativa",
					"codigoEstadoMotivoCalificacionNegativa",
					"idProcesoOrigen",
					"sociedadDePagoAnterior",
					"fechaPosesionNoJudicial"
    			));

    	pmap.put(TAB_INFO_ADMINISTRATIVA,
    			Arrays.asList(
    				"sujetoAExpediente",
    				"promocionVpo"
    			));

    	pmap.put(TAB_DATOS_PUBLICACION,
    			Arrays.asList(
    				"idActivo",
    				"estadoPublicacionVenta",
    				"estadoPublicacionAlquiler",
    				"precioWebVenta",
    				"precioWebAlquiler",
				    "adecuacionAlquilerCodigo",
    				"totalDiasPublicadoVenta",
    				"totalDiasPublicadoAlquiler",
				    "publicarVenta",
				    "ocultarVenta",
				    "publicarSinPrecioVenta",
				    "noMostrarPrecioVenta",
				    "motivoOcultacionVentaCodigo",
				    "motivoOcultacionManualVenta",
				    "publicarAlquiler",
				    "ocultarAlquiler",
				    "publicarSinPrecioAlquiler",
				    "noMostrarPrecioAlquiler",
				    "motivoOcultacionAlquilerCodigo",
				    "motivoOcultacionManualAlquiler",
				    "deshabilitarCheckPublicarVenta",
				    "deshabilitarCheckOcultarVenta",
				    "deshabilitarCheckPublicarSinPrecioVenta",
				    "deshabilitarCheckNoMostrarPrecioVenta",
				    "deshabilitarCheckPublicarAlquiler",
				    "deshabilitarCheckOcultarAlquiler",
				    "deshabilitarCheckPublicarSinPrecioAlquiler",
				    "deshabilitarCheckNoMostrarPrecioAlquiler",
				    "fechaRevisionPublicacionesVenta",
				    "fechaRevisionPublicacionesAlquiler"
    			));

	    pmap.put(TAB_TASACION,
			    Arrays.asList(
					    "id",
					    "fechaValorTasacion",
					    "fechaSolicitudTasacion",
					    "fechaRecepcionTasacion",
					    "nomTasador",
					    "importeTasacionFin"
			    ));

    	pmap.put(TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD,
    			Arrays.asList(
    					"idActivo",
    					"ruina",
    					"pendienteInscripcion",
    					"obraNuevaSinDeclarar",
    					"sinTomaPosesionInicial",
    					"proindiviso",
    					"obraNuevaEnConstruccion",
    					"ocupadoConTitulo",
    					"tapiado",
    					"otro",
    					"ocupadoSinTitulo",
    					"divHorizontalNoInscrita",
    					"comboOtro"
			    ));

    	pmap.put(TAB_COMERCIAL,
    			Arrays.asList(
					"situacionComercialCodigo",
					"fechaVenta",
					"expedienteComercialVivo",
					"observaciones",
					"importeVenta",
					"puja",
	    			"direccionComercial"
    			));

    	pmap.put(TAB_ADMINISTRACION,
    			Arrays.asList(
    				"numActivo",
    				"ibiExento"
    			));

    	pmap.put(TAB_COMUNIDAD_PROPIETARIOS,
    			Arrays.asList(
    				"fechaComunicacionComunidad",
    				"envioCartas",
    				"numCartas",
    				"contactoTel",
    				"visita",
    				"burofax",
    				"situacionCodigo",
    				"situacionId",
    				"fechaEnvioCarta",
    				"situacionDescripcion"
    			));

      	pmap.put(TAB_PLUSVALIA_VENTA,
    			Arrays.asList(
    				"exento",
    				"autoliquidacion",
    				"fechaEscritoAyt",
    				"observaciones"

    			));
//      HREOS-13592 Se bloquea el evolutivo de ocultación de activos para la subida 	
//    	pmap.put(TAB_FASE_PUBLICACION,
//    			Arrays.asList(
//    				"fasePublicacionCodigo",
//    				"subfasePublicacion",
//    				"subfasePublicacionCodigo",
//    				"comentario"
//    					
//    			));

    	pmap.put(TAB_SANEAMIENTO,
    			Arrays.asList(
    				"fechaRevisionCarga",
    				"conCargas"

    			));

        map = Collections.unmodifiableMap(pmap);
    }
}
