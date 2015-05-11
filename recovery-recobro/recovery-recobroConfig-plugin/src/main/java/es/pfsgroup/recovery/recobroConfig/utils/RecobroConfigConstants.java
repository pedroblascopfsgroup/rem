package es.pfsgroup.recovery.recobroConfig.utils;


public class RecobroConfigConstants {

	public static final class RecobroAgenciasConstants {
		public static final String ID_AGENCIA= "id";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_AGENCIAS ="plugin/recobroConfig/agenciasRecobro/openABMAgencias";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_AGENCIAS_JSON ="plugin/recobroConfig/agenciasRecobro/listadoAgenciasJSON";
		public static final String PLUGIN_RECOBROCONFIG_ALTA_AGENCIA ="plugin/recobroConfig/agenciasRecobro/altaAgencia";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_LOCALIDADES_JSON = "plugin/recobroConfig/agenciasRecobro/listadoLocalidadesJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_USUARIOS_JSON = "plugin/recobroConfig/agenciasRecobro/listadoUsuariosJSON";
		public static final String PLUGIN_RECOBROCONFIG_DEFAULT ="default";
		public static final String PUGIN_RECOBRO_TEST_CONTROLLER_ERROR="El JSON que se devuelve no es correcto";

	}
	
	public static final class CarteraConstants {
		public static final String RCF_LISTA_CARTERAS = "plugin.recobroConfig.recobroCarteraManager.listaCarteras";
		public static final String PLUGIN_RCF_CARTERA_OPEN = "plugin/recobroConfig/cartera/openCartera";
		
	}
	
	public static final class RecobroEsquemasConstants {
		public static final String PLUGIN_RECOBROCONFIG_OPEN_SIMULACION = "plugin/recobroConfig/esquemaAgencia/simulacion";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_ESQUEMAS ="plugin/recobroConfig/esquemaAgencia/openABMEsquemas";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_ESQUEMAS_JSON = "plugin/recobroConfig/esquemaAgencia/listadoEsquemasJSON";
		public static final String PLUGIN_RECOBROCONFIG_ABRIR_ESQUEMA ="plugin/recobroConfig/esquemaAgencia/consultaEsquema";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_CARTERAS_ESQUEMA_JSON = "plugin/recobroConfig/esquemaAgencia/listadoCarterasEsquemasJSON";
		public static final String PLUGIN_RECOBROCONFIG_ABRIR_CONFORMAR_CARTERAS="plugin/recobroConfig/esquemaAgencia/conformarCarteras";
		public static final String PLUGIN_RECOBROCONFIG_ABRIR_FACTURACION_ESQUEMA="plugin/recobroConfig/esquemaAgencia/verFacturacionEsquema";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_ESQUEMA_JSON = "plugin/recobroConfig/esquemaAgencia/listadoSubCarterasEsquemasJSON";
		public static final String PLUGIN_RECOBROCONFIG_EDIT_FACTURACION_SUBCARTERA = "plugin/recobroConfig/esquemaAgencia/editarFacturacionSubcartera";
		public static final String PLUGIN_RECOBROCONFIG_ABRIR_FICHA_ESQUEMA="plugin/recobroConfig/esquemaAgencia/recobroFichaEsquema";
		public static final String PLUGIN_RECOBROCONFIG_EDITAR_ESQUEMA="plugin/recobroConfig/esquemaAgencia/editarEsquemaRecobro";
		public static final String PLUGIN_RECOBROCONFIG_ESQUEMA_JSON="plugin/recobroConfig/esquemaAgencia/esquemaRecobroJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_AGENCIA_JSON = "plugin/recobroConfig/esquemaAgencia/listadoSubCarterasAgenciasJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_RANKING_JSON = "plugin/recobroConfig/esquemaAgencia/listadoSubCarterasRankingJSON";
		public static final String PLUGIN_RECOBROCONFIG_ABRIR_FRM_CARTERA_ESQUEMA="plugin/recobroConfig/esquemaAgencia/frmCarteraEsquema";
		public static final String PLUGIN_RECOBROCONFIG_ABRIR_REPARTO_SUBCARTERA="plugin/recobroConfig/esquemaAgencia/repartoSubcarteras";
		public static final String PLUGIN_RECOBROCONFIG_SUBCARTERAS_ABRIR_REPARTOAGENCIAS="plugin/recobroConfig/esquemaAgencia/frmRepartoAgencias";
		public static final String PLUGIN_RECOBROCONFIG_ESQUEMA_CABIAR_ESTADO="plugin/recobroConfig/esquemaAgencia/cambiarEstadoRecobroEsquema";
		public static final String PLUGIN_RECOBROCONFIG_JSP_DOWNLOAD_FILE="plugin/recobroConfig/download";
			
	}
	
	public static final class RecobroModeloFacturacionConstants{
		public static final String PLUGIN_RECOBROCONFIG_DEFAULT ="default";		
		public static final String PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_FACTURACION="plugin/recobroConfig/facturacion/ABMFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_LAUNCHER="plugin/recobroConfig/facturacion/launcher";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_GENERAL="plugin/recobroConfig/facturacion/general";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_COBROS="plugin/recobroConfig/facturacion/cobros";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_TARIFAS="plugin/recobroConfig/facturacion/tarifas";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_CORRECTORES="plugin/recobroConfig/facturacion/correctores";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_TRAMOS_JSON="plugin/recobroConfig/facturacion/listaTramosFacturacionJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_TARIFAS_COBROS_JSON="plugin/recobroConfig/facturacion/listaTarifasCobrosJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_MODELOSFACTURACION_JSON="plugin/recobroConfig/facturacion/listaModelosFacturacionJSON";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_ALTA_MOD_FACTURACION="plugin/recobroConfig/facturacion/altaModeloFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_MODELO_FACTURACION_JSON="plugin/recobroConfig/facturacion/modeloFacturacionJSON";
		public static final String PLUGIN_RECOBROCONFIG_ADD_TRAMO_FACTURACION="plugin/recobroConfig/facturacion/addTramoFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_EDIT_TIPO_CORRECTOR="plugin/recobroConfig/facturacion/editarTipoCorrector";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_COBROS_JSON="plugin/recobroConfig/facturacion/listaCobrosJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_TRAMOS_CORRECTORES_RANKING_JSON = "plugin/recobroConfig/facturacion/listaTramosCorrectoresRankingJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_TRAMOS_CORRECTORES_OBJETIVO_JSON = "plugin/recobroConfig/facturacion/listaTramosCorrectoresObjetivoJSON";
		public static final String PLUGIN_RECOBROCONFIG_EDIT_TRAMO_CORRECTOR = "plugin/recobroConfig/facturacion/editarTramoCorrector";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_EDIT_TARIFAS="plugin/recobroConfig/facturacion/editarTarifas";
	}
	
	public static final class RecobroPoliticaDeAcuerdosConstants{
		public static final String PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_POLITICAS ="plugin/recobroConfig/politicaAcuerdos/openABMPoliticaAcuerdos";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_POLITICAS_JSON = "plugin/recobroConfig/politicaAcuerdos/listadoPoliticaAcuerdosJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_PALANCASPOLITICA_JSON = "plugin/recobroConfig/politicaAcuerdos/listadoPalancasPoliticaJSON";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_ALTA_POLITICA= "plugin/recobroConfig/politicaAcuerdos/altaPoliticaAcuerdos";
		public static final String PLUGIN_RECOBROCONFIG_VERPOLITICA_JSON= "plugin/recobroConfig/politicaAcuerdos/verPoliticaJSON";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_POLITICA= "plugin/recobroConfig/politicaAcuerdos/abrirPoliticaAcuerdos";
		public static final String PLUGIN_RECOBROCONFIG_ADD_PALANCA_POLITICA= "plugin/recobroConfig/politicaAcuerdos/addPalancaPolitica";
		public static final String PLUGIN_RECOBROCONFIG_LISTASUBPALANCAS_JSON= "plugin/recobroConfig/politicaAcuerdos/listadoSubpalancasJSON";
		
	}
	
	public static final class RecobroModeloDeRankingConstants{
		public static final String PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_MODELO_RANKING ="plugin/recobroConfig/ranking/openABMModeloRanking";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_MODELO_RANKING_JSON = "plugin/recobroConfig/ranking/listadoModeloRankingJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_VARIABLES_MODELO_RANKING_JSON = "plugin/recobroConfig/ranking/listadoVariablesModeloJSON";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_ALTA_MODELO_RANKING= "plugin/recobroConfig/ranking/altaModeloRanking";
		public static final String PLUGIN_RECOBROCONFIG_VERMODELO_RANKING_JSON= "plugin/recobroConfig/ranking/verModeloRankingJSON";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_MODELO_RANKING= "plugin/recobroConfig/ranking/abrirModeloRanking";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_ADD_VARIABLEMODELO_RANKING= "plugin/recobroConfig/ranking/asociarVariableModeloRanking";
			
	}
	
	public static final class RecobroProcesosFacturacionConstants{
		public static final String PLUGIN_RECOBROCONFIG_OPEN_LAUNCHER="plugin/recobroConfig/procesosFacturacion/launcher";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_CALCULO="plugin/recobroConfig/procesosFacturacion/calculoProcesosFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_OPEN_REMESAS="plugin/recobroConfig/procesosFacturacion/remesasProcesosFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_ALTA_PROCESOFACTURACION="plugin/recobroConfig/procesosFacturacion/altaProcesoFacturacion";
		public static final String PLUGIN_RECOBROCONFIG_JSP_DOWNLOAD_FILE="plugin/recobroConfig/download";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_PROCESOSFACTURACION_JSON="plugin/recobroConfig/procesosFacturacion/listaProcesosFacturacionJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERASFACTURACION_JSON="plugin/recobroConfig/procesosFacturacion/listaSubcarterasFacturacionJSON";
		public static final String PLUGIN_RECOBROCONFIG_LISTA_PROCESOSFACTURACIONPAGINADO_JSON="plugin/recobroConfig/procesosFacturacion/listaProcesosFacturacionPaginadoJSON";
		public static final String PLUGIN_RECOBRO_PROCESOSFACTURACION_MODIFICARMODELOS ="plugin/recobroConfig/procesosFacturacion/modificarModelosFacturacionSubcarteras";
	}
	
}
