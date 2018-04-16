package es.pfsgroup.plugin.rem.activo;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivoPropagacionFieldTabMap {

    public static final Map<String, List<String>> map;

    public static final String TAB_DATOS_BASICOS = "datosbasicos";
    public static final String TAB_SIT_POSESORIA = "sitposesoriallaves";
    public static final String TAB_INFORME_COMERCIAL = "informecomercial";
    public static final String TAB_DATOS_REGISTRALES = "datosregistrales";
    public static final String TAB_INFO_ADMINISTRATIVA = "infoadministrativa";
    public static final String TAB_CARGAS_ACTIVO = "cargasactivo";
    public static final String TAB_MEDIADOR_ACTIVO = "mediadoractivo";
    public static final String TAB_CONDICIONES_ESPECIFICAS = "condicionesespecificas";

    public static final String TAB_DATOS_PUBLICACION = "datospublicacion";
    public static final String TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION = "activohistoricoestadopublicacion";
    public static final String TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD = "activocondicionantesdisponibilidad";

    public static final String TAB_COMERCIAL = "comercial";
    public static final String TAB_ADMINISTRACION = "administracion";
    
    static {
    	Map<String, List<String>> pmap = new HashMap<String, List<String>>();

    	pmap.put(TAB_DATOS_BASICOS, 
    			Arrays.asList(
   	    			// identificacion
	    			"tipoActivoCodigo", 
	    			"subtipoActivoCodigo", 
	    			"estadoActivoCodigo", 

	    			// direccion
	    			"tipoUsoDestinoCodigo",
	    			"longitud",
	    			"latitud",
	    			"piso",
	    			"inferiorMunicipioCodigo",
	    			"municipioCodigo",
	    			"provinciaCodigo",
	    			"puerta",
	    			"escalera",
	    			"numeroDomicilio",
	    			"selloCalidad",
	    			"tipoViaCodigo",
	    			"codPostal",
	    			"codPostalFormateado",
	    			"nombreVia",

	    			// perimetro
	    			"motivoAplicaGestion",
	    			"motivoAplicaComercializarCodigo",
	    			"motivoAplicaFormalizar",
	    			"aplicaGestion",
	    			"aplicaFormalizar",
	    			"aplicaComercializar",

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
    				"estadoExpIncorrienteCodigo"
    			));

    	pmap.put(TAB_SIT_POSESORIA, 
    			Arrays.asList(
			    	"fechaRevisionEstado",
			    	"ocupado",
			    	"riesgoOcupacion",
			    	"conTitulo",
			    	"accesoTapiado",
			    	"fechaAccesoTapiado",
			    	"accesoAntiocupa",
			    	"fechaAccesoAntiocupa",
			    	"tieneOkTecnico"
    			));

    	pmap.put(TAB_INFORME_COMERCIAL, 
    			Arrays.asList(
					"descripcionComercial",
					"anyoConstruccion",
					"anyoRehabilitacion",
					"aptoPublicidad",
					"activosVinculados",
					"fechaEmisionInforme",
					"fechaAceptacion",
					"fechaRechazo",
					"fechaUltimaVisita",
					"codigoMediador",
					"nombreMediador",
					"emailMediador",
					"telefonoMediador",
					"ultimaPlanta",
					"numPlantasInter",
					"reformaCarpInt",
					"reformaCarpExt",
					"reformaCocina",
					"reformaBanyo",
					"reformaSuelo",
					"reformaPintura",
					"reformaIntegral",
					"reformaOtro",
					"reformaOtroDesc",
					"reformaPresupuesto",
					"distribucionTxt",
					"destinoCoche",
					"destinoMoto",
					"destinoDoble",
					"anchura",
					"profundidad",
					"formaIrregular",
					"aparcamientoAltura",
					"aparcamientoLicencia",
					"aparcamientoSerbidumbre",
					"aparcamientoMontacarga",
					"aparcamientoColumnas",
					"aparcamientoSeguridad",
					"subtipoActivoCodigo",
					"subtipoPlazagarajeCodigo",
					"maniobrabilidadCodigo",
					"mtsFachadaPpal",
					"mtsFachadaLat",
					"mtsLuzLibre",
					"mtsAlturaLibre",
					"mtsLinealesProf",
					"diafano",
					"usuIdoneo",
					"usuAnterior",
					"observaciones",
					"existeSalidaHumos",
					"existeSalidaEmergencias",
					"existeAccesoMinusvalidos",
					"otrosOtrasCaracteristicas",
					"ascensor",
					"anyoRehabilitacionEdificio",
					"numPlantas",
					"numAscensores",
					"reformaFachada",
					"reformaEscalera",
					"reformaPortal",
					"reformaAscensor",
					"reformaCubierta",
					"reformaOtrasZonasComunes",
					"entornoComunicaciones",
					"entornoInfraestructuras",
					"ediDescripcion",
					"reformaOtroDescEdificio",
					"edificioDivisible",
					"edificioOtrasCaracteristicas",
					"edificioDescPlantas",
					"infoDescripcion",
					"infoDistribucionInterior",
					"ocio",
					"hoteles",
					"hotelesDesc",
					"teatros",
					"teatrosDesc",
					"salasCine",
					"salasCineDesc",
					"instDeportivas",
					"instDeportivasDesc",
					"centrosComerciales",
					"centrosComercialesDesc",
					"ocioOtros",
					"centrosEducativos",
					"escuelasInfantiles",
					"escuelasInfantilesDesc",
					"colegios",
					"colegiosDesc",
					"institutos",
					"institutosDesc",
					"universidades",
					"universidadesDesc",
					"centrosEducativosOtros",
					"centrosSanitarios",
					"centrosSalud",
					"centrosSaludDesc",
					"clinicas",
					"clinicasDesc",
					"hospitales",
					"hospitalesDesc",
					"centrosSanitariosOtros",
					"parkingSuperSufi",
					"comunicaciones",
					"facilAcceso",
					"facilAccesoDesc",
					"lineasBus",
					"lineasBusDesc",
					"metro",
					"metroDesc",
					"estacionTren",
					"estacionTrenDesc",
					"comunicacionesOtro",
					"acabadoCarpinteriaCodigo",
					"puertaEntradaNormal",
					"puertaEntradaBlindada",
					"puertaEntradaAcorazada",
					"puertaPasoMaciza",
					"puertaPasoHueca",
					"puertaPasoLacada",
					"armariosEmpotrados",
					"carpinteriaInteriorOtros",
					"ventanasHierro",
					"ventanasAluAnodizado",
					"ventanasAluLacado",
					"ventanasPVC",
					"ventanasMadera",
					"persianasPlastico",
					"persianasAluminio",
					"ventanasCorrederas",
					"ventanasAbatibles",
					"ventanasOscilobatientes",
					"dobleCristal",
					"dobleCristalEstado",
					"carpinteriaExteriorOtros",
					"humedadPared",
					"humedadTecho",
					"grietaPared",
					"grietaTecho",
					"gotele",
					"plasticaLisa",
					"papelPintado",
					"pinturaLisaTecho",
					"pinturaLisaTechoEstado",
					"molduraEscayola",
					"molduraEscayolaEstado",
					"paramentosOtros",
					"tarimaFlotante",
					"parque",
					"soladoMarmol",
					"plaqueta",
					"soladoOtros",
					"amueblada",
					"estadoAmueblada",
					"encimera",
					"encimeraGranito",
					"encimeraMarmol",
					"encimeraOtroMaterial",
					"vitro",
					"lavadora",
					"frigorifico",
					"lavavajillas",
					"microondas",
					"horno",
					"suelosCocina",
					"azulejos",
					"estadoAzulejos",
					"grifosMonomandos",
					"estadoGrifosMonomandos",
					"cocinaOtros",
					"duchaBanyera",
					"ducha",
					"banyera",
					"banyeraHidromasaje",
					"columnaHidromasaje",
					"alicatadoMarmol",
					"alicatadoGranito",
					"alicatadoAzulejo",
					"encimeraBanyo",
					"encimeraBanyoMarmol",
					"encimeraBanyoGranito",
					"encimeraBanyoOtroMaterial",
					"sanitarios",
					"estadoSanitarios",
					"suelosBanyo",
					"grifoMonomando",
					"estadoGrifoMonomando",
					"banyoOtros",
					"electricidadConContador",
					"electricidadBuenEstado",
					"electricidadDefectuosa",
					"electricidad",
					"aguaConContador",
					"aguaBuenEstado",
					"aguaDefectuosa",
					"aguaCalienteCentral",
					"aguaCalienteGasNat",
					"agua",
					"gasConContador",
					"gasBuenEstado",
					"gasDefectuosa",
					"gas",
					"calefaccionCentral",
					"calefaccionGasNat",
					"calefaccionRadiadorAlu",
					"calefaccionPreinstalacion",
					"airePreinstalacion",
					"aireInstalacion",
					"aireFrioCalor",
					"instalacionOtros",
					"jardines",
					"piscina",
					"padel",
					"tenis",
					"pistaPolideportiva",
					"instalacionesDeportivasOtros",
					"zonaInfantil",
					"conserjeVigilancia",
					"gimnasio",
					"zonaComunOtros",
					"ubicacionActivoCodigo",
					"estadoConstruccionCodigo",
					"estadoConservacionCodigo",
					"estadoConservacionEdificioCodigo",
					"tipoFachadaCodigo",
					"tipoViviendaCodigo",
					"tipoOrientacionCodigo",
					"tipoRentaCodigo",
					"tipoCalidadCodigo",
					"ubicacionAparcamientoCodigo",
					"tipoInfoComercialCodigo",
					"tipoActivoCodigo",
					"autorizacionWeb",
					"fechaAutorizacionHasta",
					"fechaRecepcionLlaves",
					"tipoActivoCodigo",
					"subtipoActivoCodigo",
					"tipoViaCodigo",
					"nombreVia",
					"numeroVia",
					"escalera",
					"planta",
					"puerta",
					"latitud",
					"longitud",
					"zona",
					"distrito",
					"municipioCodigo",
					"provinciaCodigo",
					"codigoPostal",
					"inscritaComunidad",
					"cuotaOrientativaComunidad",
					"derramaOrientativaComunidad",
					"nomPresidenteComunidad",
					"telPresidenteComunidad",
					"nomAdministradorComunidad",
					"telAdministradorComunidad",
					"valorEstimadoVenta",
					"valorEstimadoRenta",
					"justificacionVenta",
					"justificacionRenta",
					"fechaEstimacionVenta",
					"fechaEstimacionRenta",
					"inferiorMunicipioCodigo",
					"ubicacionActivoCodigo",
					"numTerrazaCubierta",
					"descTerrazaCubierta",
					"numTerrazaDescubierta",
					"descTerrazaDescubierta",
					"despensa",
					"lavadero",
					"azotea",
					"descOtras"
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
					//"tipoTituloCodigo", <-Eliminar según conversacion mantenida con Bruno 14-SEP-2017
					//"subtipoTituloCodigo", <-Eliminar según conversacion mantenida con Bruno 14-SEP-2017
					"propiedadActivoDescripcion",
					"propiedadActivoCodigo",
					"propiedadActivoNif",
					"propiedadActivoDireccion",
					"tipoGradoPropiedadCodigo",
					"estadoTitulo",
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
					"entidadEjecutanteCodigo"
    			));

    	pmap.put(TAB_INFO_ADMINISTRATIVA, 
    			Arrays.asList(
    				"sujetoAExpediente",
    				"promocionVpo"
    			));

    	pmap.put(TAB_CARGAS_ACTIVO, 
    			Arrays.asList(
    				"fechaRevisionCarga",
    				"conCargas"
    			));
    	

    	pmap.put(TAB_DATOS_PUBLICACION, 
    			Arrays.asList(
    				"idActivo",
    				"totalDiasPublicado",
    				"portalesExternos"
    			));
    	pmap.put(TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION, 
    			Arrays.asList(
    				"idActivo",
    				"publicacionOrdinaria",
    				"publicacionForzada",
    				"ocultacionForzada",
					"ocultacionPrecio",
					"despublicacionForzada",
					"motivoPublicacion",
					"motivoOcultacionPrecio",
					"motivoDespublicacionForzada",
					"motivoOcultacionForzada",
					"observaciones"
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
    					"divHorizontalNoInscrita"
    					));

    	pmap.put(TAB_COMERCIAL,
    			Arrays.asList(
					"id", // ID de activo.
					"situacionComercialCodigo",
					"fechaVenta",
					"expedienteComercialVivo",
					"observaciones",
					"importeVenta"
    			));
    	pmap.put(TAB_ADMINISTRACION,
    			Arrays.asList(
    				"numActivo",
    				"ibiExento"
    			)); 
        map = Collections.unmodifiableMap(pmap);
    }
}
