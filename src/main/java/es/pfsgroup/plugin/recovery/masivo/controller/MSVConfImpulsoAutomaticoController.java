package es.pfsgroup.plugin.recovery.masivo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.api.MSVConfImpulsoAutomaticoApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVConfImpulsoAutomaticoBusquedaDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVConfImpulsoAutomaticoDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;

@Controller
public class MSVConfImpulsoAutomaticoController {
	
	public static final String JSP_VENTANA_GESTION_CONF_IMPULSO = "plugin/masivo/confImpulso/gestionConfImpulso";
	public static final String JSON_BUSQUEDA_CONF_IMPULSO = "plugin/masivo/confImpulso/listaConfImpulsoJSON";
	public static final String JSP_VENTANA_ALTA_CONF_IMPULSO = "plugin/masivo/confImpulso/altaConfImpulso";
	public static final String JSP_VENTANA_CONSULTA_CONF_IMPULSO = "plugin/masivo/confImpulso/altaConfImpulso";

	public static final String JSON_LIST_TIPO_TAREA  ="plugin/masivo/confImpulso/tipoTareaJSON";

	@Autowired
	private MSVConfImpulsoAutomaticoApi impulsoManager;

	/**
	 * Muestra la ventana de gestion de impulsos automáticos
	 * 
	 * Debe cargar los tipos de juicios y los despachos existentes
	 * 
	 * Y las carteras (modificación posterior)
	 * 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreVentana(ModelMap model) {

		List<MSVDDTipoJuicio> tiposJuicio = impulsoManager.buscaTipoJuicios();
		model.put("tiposJuicio", tiposJuicio);
		
		List<DespachoExterno> despachos = impulsoManager.buscaDespachos();
		model.put("despachos", despachos);
		
		List<String> carteras = impulsoManager.buscaCarteras();
		model.put("carteras", carteras);
		
		return JSP_VENTANA_GESTION_CONF_IMPULSO;
	}

	/**
	 * Consulta los tipos de tareas del procedimiento asociado 
	 * al tipo de juicio seleccionado
	 * 
	 * @param idTipoJuicio
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String consultaTareasProcedimiento(Long idTipoJuicio, ModelMap model) {

		List<TareaProcedimiento> tareasProcedimiento = impulsoManager.buscaTareasProcedimiento(idTipoJuicio);
		model.put("tareasProcedimiento", tareasProcedimiento);
		
		return JSON_LIST_TIPO_TAREA;
	}

	/**
	 * Envia el JSON con los datos de los impulsos procesales para rellenar el grid
	 * 
	 * @param dtoBusqueda
	 * @param request
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String buscaConfImpulso(MSVConfImpulsoAutomaticoBusquedaDto dtoBusqueda,
			WebRequest request, ModelMap model) {
		Page pageImpulsoConf = impulsoManager.buscaConfImpulsos(dtoBusqueda);
		model.put("impulsos", pageImpulsoConf);
		return JSON_BUSQUEDA_CONF_IMPULSO;
	}

	/**
	 * Muestra la venta para dar de alta o modificar la configuracion de
	 * impulso automático
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String altaConfImpulso(WebRequest request, ModelMap model) {
		
		if (!Checks.esNulo(request.getParameter("id"))) {
			Long id = Long.valueOf(request.getParameter("id"));
			model.put("confImpulso", impulsoManager.getConfImpulsoPorId(id));
		}

		List<MSVDDTipoJuicio> tiposJuicio = impulsoManager.buscaTipoJuicios();
		model.put("tiposJuicio", tiposJuicio);
		
		List<DespachoExterno> despachos = impulsoManager.buscaDespachos();
		model.put("despachos", despachos);

		List<String> carteras = impulsoManager.buscaCarteras();
		model.put("carteras", carteras);

		return JSP_VENTANA_ALTA_CONF_IMPULSO;
	}

	/**
	 * Muestra la ventana de consultar los datos de una configuración de impulso
	 * automático
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String consultaConfImpulso(WebRequest request, ModelMap model) {
		
		List<MSVDDTipoJuicio> tiposJuicio = impulsoManager.buscaTipoJuicios();
		model.put("tiposJuicio", tiposJuicio);
		
		List<DespachoExterno> despachos = impulsoManager.buscaDespachos();
		model.put("despachos", despachos);

		List<String> carteras = impulsoManager.buscaCarteras();
		model.put("carteras", carteras);

		Long id = Long.valueOf(request.getParameter("id"));
		model.put("confImpulso", impulsoManager.getConfImpulsoPorId(id));
		
		return JSP_VENTANA_CONSULTA_CONF_IMPULSO;
		
	}

	/**
	 * Guarda los datos de una configuración de impulso automático
	 * 
	 * @param request
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String guardaConfImpulso(MSVConfImpulsoAutomaticoDto dto, WebRequest request,
			ModelMap model) throws Exception {
		impulsoManager.guardarConfImpulso(dto);
		model.put("confImpulsos.totalCount", 0);
		return JSON_BUSQUEDA_CONF_IMPULSO;

	}

	/**
	 * Borra la configuración de impulso automático
	 * 
	 * @param request
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping
	public String borraConfImpulso(WebRequest request, ModelMap model)
			throws Exception {
		Long id = Long.valueOf(request.getParameter("id"));
		impulsoManager.borrarConfImpulso(id);
		return JSON_BUSQUEDA_CONF_IMPULSO;
	}
}
