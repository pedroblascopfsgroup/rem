package es.pfsgroup.plugin.recovery.procuradores.recordatorio.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.procuradores.api.PCDProcesadoRecordatoriosApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.api.RECRecordatorioApi;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dto.RECRecordatorioDto;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.model.RECRecordatorio;

/**
 * @author carlos gil
 *
 * Controlador encargado de atender las peticiones del plugin de procuradores. 
 */
@Controller
public class RECRecordatorioController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	public static final String JSON_LISTA_RECORDATORIOS_JSON = "plugin/procuradores/recordatorio/recordatoriosJSON";
	public static final String JSON_LISTA_TAREAS_RECORDATORIOS_JSON = "plugin/procuradores/recordatorio/listadoTareasRecordatoriosJSON";
	public static final String JSP_VENTANA_NUEVO_RECORDATORIO = "plugin/procuradores/recordatorio/nuevoRecordatorio";
	public static final String JSON_COUNT_LISTADO_RECORDATORIOS = "plugin/procuradores/arbol/countListadoRecordatoriosJSON";
	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link RECRecordatorio}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaRecordatorios(RECRecordatorioDto dto, ModelMap map, WebRequest request){
		
		Page p = proxyFactory.proxy(RECRecordatorioApi.class).getListaRecordatorios(dto);
		map.put("pagina", p);
		return JSON_LISTA_RECORDATORIOS_JSON;
	}
	
	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link TareaNotificacion}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaTareasRecordatorios(RECRecordatorioDto dto, ModelMap map, WebRequest request){
		
		Page p = proxyFactory.proxy(RECRecordatorioApi.class).getListaTareasRecordatorios(dto);
		map.put("pagina", p);
		return JSON_LISTA_TAREAS_RECORDATORIOS_JSON;
	}
	
	
	/**
	 * Método que devuelve cuántos recordatorios existen.
	 * 
	 * @param 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCountListadoRecordatorios(ModelMap model) {
		model.put("total", proxyFactory.proxy(RECRecordatorioApi.class).getCountListadoRecordatorios());
		return JSON_COUNT_LISTADO_RECORDATORIOS;
	}
	
	/**
	 * Guarda {@link RECRecordatorio}
	 * @param request
	 */
	@RequestMapping
	public String saveRecRecordatorio(WebRequest request){
		
		///Guardamos el recordatorio
		RECRecordatorioDto dto = new RECRecordatorioDto();
		
		dto.setTitulo(request.getParameter("titulo"));
		dto.setDescripcion(request.getParameter("descripcion"));
		
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		try {
			Date d =  formatter.parse(request.getParameter("fecha"));
			dto.setFecha(d);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		if(!Checks.esNulo(request.getParameter("categoria"))){
			dto.setCategoria(proxyFactory.proxy(CategoriaApi.class).getCategoria(Long.parseLong(request.getParameter("categoria"))));
		}
		
		Long idRecordatorio = proxyFactory.proxy(RECRecordatorioApi.class).saveRecRecordatorio(dto);
		
		///Guaardamos las tareas del recordatorio
		proxyFactory.proxy(PCDProcesadoRecordatoriosApi.class).crearTareaRecordatorios(idRecordatorio, request.getParameterValues("dias_tarea"));
		
		return "default";
	}
	
	/**
	 * Resuleve el recordatorio {@link RECRecordatorio}
	 * @param request
	 */
	@RequestMapping
	public String resolverRecordatorio(WebRequest request){
		
		proxyFactory.proxy(RECRecordatorioApi.class).resolverRecordatorio(Long.parseLong(request.getParameter("idRecordatorio")));
		
		return "default";
	}
	
	/**
	 * Devuelve la ventana de nuevo RECRecordatorio
	 * @param request
	 * @return JSP del nuevo recordatorio 
	 */
	
	@RequestMapping
	public String abreVentanaNuevoRecordatorio( WebRequest request,  ModelMap map){
		
		if(!Checks.esNulo(request.getParameter("idRecordatorio"))){
			map.put("recordatorio", proxyFactory.proxy(RECRecordatorioApi.class).getRecRecordatorio(Long.parseLong(request.getParameter("idRecordatorio"))));
		}
		
		return JSP_VENTANA_NUEVO_RECORDATORIO;
	}
	
	/**
	 * Guarda {@link RECRecordatorio}
	 * @param request
	 */
	@RequestMapping
	public String resolverTareaRecRecordatorio(WebRequest request){
		
		///Cerramos el recordatorio
		if(!Checks.esNulo(request.getParameter("idTarea")) && !Checks.esNulo(request.getParameter("tareaCerrada"))){
			proxyFactory.proxy(RECRecordatorioApi.class).resolverTareaRecRecordatorio(Integer.parseInt(request.getParameter("idTarea")));	
		}
		
		return "default";

	}

}
