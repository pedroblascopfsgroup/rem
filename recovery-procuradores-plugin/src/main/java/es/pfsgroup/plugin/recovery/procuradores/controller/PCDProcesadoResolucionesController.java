package es.pfsgroup.plugin.recovery.procuradores.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.plazaJuzgado.BuscaPlazaPaginadoDtoInfo;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.DDCompletitud;
import es.capgemini.pfs.procesosJudiciales.model.DDCorrectoCobro;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.DDImpugnacion1;
import es.capgemini.pfs.procesosJudiciales.model.DDPositivoNegativo;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.prorroga.model.CausaProrroga;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDDecisionSuspension;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDMotivoSuspSubasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVAsuntoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVCampoDinamico;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDMotivoInadmision;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDMotivosArchivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDRequerimientoPrevio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.mejoras.web.genericForm.GenericFormManagerApi;
import es.pfsgroup.plugin.recovery.mejoras.web.genericForm.MEJGenericFormManager;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.plugin.recovery.procuradores.api.PCDProcesadoResolucionesApi;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.api.MSVAsuntoAllApi;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;
import es.pfsgroup.plugin.recovery.procuradores.procesado.api.PCDResolucionProcuradorApi;
import es.pfsgroup.procedimientos.model.DDIndebidaExcesiva;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.datosprc.model.RecoveryBPMfwkDatosProcedimiento;
import es.capgemini.devon.exception.FrameworkException;

/**
 * @author manuel
 *
 * Controlador encargado de atender las peticiones de la pantalla de Procesado de resoluciones. 
 */
@Controller
public class PCDProcesadoResolucionesController {
	
	private static final String CON_TESTIMONIO = "conTestimonio";

	private static final String PREFIJO_CAMPOS_DINAMICOS = "d_";

	public static final String JSP_ABRIR_PANTALLA = "plugin/procuradores/procesadoProcuradores";

	public static final String JSON_COMPROBAR_ASUNTO = "";

	public static final String JSON_AYUDA = "plugin/masivo/datosAyudaResolucionJSON";

	public static final String JSON_MOSTRAR_PROCESOS_RESOLUCION = "plugin/masivo/datosProcesosResolucionJSON";
	
	public static final String JSON_MOSTRAR_PROCESOS_RESOLUCION_PAGINATED = "plugin/masivo/datosProcesosResolucionPaginatedJSON";

	public static final String JSON_DIBUJRA_DATOS_DINAMICOS = "";

	public static final String JSON_ADJUNTAR_FICHERO = "";

	public static final String JSON_GRABAR_PROCESAR = "plugin/procuradores/datosResolucionJSON";

	public static final String JSON_LISTA_ASUNTOS = "plugin/masivo/listaAsuntosJSON";

	public static final String JSP_VENTANA_RESOLUCION_DESDE_TAREA = "plugin/procuradores/ventanaResolucionDesdeTarea";

	public static final String JSON_LISTA_TIPOS_RESOLUCION = "plugin/masivo/listaTiposResolucionJSON";

	public static final String JSON_LISTA_TIPOS_REQUERIMIENTO = "plugin/masivo/listaTiposRequerimientoJSON";

	public static final String JSON_LISTA_MOTIVOS_INADMISION = "plugin/masivo/listaMotivosInadmisionJSON";

	public static final String JSON_LISTA_PLAZAS = "plugin/masivo/listaPlazasJSON";

	public static final String JSON_LISTA_JUZGADOSPLAZA = "plugin/masivo/listaJuzgadosPlazasJSON";

	public static final String JSON_DEMANDADOSASUNTO = "plugin/masivo/demandadosAsuntoJSON";

	public static final String JSON_DOMICILIOS_DEMANDADO = "plugin/masivo/domiciliosDemandadoJSON";

	private static final String JSON_BIENES_DEMANDADO =  "plugin/masivo/bienesDemandadoJSON";

	private static final String JSON_PROCEDIMIENTO = "plugin/masivo/procedimientos/procedimientoJSON";

	private static final String JSON_LISTA_MOTIVOS_ARCHIVO = "plugin/masivo/listaMotivosArchivoJSON";

	private static final String JSON_DATOS_ADICIONALES = "plugin/masivo/datosAdicionalesJSON";
	
	private static final String JSON_LISTA_MOTIVOS_PRORROGA = "plugin/procuradores/listaMotivosProrrogaJSON";
	
	private static final String ESTADO_GUARDAR = MSVDDEstadoProceso.CODIGO_PTE_VALIDAR;
	
	private static final String ESTADO_PROCESADO = MSVDDEstadoProceso.CODIGO_PROCESADO;
	
	private static final String ESTADO_RECHAZADO = MSVDDEstadoProceso.CODIGO_RECHAZADO;
	
	private static final String ESTADO_PAUSADO = MSVDDEstadoProceso.CODIGO_PAUSADO;
	
	private static final String PREFIJO_RESESPECIALES = "RESOL_ESP_";
	
	private static final String CODIGO_COMUNICACION = "RESOL_ESP_COMU";
	
	private static final String CODIGO_TAREA = "RESOL_ESP_TAREA";
	
	private static final String CODIGO_AUTOTAREA = "RESOL_ESP_AUTOTAREA";
	
	public static final String CODIGO_AUTOPRORROGA = "RESOL_PROCU_AUTO";
	
	private static final String CODIGO_NOTIFICACION = "RESOL_ESP_NOTI";
	
	private static final String JSON_LISTA_MOTIVOS_SUSPENSION = "plugin/procuradores/subasta/motivoSuspensionSubastaJSON";
	
	private static final String JSON_LISTA_DECISION_SUSPENSION = "plugin/procuradores/subasta/decisionSuspensionSubastaJSON";
	
	private static final String JSON_LISTA_ENTIDADES_ADJUDICATORIAS = "plugin/procuradores/adjudicacion/entidadesAdjudicatoriasJSON";
	
	private static final String JSON_LISTA_TIPOS_FONDOS = "plugin/procuradores/adjudicacion/tiposFondoJSON";
	
	private static final String JSON_LISTA_MOTIVOS_IMPUGNACION = "plugin/procuradores/costas/motivosImpugnacionJSON";
	
	private static final String JSON_LISTA_MOTIVOS_FAVORABLES = "plugin/procuradores/costas/motivosFavorablesJSON";
	
	private static final String JSON_LISTA_DD_COMPLETITUDES = "plugin/procuradores/cargas/ddCompletitudJSON";
	
	private static final String JSON_LISTA_DD_POSITIVO_NEGATIVO = "plugin/procuradores/ocupantes/ddPositivoNegativoJSON";
	
	private static final String JSON_LISTA_DD_CORRECTO_COBRO = "plugin/procuradores/embargo_salarios/ddCorrectoCobroJSON";
	
	private static final String CODIGO_SUBIDA_FICHEROS = "RESOL_ESP_UPLOAD";

	private static final String JSON_LISTA_DICCIONARIO_GENERICO_PAGE = "plugin/procuradores/diccionarioGenericoJSON";
	private static final String JSON_LISTA_DICCIONARIO_GENERICO_LIST = "plugin/procuradores/diccionarioGenericoListJSON";
	
	private static final String JSON_EXISTEN_TAREAS_PENDIENTES_VALIDAR = "plugin/procuradores/tareas/existenTareasPendientesValidarJSON";
	
	private static final String JSON_LISTA_VALORES_CAMPOS_RESOLUCION = "plugin/procuradores/valoresCamposResolucionJSON";
	
	public static final String JSON_VALIDACION = "plugin/procuradores/datosValidacionResolucionJSON";
	
	private static final String JSON_LISTA_INDEBIDAS = "plugin/procuradores/listaIndebidasJSON";

	private static final String JSON_GRABAR_PROCESAR_ERROR = "plugin/procuradores/datosResolucionErrorJSON";
	
	
	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private PCDResolucionProcuradorApi pcdResolucionProcuradorApi;
	
	@Autowired
	private MEJGenericFormManager mejGenericFormManager;

	@Autowired
	private PCDProcesadoResolucionesApi pcdProcesadoResolucionesApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionario;
	
	
	/**
	 * Muestra la pantalla de procesado de resoluciones.
	 * @param model
	 * @return ruta del jsp a mostrar
	 * 
	 */
	@RequestMapping
	public String abrirPantalla(ModelMap model){
		
		return JSP_ABRIR_PANTALLA;
	}
	

	/**
	 * Comprueba si existe un asunto.
	 * 
	 * @param model
	 * @return json con informacion sobre el asunto.
	 */
	@RequestMapping
	public String comprobarAsunto(ModelMap model){
		
		return JSON_COMPROBAR_ASUNTO;
	}
	

	/**
	 * Obtine el listado de procesos de resoluciones en ejecución. Listado paginado.
	 * 
	 * @param model
	 * @return json los datos de los procesos.
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String mostarProcesos(MSVDtoFiltroProcesos dto,ModelMap model){
		
		//llamamos al ProcesoManager
		 Page listaProcesosResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).mostrarResoluciones(dto);
		 
		 model.put("data", listaProcesosResolucion);
		 
		
		return JSON_MOSTRAR_PROCESOS_RESOLUCION_PAGINATED;
	}
	

	/**
	 * obtiene los datos din�micos que hay que mostrar en la pantalla en funci�n de la resoluci�n.
	 * @param model
	 * @return json con informaci�n sobre los datos a mostrar.
	 */
	@RequestMapping
	public String dibujarDatosDinamicos(ModelMap model){
		
		return JSON_DIBUJRA_DATOS_DINAMICOS;
	}
	

	/**
	 * Devuleve los datos de la ayuda.
	 * @param model
	 * @return ruta del jsp a mostrar
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String dameAyuda(Long idTipoResolucion, ModelMap model){
		
		String html = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).dameAyuda(idTipoResolucion);
		
		model.put("html", html);
		
		return JSON_AYUDA;
	}
	
	/**
	 * Devuleve un jsp que dibujar� el formulario din�mico dependiendo del tipo de resoluci�n que se le pase
	 * en el futuro el formulario a dibujar se elegir� en base al tipo de procedimiento y de tarea, 
	 * ahora se hace mediante javascript
	 * ESTE M�TODO HA PASADO AL PLUGIN DE LINDORFF
	 * @param model
	 * @return ruta del jsp a mostrar
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	//@Deprecated
	public String abreFormularioDinamicoDesdeProcedimiento(Long idResolucion, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).getResolucion(idResolucion);
		Long idTipoResolucion = msvResolucion.getTipoResolucion().getId();
		Long idProcedimiento = msvResolucion.getProcedimiento().getId();
		Long idAsunto = msvResolucion.getAsunto().getId();
		Long idTarea = msvResolucion.getTarea().getId();
		String codigoTipoProc = msvResolucion.getTipoResolucion().getCodigo();
		String html = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).dameAyuda(idTipoResolucion);
		String validacion = null;
				
		if(!msvResolucion.getTipoResolucion().getTipoAccion().getCodigo().equals("INFO")){
			validacion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).dameValidacion(idTarea);	
		}
		
		
		model.put("html", html);
		model.put("idTipoResolucion", idTipoResolucion);
		model.put("idProcedimiento", idProcedimiento);
		model.put("idAsunto", idAsunto);
		model.put("idTarea", idTarea);
		model.put("codigoTipoProc", codigoTipoProc);
		model.put("idResolucion", idResolucion);
		model.put("codigoPlaza", 11);
		model.put("validacion", validacion);
		model.put("estadoResolucion", msvResolucion.getEstadoResolucion().getCodigo());
		
		////Validamos si se muestra en boton de Pausar
		model.put("permitirPausar", false);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		if (!Checks.esNulo(usuarioLogado)){ 
			List<GestorDespacho> gestorDespacho = configuracionDespachoExternoApi.buscaDespachosPorUsuarioYTipo(usuarioLogado.getId(), DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
			
			if((!Checks.esNulo(gestorDespacho) && gestorDespacho.size()>0)){
				DespachoExterno despacho = gestorDespacho.get(0).getDespachoExterno();	
				if(configuracionDespachoExternoApi.isDespachoIntegral(despacho.getId())){
					model.put("permitirPausar", configuracionDespachoExternoApi.getConfiguracion(despacho.getId()).getPausados());	
				}
					
			}			
		}
		
		return JSP_VENTANA_RESOLUCION_DESDE_TAREA;
	}
	
	
	/**
	 * devuelve la validacion.
	 * @param model
	 * @return String validacion
	 */
	@RequestMapping
	public String dameValidacion(Long idResolucion, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).getResolucion(idResolucion);
		
		Long idTarea = msvResolucion.getTarea().getId();
		
		String validacion = null;
		
		if(!msvResolucion.getTipoResolucion().getTipoAccion().getCodigo().equals("INFO")){
			validacion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).dameValidacion(idTarea);	
		}
		
		model.put("validacion", validacion);
		
		return JSON_VALIDACION;
	}
	
	
	
	/**
	 * devuelve la validacion JBPM.
	 * @param model
	 * @return String validacion JBPM
	 */
	@RequestMapping
	public String dameValidacionJBPM(Long idResolucion, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).getResolucion(idResolucion);
		
		Long idTarea = msvResolucion.getTarea().getId();
		
		String validacion = null;
		
		if(!msvResolucion.getTipoResolucion().getTipoAccion().getCodigo().equals("INFO")){
			validacion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).dameValidacionJBPM(idTarea);	
		}
		
		model.put("validacion", validacion);
		
		return JSON_VALIDACION;
	}
	
	/**
	 * adjunta un fichero.
	 * @param model
	 * @return json indicando si la subida ha sido correcta. 
	 */
	@RequestMapping
	public String adjuntarFichero(ModelMap model){
		
		return JSON_ADJUNTAR_FICHERO;
	}
	
	/**
	 * guarda los datos de un asunto y lo marca para procesar.
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String grabarYProcesar(MSVResolucionesDto dtoResolucion, ModelMap model, WebRequest request) throws Exception{
		
		MSVResolucion msvResolucion;

		@SuppressWarnings("rawtypes")
		Map enu = request.getParameterMap();
		Map<String,String> camposDinamicos = this.getCamposDinamicos(enu);
		dtoResolucion.setCamposDinamicos(camposDinamicos);

		if(apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).esTipoEspecial(dtoResolucion.getComboTipoResolucionNew(), PCDProcesadoResolucionesController.PREFIJO_RESESPECIALES))
		{
			dtoResolucion.setEstadoResolucion(ESTADO_PROCESADO);
			msvResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).guardarDatos(dtoResolucion);
			dtoResolucion.setIdResolucion(msvResolucion.getId());
			
			String codigoTipoResolucion = msvResolucion.getTipoResolucion().getCodigo();
			
			if(codigoTipoResolucion.equals(PCDProcesadoResolucionesController.CODIGO_SUBIDA_FICHEROS) ||
					codigoTipoResolucion.equals(PCDProcesadoResolucionesController.CODIGO_NOTIFICACION) || 
					codigoTipoResolucion.equals(PCDProcesadoResolucionesController.CODIGO_TAREA) ||
					codigoTipoResolucion.equals(PCDProcesadoResolucionesController.CODIGO_AUTOTAREA))
			{
				apiProxyFactory.proxy(PCDProcesadoResolucionesApi.class).generarTarea(dtoResolucion);
			}

		}
		else{
			dtoResolucion.setEstadoResolucion(ESTADO_GUARDAR);
			msvResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).guardarDatos(dtoResolucion);
		}

		
		//Si no ha metido la tarea creada por la anotación, metemos la tar del tex.
		if(Checks.esNulo(msvResolucion.getTareaNotificacion()))
			msvResolucion.setTareaNotificacion(msvResolucion.getTarea().getTareaPadre());
		
		//Guardamos los datos en el histórico
		apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).guardarDatosHistorico(dtoResolucion, msvResolucion);
		
		model.put("resolucion", msvResolucion);
		
		return JSON_GRABAR_PROCESAR;
	}
	
	
	/**
	 * procesa una resolución
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String procesar(MSVResolucionesDto dtoResolucion, ModelMap model, WebRequest request) throws Exception{
		
		@SuppressWarnings("rawtypes")
		Map enu = request.getParameterMap();
		Map<String,String> camposDinamicos = this.getCamposDinamicos(enu);
		dtoResolucion.setCamposDinamicos(camposDinamicos);
		dtoResolucion.setIdResolucion(this.getIdResolucion(enu));
		
		try{
			pcdProcesadoResolucionesApi.procesar(dtoResolucion);
			//model.put("resolucion", msvResolucion);
		}catch(FrameworkException e){
			model.put("validacion", e.getMessage().substring(e.getMessage().indexOf(':')+1));
			String resultadoProceso = MSVDDEstadoProceso.CODIGO_PTE_VALIDAR;
			dtoResolucion.setEstadoResolucion(resultadoProceso);
			pcdResolucionProcuradorApi.guardarResolucion(dtoResolucion);
			return JSON_GRABAR_PROCESAR_ERROR;
		}catch(Exception e){
			model.put("validacion", e.getMessage().substring(e.getMessage().indexOf(':')+1));
			String resultadoProceso = MSVDDEstadoProceso.CODIGO_PTE_VALIDAR;
			dtoResolucion.setEstadoResolucion(resultadoProceso);
			pcdResolucionProcuradorApi.guardarResolucion(dtoResolucion);
		}
		return JSON_GRABAR_PROCESAR;
	}
	
	
	/**
	 * adjunta el fichero a la resolucion.
	 * @param MSVResolucionesDto
	 * @param model
	 * @return 
	 * @throws Exception 
	 */
	@RequestMapping
	public String adjuntaFicheroResolucion(MSVResolucionesDto dtoResolucion, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).getResolucion(dtoResolucion.getIdResolucion());
		
		//Se sobreescribe el fichero del procurador.
		if(!Checks.esNulo(dtoResolucion.getIdFichero()) && !Checks.esNulo(msvResolucion.getAdjuntoFinal()))
		{
			apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).borrarAdjunto(msvResolucion);
			msvResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).adjuntaFicheroResolucuion(dtoResolucion);
		}else{
			//El gestor adjunta un fichero y no había
			if(!Checks.esNulo(dtoResolucion.getIdFichero()))
			{
				msvResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).adjuntaFicheroResolucuion(dtoResolucion);
			}
		}

		return JSON_GRABAR_PROCESAR;
	}
	
	private Map<String, String> getCamposDinamicos(Map<String,String[]> entrada) {
		Map<String, String> salida = new HashMap<String,String>();
		if(entrada != null && entrada.size() >0){
			for (Map.Entry<String, String[]> entry : entrada.entrySet()) {
			    String key = entry.getKey();
			    if (key.startsWith(PREFIJO_CAMPOS_DINAMICOS)){
			    	salida.put(key, (String)entry.getValue()[0]);
			    }
			}
		}
		return salida;
	}
	
	private Long getIdResolucion(Map<String,String[]> entrada){
		Long salida = null;
		if(entrada != null && entrada.size()>0){
			for (Map.Entry<String, String[]> entry : entrada.entrySet()){
				String key = entry.getKey();
				if(key.equals("idResolucion")){
					salida = Long.parseLong(entry.getValue()[0]);
				}
			}
		}
		return salida;
	}


	/**
	 * guarda los datos de un asunto y lo marca para procesar.
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String cargaResolucion(Long idResolucion, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).getResolucion(idResolucion);
		model.put("resolucion", msvResolucion);
		return JSON_GRABAR_PROCESAR;
	}
	
	/**
	 * Procesa una resolución.
	 * @param model
	 * @return
	 * @throws Exception 
	 */
//	@SuppressWarnings("unchecked")
//	@RequestMapping
//	public String procesarResolucion(Long idResolucion, ModelMap model) throws Exception{
//		
//
//		MSVResolucion msvResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).procesaResolucion(idResolucion);
//		
//		DtoGenericForm dto = this.rellenaDTO(msvResolucion);
//		executor.execute("genericFormManager.saveValues",dto);
//
//		model.put("resolucion", msvResolucion);
//		return JSON_GRABAR_PROCESAR;
//	}





	/**
     * Metodo que devuelve los Asuntos para mostrarlos en el desplegable din�mico del campo asunto.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getAsuntosInstant(Boolean check, String query, ModelMap model) {
    	
    	if(check)
    		model.put("data", apiProxyFactory.proxy(MSVAsuntoAllApi.class).getAsuntos(query));
    	else
    		model.put("data", apiProxyFactory.proxy(MSVAsuntoApi.class).getAsuntos(query));
        
        return JSON_LISTA_ASUNTOS;
    }
    
    
	/**
     * Metodo que devuelve los tipos de resoluci�n disponibles para una tarea dada.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getTiposDeResolucion(Long idTarea, Long idProcedimiento, ModelMap model) {
    	
    	
    	//Obtenemos los tipos de resolución normales
    	Set<MSVTipoResolucionDto> setTiposResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).obtenerTiposResoluciones(idProcedimiento, idTarea);
    	
    	//Ordenamos por descripción del tipo de resolución la lista devuelta
    	List<MSVTipoResolucionDto> listTipoSResolucion = new ArrayList<MSVTipoResolucionDto>(setTiposResolucion);
    	java.util.Collections.sort(listTipoSResolucion);
        
    	//Obtenemos los tipos de resolución especiales. Importante: se le debe indicar el prefijo
    	List<MSVTipoResolucionDto> listTiposEspeciales =  apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).getTiposResolucionesEspeciales(PCDProcesadoResolucionesController.PREFIJO_RESESPECIALES, idTarea);
		
 
    	listTipoSResolucion.addAll(listTiposEspeciales);
    	
    	model.put("data", listTipoSResolucion);
        return JSON_LISTA_TIPOS_RESOLUCION;
          
    }
    
	/**
     * Metodo que devuelve los valores de los campos de las resoluciones anteriores.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
	@RequestMapping
    public String getValoresCamposAntRes( ModelMap model, Long idProcedimiento) {
    
    	Map<String, Map<String, String>> valores = mejGenericFormManager.getValoresTareas(idProcedimiento);
    	
    	List<Map<String, String>> listMap = new ArrayList<Map<String,String>>();

		for (Map.Entry<String, Map<String,String>> entry : valores.entrySet())
		{
			//listMap.add(entry.getValue());
			for (Map.Entry<String, String> cmps : entry.getValue().entrySet())
			{
				//System.out.println(cmps.getKey() + "/" + cmps.getValue());
				Map<String,String> map = new HashMap<String, String>();
				map.put("campo", cmps.getKey());
				map.put("valor", cmps.getValue());
				
				listMap.add(map);
			}
		}

		model.put("data", listMap);
		
    	return JSON_LISTA_VALORES_CAMPOS_RESOLUCION;
    }
    
    
    /**
     * Metodo que comprueba si existen resoluciones pendientes de validar
     * @param idTarea
     * @param idProcedimiento
     * @return 
     */
    @RequestMapping
    public String getExistenResolucionesPendientesValidar(ModelMap model,Long idTarea){
    	
    	List<String> tipoResolucionAccionBaned = new ArrayList<String>();
    	
    	tipoResolucionAccionBaned.add("INFO"); 
    	
    	List<MSVResolucion> resolucionesPTV = pcdResolucionProcuradorApi.getResolucionesPendientesValidar(idTarea, tipoResolucionAccionBaned);
    	
    	if(resolucionesPTV.size() > 0){
    		model.put("tareasPendientesValidar", true);
    	}else{
    		model.put("tareasPendientesValidar", false);
    	}
    	
    	return JSON_EXISTEN_TAREAS_PENDIENTES_VALIDAR;
    }
    
    /**
     * Metodo que devuelve los tipos de requerimientos previos disponibles
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getTiposRequerimiento(ModelMap model){
    	List<MSVDDRequerimientoPrevio> tiposRequerimiento= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(MSVDDRequerimientoPrevio.class);
    	
    	model.put("tiposRequerimiento", tiposRequerimiento);
    	
    	return JSON_LISTA_TIPOS_REQUERIMIENTO;
    }
    
    /**
     * Metodo que devuelve los posibles motivos de inadmision 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getMotivosInadmision(ModelMap model){
    	List<MSVDDMotivoInadmision> motivosInadmision= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(MSVDDMotivoInadmision.class);
    	
    	model.put("motivosInadmision", motivosInadmision);
    	
    	return JSON_LISTA_MOTIVOS_INADMISION;
    }
    
    /**
     * Metodo que devuelve los posibles motivos de suspension de una subasta 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getMotivosSuspension(ModelMap model){
    	List<DDMotivoSuspSubasta> motivosSuspension= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDMotivoSuspSubasta.class);
    	
    	model.put("motivosSuspensionSubasta", motivosSuspension);
    	
    	return JSON_LISTA_MOTIVOS_SUSPENSION;
    }
    
    /**
     * Metodo que devuelve los posibles decisiones de suspension de una subasta 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDecisionSuspension(ModelMap model){
    	List<DDDecisionSuspension> decisionSuspension= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDDecisionSuspension.class);
    	
    	model.put("decisionSuspensionSubasta", decisionSuspension);
    	
    	return JSON_LISTA_DECISION_SUSPENSION;
    }
    
    
    /**
     * Metodo que devuelve las posibles entidades adjudicatorias 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getEntidadesAdjudicatorias(ModelMap model){
    	
    	List<DDEntidadAdjudicataria> entidadAdjudicatoria= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDEntidadAdjudicataria.class);
    	
    	model.put("entidadesAdjudicatorias", entidadAdjudicatoria);
    	
    	return JSON_LISTA_ENTIDADES_ADJUDICATORIAS;
    }
    
    
    /**
     * Metodo que devuelve los posibles motivos de impugnación 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getMotivosImpugnacion(ModelMap model){
    	
    	List<DDImpugnacion1> motivosImpugnacion= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDImpugnacion1.class);
    	
    	model.put("motivosImpugnacion", motivosImpugnacion);
    	
    	return JSON_LISTA_MOTIVOS_IMPUGNACION;
    }
    
    /**
     * Metodo que devuelve los posibles motivos de registro resolución favorables
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getMotivosRegistroResolucionFavorables(ModelMap model){
    	
    	List<DDFavorable> motivosFavorables= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDFavorable.class);
    	
    	model.put("motivosFavorables", motivosFavorables);
    	
    	return JSON_LISTA_MOTIVOS_FAVORABLES;
    }
    
    
    /**
     * Metodo que devuelve los posibles DDCompletitudes
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDDCompletitudes(ModelMap model){
    	
    	List<DDCompletitud> completitudes = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDCompletitud.class);
    	
    	model.put("completitudes", completitudes);
    	
    	return JSON_LISTA_DD_COMPLETITUDES;
    }
    
    /**
     * Metodo que devuelve los posibles DDPositivoNegativo
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDDPositivoNegativo(ModelMap model){
    	
    	List<DDPositivoNegativo> ddPositivoNegativo = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDPositivoNegativo.class);
    	
    	model.put("ddPositivoNegativoList", ddPositivoNegativo);
    	
    	return JSON_LISTA_DD_POSITIVO_NEGATIVO;
    }
    
    
    /**
     * Metodo que devuelve los posibles DDCorrectoCobro
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDDCorrectoCobro(ModelMap model){
    	
    	List<DDCorrectoCobro> ddCorrectoCobro = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDCorrectoCobro.class);
    	
    	model.put("ddCorrectoCobro", ddCorrectoCobro);
    	
    	return JSON_LISTA_DD_CORRECTO_COBRO;
    }
    
    /**
     * Metodo que devuelve los tipos de fondo
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getTiposFondo(ModelMap model){
    	
    	List<DDTipoFondo> tiposFondo = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDTipoFondo.class);
    	
    	model.put("tiposFondo", tiposFondo);
    	
    	return JSON_LISTA_TIPOS_FONDOS;
    }
    
    
    
    /**
     * Metodo que devuelve los posibles motivos de inadmision 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getMotivosArchivo(ModelMap model){
    	List<MSVDDMotivosArchivo> motivosArchivo= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(MSVDDMotivosArchivo.class);
    	
    	model.put("motivosArchivo", motivosArchivo);
    	
    	return JSON_LISTA_MOTIVOS_ARCHIVO;
    }
    
    
    /**
     * Metodo que devuelve los posibles motivos de prórroga
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getMotivosProrroga(ModelMap model){
    	List<CausaProrroga> motivosProrroga= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(CausaProrroga.class);
    	
    	model.put("motivosProrroga", motivosProrroga);
    	
    	return JSON_LISTA_MOTIVOS_PRORROGA;
    }
    
    
    /**
     * Metodo que devuelve los posibles DDCorrectoCobro
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getIndebidaExcesiva(ModelMap model){
    	
    	List<DDIndebidaExcesiva> ddIndebidaExcesiva = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(DDIndebidaExcesiva.class);
    	
    	model.put("listaIndebidas", ddIndebidaExcesiva);
    	
    	return JSON_LISTA_INDEBIDAS;
    }
    
    
    /**
     * Metodo que devuelve las plazas de juzgados 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getPlazas(String codigo,String query, WebRequest request,ModelMap model){
    	

    	if(!Checks.esNulo(query)){
        	
    		BuscaPlazaPaginadoDtoInfo dto = DynamicDtoUtils.create(BuscaPlazaPaginadoDtoInfo.class, request);
        	dto.setSort("descripcion");
    		Page plazas = proxyFactory.proxy(PlazaJuzgadoApi.class).buscarPorDescripcion(dto);
    		model.put("pagina", plazas);
    		
    	}else{
        	
    		PaginationParams pagination = new PaginationParamsImpl();
        	pagination.setLimit(Integer.parseInt(request.getParameter("limit")));
        	pagination.setStart(Integer.parseInt(request.getParameter("start")));
        	pagination.setSort("descripcion");
        	Page plazas = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionarioPage(TipoPlaza.class,pagination,codigo,query);
        	model.put("pagina", plazas);
	
    	}

    	
    	return JSON_LISTA_DICCIONARIO_GENERICO_PAGE;
    }
    
    
//    @SuppressWarnings("unchecked")
//    @RequestMapping
//    public String getPlazas(WebRequest request,ModelMap model){
//    	
//    	BuscaPlazaPaginadoDtoInfo dto = DynamicDtoUtils.create(BuscaPlazaPaginadoDtoInfo.class, request);
//    	
//    	dto.setSort("descripcion");
//    	
//		Page plazas = proxyFactory.proxy(PlazaJuzgadoApi.class).buscarPorDescripcion(dto);
//		model.put("pagina", plazas);
//    	
//    	return JSON_LISTA_DICCIONARIO_GENERICO_PAGE;
//    }
    
    
//    @SuppressWarnings("unchecked")
//    @RequestMapping
//    public String getPlazas(ModelMap model){
//    	
//    	List<TipoPlaza> plazas = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(TipoPlaza.class);
//    	model.put("pagina", plazas);
//    	
//    	return JSON_LISTA_DICCIONARIO_GENERICO_PAGE;
//    }
    
    /**
     * Metodo que devuelve los juzgados que perteneces a una plaza
     * @param codigo de la plaza
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getJuzgadosByPlaza(String codigoPlaza, ModelMap model) {
    	
    	if(!Checks.esNulo(codigoPlaza)){
    		List<TipoJuzgado> juzgados = apiProxyFactory.proxy(PlazaJuzgadoApi.class).buscaJuzgadosPorPlaza(codigoPlaza);
    	    model.put("juzgados", juzgados);	
    	}
        
    	return JSON_LISTA_JUZGADOSPLAZA;
    }
    
    
    /**
     * Metodo que devuelve los los demandados de un asunto
     * @param id de asunto
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDemandadosAsunto(Long idAsunto, ModelMap model) {
    	
    	Asunto asunto=apiProxyFactory.proxy(AsuntoApi.class).get(idAsunto);
    	List<Persona> demandados=asunto.getProcedimientos().get(0).getPersonasAfectadas();
    	
    	model.put("demandados", demandados);
        
    	return JSON_DEMANDADOSASUNTO;
    }
    
    /**
     * Metodo que devuelve los los demandados de un procedimiento
     * @param id de procedimiento
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDemandadosProcedimiento(Long idProcedimiento, ModelMap model) {
    	
    	Procedimiento procedimiento=apiProxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
    	List<Persona> demandados=procedimiento.getPersonasAfectadas();
    	
    	model.put("demandados", demandados);
        
    	return JSON_DEMANDADOSASUNTO;
    }
    
    
    
    /**
     * Metodo que devuelve los los domicilios de un demandado
     * @param id de demandado
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDomiciliosDemandados(Long idDemandado, ModelMap model) {
    	
    	Persona p = apiProxyFactory.proxy(PersonaApi.class).get(idDemandado);
    	List<Direccion> domicilios = p.getDirecciones();
    	model.put("domicilios", domicilios);
        
    	return JSON_DOMICILIOS_DEMANDADO;
    }
    
    /**
     * Metodo que devuelve los los bienes de un demandado
     * @param id de demandado
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getBienesDemandado(Long idDemandado, ModelMap model) {
    	
    	Persona p = apiProxyFactory.proxy(PersonaApi.class).get(idDemandado);
    	List<Bien> bienes=p.getBienes();
    	model.put("bienes", bienes);
        
    	return JSON_BIENES_DEMANDADO;
    }
    
    /**
     * Metodo que devuelve el procedimiento a partir de su id
     * @param idProcedimiento
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getProcedimiento(Long idProcedimiento, ModelMap model){
    	Procedimiento procedimiento=apiProxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
    	List<Procedimiento> procedimientos = new ArrayList<Procedimiento>();
    	procedimientos.add(procedimiento);
    	model.put("procedimientos", procedimientos);
    	return JSON_PROCEDIMIENTO;
    }
    
    /**
     * Metodo que devuelve datos adicionales de un procedimiento a partir de su id
     * @param idProcedimiento
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDatosAdicionales(Long idProcedimiento, ModelMap model){
    	Map<String,RecoveryBPMfwkDatosProcedimiento> mapaDatosPersistidos = apiProxyFactory.proxy(RecoveryBPMfwkDatosProcedimientoApi.class).getDatosPersistidos(idProcedimiento);
    	List<RecoveryBPMfwkDatosProcedimiento> datosPersistidos = new ArrayList<RecoveryBPMfwkDatosProcedimiento>();
    	if (mapaDatosPersistidos.containsKey(CON_TESTIMONIO)){
    		datosPersistidos.add(mapaDatosPersistidos.get(CON_TESTIMONIO));
    	}
    	model.put("datosPersistidos", datosPersistidos);
    	return JSON_DATOS_ADICIONALES;
    }
     
	/**
	 * guarda los datos de un asunto y lo marca para procesar.
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getResolucionByTarea(Long idTareaExterna, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).getResolucionByTarea(idTareaExterna);
		model.put("resolucion", msvResolucion);
		return JSON_GRABAR_PROCESAR;
	}
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String rechazar(MSVResolucionesDto dtoResolucion, ModelMap model, WebRequest request) throws Exception{
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).getResolucion(dtoResolucion.getIdResolucion());

		@SuppressWarnings("rawtypes")
		Map enu = request.getParameterMap();
		Map<String,String> camposDinamicos = this.getCamposDinamicos(enu);
		dtoResolucion.setCamposDinamicos(camposDinamicos);
		dtoResolucion.setAsunto(msvResolucion.getAsunto().getNombre());
		dtoResolucion.setPlaza(msvResolucion.getPlaza());
		dtoResolucion.setIdAsunto(msvResolucion.getAsunto().getId());
		dtoResolucion.setIdProcedimiento(msvResolucion.getProcedimiento().getId());

		dtoResolucion.setEstadoResolucion(ESTADO_RECHAZADO);
		
		//msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).guardarDatos(dtoResolucion); //Guarda el fichero y ya lo tenemos guardado.
		msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).guardarResolucion(dtoResolucion);
		
		if(!Checks.esNulo(msvResolucion.getNombreFichero()))
				apiProxyFactory.proxy(PCDResolucionProcuradorApi.class).borrarAdjunto(msvResolucion);
		
		apiProxyFactory.proxy(PCDProcesadoResolucionesApi.class).generarTarea(dtoResolucion);
		
		model.put("resolucion", msvResolucion);
		
		return JSON_GRABAR_PROCESAR;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String pausar(MSVResolucionesDto dtoResolucion, ModelMap model, WebRequest request) throws Exception{
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).getResolucion(dtoResolucion.getIdResolucion());

		@SuppressWarnings("rawtypes")
		Map enu = request.getParameterMap();
		Map<String,String> camposDinamicos = this.getCamposDinamicos(enu);
		dtoResolucion.setCamposDinamicos(camposDinamicos);
//		dtoResolucion.setAsunto(msvResolucion.getAsunto().getNombre());
//		dtoResolucion.setPlaza(msvResolucion.getPlaza());

		dtoResolucion.setEstadoResolucion(ESTADO_PAUSADO);
		
		//msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).guardarDatos(dtoResolucion); //Guarda el fichero y ya lo tenemos guardado.
		msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).guardarResolucion(dtoResolucion);
		
		
		model.put("resolucion", msvResolucion);
		
		return JSON_GRABAR_PROCESAR;
	}

    @RequestMapping
    public String getDictionary(String dictionary, ModelMap model) throws ClassNotFoundException {

    	List dictionaryData = utilDiccionario.dameValoresDiccionario(Class.forName(dictionary));
		
        model.put("pagina", dictionaryData);

        return JSON_LISTA_DICCIONARIO_GENERICO_LIST;
    }
}
