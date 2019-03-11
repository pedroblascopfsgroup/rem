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

    static {
    	Map<String, List<String>> pmap = new HashMap<String, List<String>>();

    	pmap.put(TAB_DATOS_BASICOS,
    			Arrays.asList(
    					// identificacion	
    	    		"estadoActivoCodigo",
    	    		"tipoUsoDestino",    // ?? DDTipoUsoDestino
    	    		"motivoActivo",
    	    			// direccion
    	    		"comunidadAutonomaCodigo", // ?? Se saca a partir de la provincia
    	    			
    	    		"inferiorMunicipioCodigo",
    	    		"municipioCodigo",
    	    		"provinciaCodigo",			
    	    		"codPostalFormateado",
    	    		"longitud",
    	    		"latitud",
    	    		"codPostal",
    	    		"pais",

    	    			// perimetro
    	    		"incluidoEnPerimetro",	//PerimetroHaya

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


    	
    	pmap.put(TAB_DATOS_REGISTRALES,
    			Arrays.asList(

					//Datos de inscripcion
					"provinciaRegistro",
					"poblacionRegistro",
					"numRegistro",
					"tomo",
					"libro",
					"folio",
					"numFinca",
					"idufir",
					"numDepartamento",
					"hanCambiado",
					"numAnterior",
					"numFincaAnterior",
					"localidadAnteriorCodigo",
					
					//Informacion Registral
					"superficieUtil",
					"superficieParcela",
						//"conRepercusion"		??
					"superficieConstruida",
					"divHorizontal",
					"divHorInscrito",
					"estadoDivHorizontalCodigo",
					"estadoObraNuevaCodigo",
					"fechaCfo"
    			));

    	pmap.put(TAB_SIT_POSESORIA,
    			Arrays.asList(
			    	"fechaRevisionEstado",
			    	"ocupado",
			    	"riesgoOcupacion",
			    	"conTituloTPA",
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
				    "deshabilitarCheckNoMostrarPrecioAlquiler"
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
    					"divHorizontalNoInscrita"
			    ));

    	pmap.put(TAB_COMERCIAL,
    			Arrays.asList(
					"id", // ID de activo.
					"situacionComercialCodigo",
					"fechaVenta",
					"expedienteComercialVivo",
					"observaciones",
					"importeVenta",
					"puja"
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

        mapUAs = Collections.unmodifiableMap(pmap);
    }
}
