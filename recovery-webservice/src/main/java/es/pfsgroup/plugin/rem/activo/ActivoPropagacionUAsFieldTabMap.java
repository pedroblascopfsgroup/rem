package es.pfsgroup.plugin.rem.activo;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivoPropagacionUAsFieldTabMap {

    public static final Map<String, List<String>> mapUAs;

    public static final String TAB_DATOS_BASICOS = "datosbasicos";
    public static final String TAB_SIT_POSESORIA = "sitposesoriallaves";
    public static final String TAB_INFORME_COMERCIAL = "informecomercial";
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
    public static final String TAB_CALIDAD_DATOS = "calidaddatos";
    public static final String TAB_FASE_PUBLICACION = "fasepublicacionactivo";

    static {
    	Map<String, List<String>> pmap = new HashMap<String, List<String>>();

    	pmap.put(TAB_DATOS_BASICOS,
    			Arrays.asList(
    					// identificacion	
    	    		"estadoActivoCodigo",
    	    		"tipoUsoDestinoCodigo",  //TipoUsoDestino    
    	    		"motivoActivo",
    	    		"usoDominanteCodigo",
    	    		"tipoActivoCodigo",
    	    		"subtipoActivoCodigo",
    	    		"porcentajeConstruccion",
    	    		"tipoTransmision",
    	    		"tipoSegmentoCodigo",
    	    		
    	    		// identificación BBVA
	    			"lineaFactura",
	    			"idOrigenHre",
    	    		
    	    			// direccion
    	    		"comunidadAutonomaCodigo", 
    	    		"inferiorMunicipioCodigo",
    	    		"municipioCodigo",
    	    		"provinciaCodigo",			
    	    		"codPostalFormateado",
    	    		"longitud",
    	    		"latitud",
    	    		"codPostal",
    	    		"paisCodigo",
    	    		"selloCalidad",
    	    		"nombreGestorSelloCalidad",
    	    		"fechaRevisionSelloCalidad",
    	    		"direccionComercial",

    	    		
    	    		// perimetro
    	    		"incluidoEnPerimetro",	
    	    		"motivoAplicaGestion",
    	    		"motivoAplicaPublicar",
    	    		"motivoAplicaComercializarDescripcion",
    	    		"motivoNoAplicaComercializarDescripcion",
    	    		"motivoAplicaFormalizar",
    	    		"motivoAplicaComercializarCodigo",
	    			"aplicaFormalizar",

    				
	    			// comercializacion
    				"tipoComercializarCodigo",
    				"tipoComercializacionCodigo",
    				"bloqueoTipoComercializacionAutomatico",
    				"tipoAlquiler",
    				
    				"isDestinoComercialAlquiler",
    				"incluyeDestinoComercialAlquiler",
    				"incluyeDestinoComercialVenta",

    				// Activo bancario
    				"claseActivoCodigo",
    				"subtipoClaseActivoCodigo",
    				"numExpRiesgo",
    				"estadoExpRiesgoCodigo",
    				"productoDescripcion",
    				"estadoExpIncorrienteCodigo",
    				"admision",
    				"uicBbva",
    				"cexperBbva",
    				
    				//Activo EPA
    				"activoEpa",
    				
    				//Cuenta de mora
    				"empresa",
    				"oficina",
    				"contrapartida",
    				"folio",
    				"cdpen",
    				
    				//Esparta convivencia
    				"tipoActivoCodigoOE",
    				"subtipoActivoCodigoOE",
    				"estadoAdecuacionSarebCodigo",
    				"fechaFinPrevistaAdecuacion",
    				"reoContabilizadoSap",
    				"tipoViaCodigoOE",
    				"nombreViaOE",
    				"provinciaCodigoOE",
    				"municipioCodigoOE",
    				"codPostalOE"
    			));


    	
    	pmap.put(TAB_DATOS_REGISTRALES,
    			Arrays.asList(
   					
			//DATOS INSCRIPCION

					"numeroActivo",
					"numRegistro",			
					"numFinca",				
					"tomo",					
					"libro",				
					"folio",				
					"poblacionRegistro",	
					"provinciaRegistro",	
					"idufir",				
					"hanCambiado",			
					"numDepartamento",
					"numAnterior",
					"localidadAnteriorCodigo",
					"numFincaAnterior",
					"tieneAnejosRegistralesInt",


					
					
			//INFORMACIÓN REGISTRAL
            	
					"divHorizontal",
					"estadoDivHorizontalCodigo",
					"divHorInscrito",
					"estadoObraNuevaCodigo",
					"fechaCfo",

            //LOS DEMÁS

                    "vpo",
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
					"fechaEntregaGestoria",
					"fechaPresHacienda",
					"fechaEnvioAuto",
					"fechaPres1Registro",
					"fechaPres2Registro",
					"fechaInscripcion",
					"fechaRetiradaReg",
					"fechaNotaSimple",
					"numAuto",
					"propiedadActivoDescripcion",
					"propiedadActivoCodigo",
					"propiedadActivoNif",
					"propiedadActivoDireccion",
					"tipoGradoPropiedadCodigo",
					"estadoTitulo",
					"fechaInscripcionReg",
					"fechaRealizacionPosesion",
					"fechaAdjudicacion",	
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

    	pmap.put(TAB_SIT_POSESORIA,
    			Arrays.asList(
    					
    				"fechaTomaPosesion",
			    	"fechaRevisionEstado" ,
			    	"riesgoOcupacion",
			    	"accesoTapiado",
			    	"fechaAccesoTapiado",
			    	"accesoAntiocupa",
			    	"fechaAccesoAntiocupa",
			    	"tieneOkTecnico",
			    	"llavesNecesarias",
			    	"VllavesHre",
			    	"fechaRecepcionLlaves",
			    	"numJuegosLlaves"
    			));

    	

    	pmap.put(TAB_INFO_ADMINISTRATIVA,
    			Arrays.asList(
    				"tipoVpoCodigo",
    				"numExpediente",
    				"obligatorioSolDevAyuda",
    				"obligatorioAutAdmVenta",
    				"observaciones",
    				"maxPrecioVenta",
    				"fechaCalificacion",
    				"descalificado",
    				"sujetoAExpediente",
    				"promocionVpo"
    			));

    	pmap.put(TAB_CARGAS_ACTIVO,
    			Arrays.asList(
    				"fechaRevisionCarga" ,
    				"conCargas"
    			));

   


    	pmap.put(TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD,
    			Arrays.asList(
    					"idActivo" ,
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
    					"sinInformeAprobadoREM"
			    ));



    	pmap.put(TAB_COMUNIDAD_PROPIETARIOS,
    			Arrays.asList(
    				"fechaComunicacionComunidad" ,
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
    	
    	pmap.put(TAB_COMERCIAL,
    			Arrays.asList(
					//"id", // ID de activo.
	    			"direccionComercial",
	    			"importeComunidadMensualSareb",
	    			"siniestroSareb",
	    			"tipoCorrectivoSareb",
	    			"fechaFinCorrectivoSareb",
	    			"tipoCuotaComunidad",
	    			"ggaaSareb",
	    			"segmentacionSareb"
    			));

/*
      	pmap.put(TAB_PLUSVALIA_VENTA,
    			Arrays.asList(
    				"exento" /*,
    				"autoliquidacion",
    				"fechaEscritoAyt",
    				"observaciones"

    			));
    			*/
    			
		pmap.put(TAB_PATRIMONIO,
			Arrays.asList(
					"chkPerimetroAlquiler"
		   	));
//		HREOS-13592 Se bloquea el evolutivo de ocultación de activos para la subida 
//    	pmap.put(TAB_FASE_PUBLICACION,
//    			Arrays.asList(
//    				"fasePublicacionCodigo",
//    				"subfasePublicacionCodigo",
//    				"comentario"
//    			));


        mapUAs = Collections.unmodifiableMap(pmap);
    }
}
