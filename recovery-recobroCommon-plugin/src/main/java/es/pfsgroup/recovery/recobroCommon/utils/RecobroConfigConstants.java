package es.pfsgroup.recovery.recobroCommon.utils;

public interface RecobroConfigConstants {

	public static final class RecobroCommonProcesosFacturacionConstants{
		public static final String PLUGIN_RECOBRO_PROCESOFACTURACION_ULTIMAFECHA_BO="plugin.recobroConfig.recobroProcesoFacturacionApi.buscaUltimoPeriodoFacturado";
		public static final String PLUGIN_RECOBRO_PROCESOFACTURACION_GET_BO="plugin.recobroConfig.recobroProcesoFacturacionApi.getProcesoFacturacion";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_BUSCARPROCESOS_BO="plugin.recobroConfig.procesosFacturacionApi.buscarProcesos";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_GETPROCESOSBYSTATE_BO="plugin.recobroConfig.procesosFacturacionApi.getProcesosByState";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_CANCELARPROCESO_BO="plugin.recobroConfig.procesosFacturacionApi.cancelarProcesos";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_SAVE_PROCESO_BO="plugin.recobroConfig.procesosFacturacionApi.saveProcesoFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_DEFAULT ="default";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_CAMBIA_ESTADO_PROCESO_BO="plugin.recobroConfig.procesosFacturacionApi.cambiaEstadoProcesoFacturacion";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_BORRARDETALLE_BO="plugin.recobroConfig.procesosFacturacionApi.borrarDetalleFacturacion";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_GENERAREXCEL_PROCESOS_BO = "plugin.recobroConfig.procesosFacturacionApi.generarExcelProcesos";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_GENERAREXCELREDUCIDO_PROCESOS_BO = "plugin.recobroConfig.procesosFacturacionApi.generarExcelProcesosReducido";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_GUARDARMODELOS="plugin.recobroConfig.procesosFacturacionApi.guardarModelosFacturacionSubcarteras";
		
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACIONSUBCARTERA_SAVE="plugin.recobroConfig.procesosFacturacionSubcarteraApi.save";
	}
	
	public static final class RecobroCommonEsquemasConstants {
		public static final String RCF_REPARTO_SUBCARTERAS_ESTATICO = "EST";
		public static final String RCF_REPARTO_SUBCARTERAS_DINAMICO = "DIN";
		public static final String RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO = "LBR";
		
		public static final String PLUGIN_RCF_API_ESQUEMA_BUSCAR_ESQUEMAS_BO = "plugin.recobroConfig.recobroEsquemaApi.buscarEsquemas";
		public static final String PLUGIN_RCF_API_ESQUEMA_COPIAR_ESQUEMA_BO = "plugin.recobroConfig.recobroEsquemaApi.copiarEsquema";
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_SAVE_MODELOS_SUBCARTERA_BO="plugin.recobroConfig.recobroEsquemaApi.guardarModelosSubcartera";
		
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_GET_BO="plugin.recobroConfig.recobroEsquemaApi.getEsquema";
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_GETLIST_BO="plugin.recobroConfig.recobroEsquemaApi.getListaEsquemas";
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_DELETEESQUEMA_BO="plugin.recobroConfig.recobroEsquemaApi.deleteEsquema";
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_SAVEESQUEMA_BO="plugin.recobroConfig.recobroEsquemaApi.saveEsquema";
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_GET_CARTERA_ESQUEMA_BO="plugin.recobroConfig.recobroEsquemaApi.getRecobroCarteraEsquema";
		public static final String PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERA_BY_ESQUEMACARTERA_BO = "plugin.recobroConfig.recobroSubcarteraApi.buscarSubCarByEsquemaCartera";
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_GETSUBCARTERA_BO="plugin.recobroConfig.recobroEsquemaApi.getSubcartera";
		public static final String PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERAAGENCIAS_BO="plugin.recobroConfig.recobroEsquemaApi.getSubcateraAgencias";
		public static final String PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERARANKING_BO="plugin.recobroConfig.recobroEsquemaApi.getSubcateraRanking";
		public static final String PLUGIN_RECOBRO_ESQUEMAAPI_SAVE_AGENCIAS_SUBCARTERA_BO="plugin.recobroConfig.recobroEsquemaApi.guardarAgenciasSubcartera";
		public static final String PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERA_BY_ITI_BO = "plugin.recobroConfig.recobroSubcarteraApi.buscarSubCarByIti";
		public static final String PLUGIN_RCF_API_ESQUEMA_GET_SUBCATERA_BY_ID_BO = "plugin.recobroConfig.recobroSubcarteraApi.getSubCarById";
		public static final String PLUGIN_RCF_API_ESQUEMA_BORRA_SUBCATERA_BO = "plugin.recobroConfig.recobroSubcarteraApi.borraSubCar";
		public static final String PLUGIN_RECOBRO_CARTERAESQUEMAAPI_GET_BO = "plugin.recobroConfig.recobroCarteraEsquemaApi.get";
		public static final String PLUGIN_RECOBRO_CARTERAESQUEMAAPI_DELETE_BO = "plugin.recobroConfig.recobroCarteraEsquemaApi.delete";
		public static final String PLUGIN_RECOBRO_CARTERAESQUEMAAPI_SAVE_BO = "plugin.recobroConfig.recobroCarteraEsquemaApi.save";
		public static final String PLUGIN_RECOBROCONFIG_ESQUEMA_CABIAR_ESTADO_BO="plugin.recobroConfig.esquemaAgencia.cambiarEstadoRecobroEsquema";
		public static final String PLUGIN_RECOBROCONFIG_GET_SIMULACION_ESQUEMA_BO = "plugin.recobroConfig.recobroCarteraEsquemaApi.getSimulacionEsquema";
		public static final String PLUGIN_RECOBROCONFIG_GET_FICHERO_SIMULACION_BO = "plugin.recobroConfig.recobroCarteraEsquemaApi.getFicheroSimulacion";
		public static final String PLUGIN_RECOBROCONFIG_ULTIMA_VERSION_ESQUEMA_BO = "plugin.recobroConfig.recobroEsquemaApi.ultimaVersionDelEsquema";
		public static final String PLUGIN_RECOBROCONFIG_GET_ULTIMA_VERSION_ESQUEMA_BO = "plugin.recobroConfig.recobroEsquemaApi.getUltimaVersionDelEsquema";
		public static final String PLUGIN_RECOBROCONFIG_EN_ESQUEMA_LIBERADO_BO = "plugin.recobroConfig.recobroEsquemaApi.esVersionDelEsquemaliberado";
		public static final String PLUGIN_RECOBROCONFIG_ESQUEMAAPI_APTOLIBERAR_BO = "plugin.recobroConfig.recobroEsquemaApi.compruebaEstadoCorrectoLiberar";
		public static final String PLUGIN_RCF_API_SUBCARTERA_GETLIST_BO = "plugin.recobroCommon.recobroSubCarteraApi.getList";
		public static final String PLUGIN_RECOBRO_CARTERAESQUEMAAPI_GET2_BO = "plugin.recobroConfig.recobroCarteraEsquemaApi.get2";
		public static final String PLUGIN_RCF_API_ESQUEMA_GET_ESQUEMAS_BLOQUEADOS = "plugin.recobroConfig.recobroCarteraEsquemaApi.getEsquemasBloqueados";
	
	}
	
	public static final class CarteraCommonConstants {
		public static final String RCF_LISTA_CARTERAS = "plugin.recobroConfig.recobroCarteraManager.listaCarteras";
		public static final String PLUGIN_RCF_API_CARTERA_BUSCAR_CARTERAS_BO = "plugin.recobroConfig.recobroCarteraManager.buscarCarteras";
		public static final String PLUGIN_RCF_API_CARTERA_BUSCAR_CARTERASDISPONIBLES_BO = "plugin.recobroConfig.recobroCarteraManager.buscarCarterasDisponibles";
		public static final String PLUGIN_RCF_API_CARTERA_ALTA_CARTERAS_BO = "plugin.recobroConfig.recobroCarteraManager.altaCartera";
		public static final String PLUGIN_RCF_API_CARTERA_ELIMINAR_CARTERAS_BO = "plugin.recobroConfig.recobroCarteraManager.eliminarCartera";
		public static final String PLUGIN_RCF_API_CARTERA_GET_CARTERAS_BO = "plugin.recobroConfig.recobroCarteraManager.getCartera";
		public static final String PLUGIN_RCF_API_CARTERA_GET_ESQUEMAS_BO = "plugin.recobroConfig.recobroCarteraManager.listaEsquemas";
		public static final String PLUGIN_RCF_API_CARTERA_COPIAR_CARTERAS_BO = "plugin.recobroConfig.recobroCarteraManager.copiarRecobroCartera";
		public static final String PLUGIN_RCF_API_CARTERA_CAMBIARESTADO_CARTERAS_BO = "plugin.recobroConfig.recobroCarteraManager.cambiarEstadoCartera";
		public static final String PLUGIN_RCF_API_CARTERA_GETLIST_BO = "plugin.recobroConfig.recobroCarteraManager.getList";
		
	}
	
	public static final class RecobroCommonModeloFacturacionConstants{
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_BO="plugin.recobroConfig.recobroModeloFacturacionApi.getListModelosFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GET_BO="plugin.recobroConfig.recobroModeloFacturacionApi.getModelosFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GET_COBROS_BO="plugin.recobroConfig.recobroModeloFacturacionApi.getCobros";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_HABILITAR_COBRO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.habilitarCobro";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_DESHABILITAR_COBRO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.desHabilitarCobro";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_BUSCARMODELOS_BO="plugin.recobroConfig.recobroModeloFacturacionApi.buscarModelosFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_SAVEMODELO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.guardaModeloFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_TRAMOS_BO="plugin.recobroConfig.recobroModeloFacturacionApi.getListTramosFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_TARIFAS_COBRO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.getListTarifasCobro";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_DELETE_MODELO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.borrarModeloFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_SAVE_TRAMO_FACTURACION_BO="plugin.recobroConfig.recobroModeloFacturacionApi.guardarTramoFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_DELETE_TRAMO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.borrarTramoFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GET_TRAMO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.getTramoFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_SAVE_TARIFAS_TRAMOS_BO="plugin.recobroConfig.recobroModeloFacturacionApi.guardarTarifasTramos";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GUARDAR_TRAMO_CORRECTOR_BO = "plugin.recobroConfig.facturacion.guardarTramoCorrector";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_GUARDAR_TIPO_CORRECTOR="plugin.recobroConfig.recobroModeloFacturacionApi.guardarTipoCorrector";
		public static final String PLUGIN_RECOBROCONFIG_GET_TRAMO_CORRECTOR_BO = "plugin.recobroConfig.facturacion.getCorrectorFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_DELETE_TRAMO_CORRECTOR_BO = "plugin.recobroConfig.facturacion.borrarTramoCorrector";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_CAMBIAESTADO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.cambiaEstadoModeloFacturacion";
		public static final String PLUGIN_RECOBRO_MODELOFACTURACION_COPIAMODELO_BO="plugin.recobroConfig.recobroModeloFacturacionApi.copiarModeloFacturacion";
		
	}
	
	public static final class RecobroCommonPoliticaDeAcuerdosConstants{
		public static final String PLUGIN_RECOBRO_POLITICAAPI_BUSCARPOLITICAS_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.buscaPoliticas";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_GETPOLITICASDEACUERDO_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.getPoliticasDeAcuerdo";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_GETPOLITICADEACUERDO_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.getPoliticaDeAcuerdo";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_SAVEPOLITICADEACUERDO_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.savePoliticaDeAcuerdo";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_DELETE_POLITICADEACUERDO_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.deletePoliticaDeAcuerdo";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_GUARDA_PALANCA_POLITICA_BO= "plugin.recobroConfig.recobroPoliticaAcuerdosApi.deletePoliticaDeAcuerdo.guardaPalancaPolitica";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_GETPALANCAPOLITICA_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.getPoliticaDeAcuerdosPalanca";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_BORRAR_PALANCAPOLITICA_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.borrarPalancaPoliticaDeAcuerdos";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_BORRAR_PALANCA_RECALC_PRIOR_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.borrarPalancaRecualculoPrioridades";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_GETSUBPALANCAS_BO="plugin.recobroConfig.recobroPoliticaAcuerdosApi.getSubtiposPalanca";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_COPIA_POLITICA_BO= "plugin.recobroConfig.recobroPoliticaAcuerdosApi.deletePoliticaDeAcuerdo.copiarPoliticaAcuerdos";
		public static final String PLUGIN_RECOBRO_POLITICAAPI_CAMBIARESTADO_POLITICA_BO= "plugin.recobroConfig.recobroPoliticaAcuerdosApi.deletePoliticaDeAcuerdo.cambiarEstadoPoliticaAcuerdos";
	}
	
	public static final class ItinerariosCommonConstants {
		public static final String PLUGIN_RCF_API_ITI_BUSCAR_ITINERARIOS_BO = "plugin.recobroConfig.recobroItinerarioManager.buscarItinerarios";
		public static final String PLUGIN_RCF_API_ITI_GUARDAR_ITINERARIO_BO = "plugin.recobroConfig.recobroItinerarioManager.guardarItinerario";
		public static final String PLUGIN_RCF_API_ITI_ELIMINAR_ITINERARIOS_BO = "plugin.recobroConfig.recobroItinerarioManager.eliminarItinerario";
		public static final String PLUGIN_RCF_API_ITI_GET_ITINERARIO_BO = "plugin.recobroConfig.recobroItinerarioManager.getItinerario";
		public static final String PLUGIN_RCF_API_ITI_BUSCA_METAS_POR_ITI_BO = "plugin.recobroConfig.recobroItinerarioManager.buscaMetasPorIti";
		public static final String PLUGIN_RCF_API_ITI_BUSCA_DTOMETAS_POR_ITI_BO="plugin.recobroConfig.recobroItinerarioManager.buscaDtoMetasPorIti";
		public static final String PLUGIN_RCF_API_ITI_GUARDAR_METAS_BO = "plugin.recobroConfig.recobroItinerarioManager.guardarMetas";
		public static final String PLUGIN_RCF_API_ITI_GET_ITINERARIOS_METAS_VOLANTES_BO= "plugin.recobroConfig.recobroItinerarioManager.getItinerariosMetasVolantes";
		public static final String PLUGIN_RCF_API_ITI_GUARDAR_LISTAMETAS_BO="plugin.recobroConfig.recobroItinerarioManager.guardaListaMetasVolantes";
		public static final String PLUGIN_RCF_API_ITI_GUARDAR_LISTDDSINO_BO="plugin.recobroConfig.recobroItinerarioManager.guardaListDDSiNo";
		public static final String PLUGIN_RCF_API_ITI_GET_RECOBROMETA_BO = "plugin.recobroConfig.recobroItinerarioManager.getRecobroMetaVolante";
		public static final String PLUGIN_RCF_API_ITI_COPIAR_ITINERARIOS_BO = "plugin.recobroConfig.recobroItinerarioManager.copiaItinerarioMetasVolantes";
		public static final String PLUGIN_RCF_API_ITI_CAMBIAESTADO_ITINERARIOS_BO = "plugin.recobroConfig.recobroItinerarioManager.cambiaEstadoItinerario";
		
	}
	
	public static final class RecobroCommonModeloDeRankingConstants{
		public static final String PLUGIN_RECOBRO_MODELORANKING_GETLIST_BO="plugin.recobroConfig.recobroModeloDeRankingApi.getListModelosDeRanking";
		public static final String PLUGIN_RECOBRO_MODELORANKING_GET_BO="plugin.recobroConfig.recobroModeloDeRankingApi.getModelosDeRanking";
		public static final String PLUGIN_RECOBRO_MODELORANKING_SAVEMODELORANKING_BO="plugin.recobroConfig.recobroModeloDeRankingApi.saveModeloRanking";
		public static final String PLUGIN_RECOBRO_MODELORANKING_DELETE_MODELORANKING_BO="plugin.recobroConfig.recobroModeloDeRankingApi.borrarModeloDeRanking";
		public static final String PLUGIN_RECOBRO_MODELORANKING_DELETE_VARIABLERANKING_BO="plugin.recobroConfig.recobroModeloDeRankingApi.borrarVariableModeloRanking";
		public static final String PLUGIN_RECOBRO_MODELORANKING_BUSCARMODELORANKING_BO="plugin.recobroConfig.recobroModeloDeRankingApi.buscaModeloRanking";
		public static final String PLUGIN_RECOBRO_MODELORANKING_ASOCIAVARIABLE_BO="plugin.recobroConfig.recobroModeloDeRankingApi.saveVariableModelo";
		public static final String PLUGIN_RECOBRO_MODELORANKING_GET_VARIABLE_BO="plugin.recobroConfig.recobroModeloDeRankingApi.getModeloRankingVariable";
		public static final String PLUGIN_RECOBRO_MODELORANKING_COPIAR_MODELORANKING_BO="plugin.recobroConfig.recobroModeloDeRankingApi.copiarModeloRanking";
		public static final String PLUGIN_RECOBRO_MODELORANKING_CAMBIAESTADO_MODELORANKING_BO="plugin.recobroConfig.recobroModeloDeRankingApi.cambiaEstadoModelo";
		
	}
	
	public static final class RecobroCommonAgenciasConstants {
		public static final String ID_AGENCIA= "id";
		public static final String PLUGIN_RECOBRO_AGENCIAAPI_BUSCARAGENCIAS_BO="plugin.recobroConfig.recobroAgenciaApi.buscaAgencias";
		public static final String PLUGIN_RECOBRO_AGENCIAAPI_BUSCARAGENCIAS_TODAS_BO="plugin.recobroConfig.recobroAgenciaApi.buscaAgenciasTodas";
		public static final String PLUGIN_RECOBRO_AGENCIAAPI_SAVEAGENCIA_BO="plugin.recobroConfig.recobroAgenciaApi.saveAgencia";
		public static final String PLUGIN_RECOBRO_AGENCIAAPI_DELETEAGENCIA_BO="plugin.recobroConfig.recobroAgenciaApi.deleteAgencia";
		public static final String PLUGIN_RECOBRO_AGENCIAAPI_GET_BO="plugin.recobroConfig.recobroAgenciaApi.getAgencia";
		public static final String PLUGIN_RECOBOR_AGENCIAAPI_BUSCABYUSUARIO = "plugin.recobroConfig.recobroAgenciaApi.buscaAgenciasDeUsuario";
		public static final String PLUGIN_RECOBOR_AGENCIAAPI_BUSCABYDESPACHO = "plugin.recobroConfig.recobroAgenciaApi.buscaAgenciasDespacho";
	}

	public static final class RecobroCommonCicloRecobroExpedienteConstants{
		public static final String PLUGIN_RECOBRO_CICLORECOBROEXP_GETPAGE_BO="plugin.recobroCommon.cicloRecobroExpediente.getPage";
		public static final String PLUGIN_RECOBRO_CICLORECOBROEXP_BY_USU_GETPAGE_BO = "plugin.recobroCommon.cicloRecobroExpediente.getPageCicloRecobroExpedienteTipoUsuario";
	}
	
	public static final class CicloRecobroExpedienteConstants {
		public static final String PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSPERSONAEXP_BO="plugin.recobroCommon.recobroAgenciaApi.getListCiclosRecobroPersonaExpediente";
		public static final String PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSPERSONAEXPDTO_BO="plugin.recobroCommon.recobroAgenciaApi.dameListaMapeadaCiclosRecobroPersonaExpediente";
		public static final String PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSCNTEXPDTO_BO = "plugin.recobroCommon.recobroAgenciaApi.dameListaMapeadaCiclosRecobroContratoExpediente";		
		
	}
	
	public static final class RecobroCommonCicloRecobroContratoConstants{
		public static final String PLUGIN_RECOBRO_CICLORECOBROCNT_GETPAGE_BO="plugin.recobroCommon.cicloRecobroContrato.getPage";
		public static final String PLUGIN_RECOBRO_CICLORECOBROCNT_LISTADTOCICLOSCNTEXP_BO = "plugin.recobroCommon.cicloRecobroContrato.getCiclosRecobroPersonaExpediente";
		public static final String PLUGIN_RECOBRO_CICLORECOBROCNT_LISTACICLOCNTEXP_AGENCIA_BO = "plugin.recobroCommon.cicloRecobroContrato.getCiclosRecobroContratoExpedienteAgencia";
	}
	
	public static final class RecobroCommonCicloRecobroPersonaConstants{
		public static final String PLUGIN_RECOBRO_CICLORECOBROPER_GETPAGE_BO="plugin.recobroCommon.cicloRecobroPersona.getPage";
	}

	public static final class RecobroCommonAccionesExtrajudicialesConstants{
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_UNCHECKED = "unchecked";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_1 = 
				" Select ae from RecobroAccionesExtrajudiciales ae ";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_2 = 
				" where ae.agencia.id = ";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_3 = 
				" and ae.resultadoGestionTelefonica.id = ";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_4 = 
				" and ae.fechaGestion > '";	
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_CONTRATO_INTERVALO_FECHA_1 = 
				" and ae.fechaGestion between '";	
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_CONTRATO = 
				" and ae.contrato.id = ";	
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_PERSONA = 
				" and ae.persona.id = ";	
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_BO="plugin.recobroCommon." +
				"accionesExtrajudiciales.obtenerAccionesExtrajudicialesPorAgenciaResultadoFechaGestion.getPage";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_OBTENER_ACCIONES_POR_AGENCIA_CONTRATO_RESULTADO_FECHA_BO="plugin.recobroCommon." +
				"accionesExtrajudiciales.obtenerAccionesExtrajudicialesPorAgenciaContratoResultadoFechaGestion.getPage";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_CICLORECOBROCONTRATO_BO = "plugin.recobroCommon." +
				"accionesExtrajudiciales.getPageAccionesCicloRecobroContrato";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_CICLORECOBROPERSONA_BO = "plugin.recobroCommon." +
				"accionesExtrajudiciales.getPageAccionesCicloRecobroPersona";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_EXPEDIENTE_BO = "plugin.recobroCommon." +
				"accionesExtrajudiciales.getPageAccionesRecobroExpediente";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_BO = "plugin.recobroCommon." +
				"accionesExtrajudiciales.getAccionExtrajudicial";

		public static final String BO_EXP_GET_LISTADO_TIPO_GESTION = "plugin.recobroCommon.getListadoTipoGestion";
		public static final String BO_EXP_GET_LISTADO_TIPO_RESULTADO = "plugin.recobroCommon.getListadoTipoResultado";

		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA = "'";
		
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA_AND_COMILLA = "' and '";
		public static final String PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_EXP_BYUSU_BO = "plugin.recobroCommon.accionesExtrajudiciales.getPageAccionesRecobroExpedientePorTipoUsuario";
		
	}

	public static final class ExpedienteRecobroContants {
		
		public static final String BO_EXP_REC_OBTENER_NUM_CONTRATOS_GENERACION_EXP_MANUAL = "expedienteRecobroApi.obtenerNumContratosGeneracionExpManual";
		public static final String BO_EXP_REC_CREARF_EXP_MANUAL_RECOBRO = "expedienteRecobroApi.crearExpedienteManual";
		public static final String BO_EXP_REC_CANCELA_EXP_MANUAL_RECOBRO = "expedienteRecobroApi.cancelacionExpManualRecobro";

		public static final String BO_EXP_REC_GETEXPEDIENTE = "expedienteRecobroApi.getExpedienteRecobro";
		public static final String BO_EXP_GET_AGENCIAS_RECOBRO = "expedienteRecobroApi.getAgenciasRecobro";
		public static final String BO_EXP_GET_GESTORRECOBRO_ACTIVO_BO = "expedienteRecobroApi.getGestorRecobroActualExpediente";		

		// Copiadas del mejoras para sobreescribirlas.

		public static final String BO_EXP_REC_GET_MODELO_FACTURACION = "expedienteRecobroApi.getModeloFacturacion";
		public static final String BO_EXP_MGR_PROPONER_ACTIVAR_EXPEDIENTE_RECOBRO = "expedienteRecobroApi.activarExpedienteRecobro";
		public static final String BO_EXP_MGR_BUSQUEDA_CONTRATOS_RECOBRO = "expedienteRecobroApi.busquedaContratosRecobro";
		public static final String BO_EXP_GET_CABECERA_EXPEDIENTE_RECOBRO = "expedienteRecobroApi.getCabeceraExpedienteRecobro";

		public static final String MEJ_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE = "expedienteManager.excluirContratosAlExpediente";
		public static final String MEJ_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE = "expedienteManager.incluirContratosAlExpediente";
		public static final String BO_EXP_IS_GESTORRECOBROEXP = "expedienteRecobroApi.esGestorRecobroExpediente";
		public static final String BO_EXP_GETLIST_ACUERDOS = "expedienteRecobroApi.getAcuerdosExpediente";
		public static final String BO_EXP_GUARDA_ACUERDO_EXPEDIENTE = "expedienteRecobroApi.guardarAcuerdoExpediente";
		public static final String BO_EXP_PROPONER_ACUERDO = "expedienteRecobroApi.proponerAcuerdo";
		public static final String BO_EXP_CANCELAR_ACUERDO = "expedienteRecobroApi.cancelarAcuerdo";
		public static final String BO_EXP_LISTA_PALANCAS_PERMITIDAS = "expedienteRecobroApi.buscaPalancasPermitidasExpediente";
		public static final String BO_EXP_GET_BY_ID = "expedienteRecobroApi.getExpediente";
		public static final String BO_EXP_IS_SUPERVISORRECOBROEXP = "expedienteRecobroApi.esSupervisorRecobroExpediente";
		public static final String BO_EXP_IS_AGENCIARECOBRO_EXP = "expedienteRecobroApi.esAgenciaRecobroExpediente";
		public static final String BO_EXP_GET_AGENCIAS_RECOBRO_USU = "expedienteRecobroApi.getAgenciasRecobroUsuario";
		public static final String BO_EXP_GET_ID_SAGER = "expedienteRecobroApi.getIdSAGER";

	}
	
	public static final class FuncionesConstants {
		public static final String ROLE_VISIB_COMPLETA_RECOBRO_EXT = "ROLE_VISIB_COMPLETA_RECOBRO_EXT";
		public static final String TODAS_LAS_ACCIONES_SIN_AGENCIA="TODAS_LAS_ACCIONES_SIN_AGENCIA";
		
	}
	
	public static final class RecobroSimulacionEsquemaConstants {
		public static final String RECOBRO_SIMULACION_GET_SIMULACIONES_ESQUEMA = "recobroSimulacionApi.getSimulacionesDelEsquema";
		public static final String RECOBRO_SIMULACION_GET_SIMULACIONES_POR_ESTADO = "recobroSimulacionApi.getSimulacionesPorEstado";
	}

}

