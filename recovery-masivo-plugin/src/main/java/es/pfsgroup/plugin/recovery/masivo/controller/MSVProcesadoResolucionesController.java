package es.pfsgroup.plugin.recovery.masivo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVAsuntoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDMotivoInadmision;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDMotivosArchivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDRequerimientoPrevio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.MSVResolucionInputApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.recovery.api.TareaExternaApi;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.datosprc.model.RecoveryBPMfwkDatosProcedimiento;

/**
 * @author manuel
 *
 * Controlador encargado de atender las peticiones de la pantalla de Procesado de resoluciones. 
 */
@Controller
public class MSVProcesadoResolucionesController {
	
	private static final String CON_TESTIMONIO = "conTestimonio";

	private static final String PREFIJO_CAMPOS_DINAMICOS = "d_";

	public static final String JSP_ABRIR_PANTALLA = "plugin/masivo/procesadoResoluciones";

	public static final String JSON_COMPROBAR_ASUNTO = "";

	public static final String JSON_AYUDA = "plugin/masivo/datosAyudaResolucionJSON";

	public static final String JSON_MOSTRAR_PROCESOS_RESOLUCION = "plugin/masivo/datosProcesosResolucionJSON";
	
	public static final String JSON_MOSTRAR_PROCESOS_RESOLUCION_PAGINATED = "plugin/masivo/datosProcesosResolucionPaginatedJSON";

	public static final String JSON_DIBUJRA_DATOS_DINAMICOS = "";

	public static final String JSON_ADJUNTAR_FICHERO = "";

	public static final String JSON_GRABAR_PROCESAR = "plugin/masivo/datosResolucionJSON";

	public static final String JSON_LISTA_ASUNTOS = "plugin/masivo/listaAsuntosJSON";

	public static final String JSP_VENTANA_RESOLUCION_DESDE_TAREA = "plugin/masivo/ventanaResolucionDesdeTarea";
	
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
	
	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	

	/**
	 * Muestra la pantalla de procesado de resoluciones.
	 * @param model
	 * @return ruta del jsp a mostrar
	 * 
	 */
	@RequestMapping
	public String abrirPantalla(ModelMap model){
		
//		List<MSVDDTipoJuicio> tiposJuicio =apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(MSVDDTipoJuicio.class);
//		model.put("tiposJuicio", tiposJuicio);
//		
//		List<MSVDDTipoResolucion> tiposResolucion = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(MSVDDTipoResolucion.class);
//		model.put("tiposResolucion", tiposResolucion);
		
		return JSP_ABRIR_PANTALLA;
	}
	

	/**
	 * Comprueba si existe un asunto.
	 * 
	 * @param model
	 * @return json con informaciï¿½n sobre el asunto.
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
		 Page listaProcesosResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).mostrarResoluciones(dto);
		 
		 model.put("data", listaProcesosResolucion);
		 
		
		return JSON_MOSTRAR_PROCESOS_RESOLUCION_PAGINATED;
	}
	

	/**
	 * obtiene los datos dinámicos que hay que mostrar en la pantalla en función de la resolución.
	 * @param model
	 * @return json con información sobre los datos a mostrar.
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
		
		String html = apiProxyFactory.proxy(MSVResolucionApi.class).dameAyuda(idTipoResolucion);
		
		model.put("html", html);
		
		return JSON_AYUDA;
	}
	
	/**
	 * Devuleve un jsp que dibujarï¿½ el formulario dinï¿½mico dependiendo del tipo de resoluciï¿½n que se le pase
	 * en el futuro el formulario a dibujar se elegirï¿½ en base al tipo de procedimiento y de tarea, 
	 * ahora se hace mediante javascript
	 * ESTE MÉTODO HA PASADO AL PLUGIN DE LINDORFF
	 * @param model
	 * @return ruta del jsp a mostrar
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	@Deprecated
	public String abreFormularioDinamicoDesdeProcedimiento(Long idTipoResolucion,Long idProcedimiento, Long idTarea, ModelMap model){
		
		String html = apiProxyFactory.proxy(MSVResolucionApi.class).dameAyuda(idTipoResolucion);
		
		model.put("html", html);
		model.put("idTipoResolucion", idTipoResolucion);
		
		return JSP_VENTANA_RESOLUCION_DESDE_TAREA;
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
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String grabarYProcesar(MSVResolucionesDto dtoResolucion, ModelMap model, WebRequest request){
		
		@SuppressWarnings("rawtypes")
		Map enu = request.getParameterMap();
		Map<String,String> camposDinamicos = this.getCamposDinamicos(enu);
		dtoResolucion.setCamposDinamicos(camposDinamicos);
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).guardarDatos(dtoResolucion);
		
		model.put("resolucion", msvResolucion);
		
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


	/**
	 * guarda los datos de un asunto y lo marca para procesar.
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String cargaResolucion(Long idResolucion, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).getResolucion(idResolucion);
		model.put("resolucion", msvResolucion);
		return JSON_GRABAR_PROCESAR;
	}
	
	/**
	 * Procesa una resoluciï¿½n.
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String procesarResolucion(Long idResolucion, ModelMap model) throws Exception{
		
		MSVResolucion msvResolucion = apiProxyFactory.proxy(MSVResolucionApi.class).procesaResolucion(idResolucion);
		model.put("resolucion", msvResolucion);
		return JSON_GRABAR_PROCESAR;
	}

	/**
     * Metodo que devuelve los Asuntos para mostrarlos en el desplegable dinï¿½mico del campo asunto.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getAsuntosInstant(String query, ModelMap model) {
    	
        model.put("data", apiProxyFactory.proxy(MSVAsuntoApi.class).getAsuntos(query));
       
        
        return JSON_LISTA_ASUNTOS;
    }
    
	/**
     * Metodo que devuelve los tipos de resolución disponibles para una tarea dada.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getTiposDeResolucion(Long idTarea, Long idProcedimiento, ModelMap model) {

    	// obtenemos la tarea activa que tiene el procedimiento en este momento, porque si cogemos la tarea que se pasa por parámetro
    		// a veces no está avanzado el procedimiento y se le pasa la tarea anterior y no muestra bien el combo
    	
    	List<TareaExterna> tareasExternas = apiProxyFactory.proxy(TareaExternaApi.class).getActivasByIdProcedimiento(idProcedimiento);
    	
    	if (!Checks.esNulo(tareasExternas) && !Checks.estaVacio(tareasExternas)){
    		idTarea = tareasExternas.get(0).getId();
    	} else {
    		idTarea=null;
    	}
    	
    	//Si no tiene tareas activas obtiene los tipos de resolución a partir del idProcedimiento
    	Set<MSVTipoResolucionDto> setTiposResolucion = (Checks.esNulo(idTarea)) 
    			? apiProxyFactory.proxy(MSVResolucionInputApi.class).obtenerTiposResolucionesSinTarea(idProcedimiento)
    			: apiProxyFactory.proxy(MSVResolucionInputApi.class).obtenerTiposResolucionesTareas(idTarea);
    	
    	//Ordenamos por descripción del tipo de resolución la lista devuelta
    	List<MSVTipoResolucionDto> listTipoSResolucion = new ArrayList<MSVTipoResolucionDto>(setTiposResolucion);
    	java.util.Collections.sort(listTipoSResolucion);
        
    	model.put("data", listTipoSResolucion);
        return JSON_LISTA_TIPOS_RESOLUCION;
          
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
     * Metodo que devuelve las plazas de juzgados 
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getPlazas(ModelMap model){
    	List<TipoPlaza> plazas= apiProxyFactory.proxy(MSVDiccionarioApi.class).dameValoresDiccionario(TipoPlaza.class);
    	
    	model.put("plazas", plazas);
    	
    	return JSON_LISTA_PLAZAS;
    }
    
    /**
     * Metodo que devuelve los juzgados que perteneces a una plaza
     * @param codigo de la plaza
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getJuzgadosByPlaza(String codigoPlaza, ModelMap model) {
    	
    	List<TipoJuzgado> juzgados = apiProxyFactory.proxy(PlazaJuzgadoApi.class).buscaJuzgadosPorPlaza(codigoPlaza);
       
    	model.put("juzgados", juzgados);
        
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
     
    
}
