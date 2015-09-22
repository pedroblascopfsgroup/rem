package es.pfsgroup.plugin.recovery.procuradores.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.tareas.api.PCDProcuradoresApi;
import es.pfsgroup.plugin.recovery.procuradores.tareas.dto.PCDProcuradoresDto;

/**
 * @author manuel
 *
 * Controlador encargado de atender las peticiones del plugin de procuradores. 
 */
@Controller
public class ProcuradoresController {
	
	private static final String GET_LISTADO_TAREAS_PENDIENTES_VALIDAR_JSON = "plugin/procuradores/tareas/listadoTareasPendientesJSON";

	private static final String GET_PANEL_LISTADO_TAB_TAREAS_PENDIENTES = "plugin/procuradores/tareas/listadoTareasPendientes";

	private static final String JSON_COUNT_LISTADO_TAREAS_PENDIENTES = "plugin/procuradores/arbol/countListadoTareasPendientesJSON";

	public static final String JSP_DOWNLOAD_FILE = "plugin/procuradores/adjuntos/download";
	
	private static final String GET_PANEL_LISTADO_RECORDATORIOS = "plugin/procuradores/tareas/listadoRecordatorios";

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private CategoriaApi categoriaApi;
	/**
	 * Método que devuelve la pestaña de tareas pendientes de validar.
	 * 
	 * @param dto
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String getPanelListadoTareasPendientes(WebRequest request, ModelMap model) {

		if (!Checks.esNulo(request.getParameter("idCategoria"))) {
			model.put("idCategoria", Long.valueOf(request.getParameter("idCategoria")));		
		}
		
		model.put("pausadas", false);
		if(!Checks.esNulo(request.getParameter("pausadas"))){
			model.put("pausadas", true);	
		}
		
		return GET_PANEL_LISTADO_TAB_TAREAS_PENDIENTES;
	}
	
	/**
	 * Método que devuelve cuántas tareas pendientes de validar quedan.
	 * 
	 * @param 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCountListadoTareasPendientes(Long idUsuario, ModelMap model) {
		model.put("total", proxyFactory.proxy(PCDProcuradoresApi.class).getCountListadoTareasPendientes(idUsuario));
		return JSON_COUNT_LISTADO_TAREAS_PENDIENTES;
	}
	
	/**
	 * Método que devuelve el listado de tareas pendientes de validar.
	 * 
	 * @param 
	 * @param model
	 * @param idUsario 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoTareasPendientesValidar(PCDProcuradoresDto dto, ModelMap model) {

		model.put("pagina", proxyFactory.proxy(PCDProcuradoresApi.class).getListadoTareasPendientesValidar(dto));

		return GET_LISTADO_TAREAS_PENDIENTES_VALIDAR_JSON;
	}
	
	
	/**
	 * Método que devuelve el listado de tareas pendientes de validar y pausadas.
	 * 
	 * @param 
	 * @param model
	 * @param idUsario 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoTareasPendientesValidarPausadas(PCDProcuradoresDto dto, ModelMap model) {

		model.put("pagina", proxyFactory.proxy(PCDProcuradoresApi.class).getListadoTareasPendientesValidarPausadas(dto));

		return GET_LISTADO_TAREAS_PENDIENTES_VALIDAR_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String descargarAdjunto(Long idResolucion, ModelMap model) throws Exception{
		
		MSVResolucion resolucion = proxyFactory.proxy(MSVResolucionApi.class).getResolucion(idResolucion);
		FileItem fileItem = resolucion.getContenidoFichero();
		fileItem.setFileName(resolucion.getNombreFichero());
		model.put("fileItem", fileItem);
		
		/*
		if (id != null && tipo != null){
			String bo = this.getBO(tipo);
			if (bo != null){
				FileItem fileItem = (FileItem) executor.execute(bo, id);
				model.put("fileItem", fileItem);
			}
			else return null;
		
		}
		*/
		
		return JSP_DOWNLOAD_FILE;
	}
	
	
	/**
	 * Método que devuelve la pestaña de recordatorios.
	 * 
	 * @param dto
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String getPanelListadoRecordatorios(WebRequest request, ModelMap model) {

//		if (!Checks.esNulo(request.getParameter("idCategoria"))) {
//			model.put("idCategoria", Long.valueOf(request.getParameter("idCategoria")));		
//		}
//		
//		model.put("pausadas", false);
//		if(!Checks.esNulo(request.getParameter("pausadas"))){
//			model.put("pausadas", true);	
//		}
		
		return GET_PANEL_LISTADO_RECORDATORIOS;
	}

}
