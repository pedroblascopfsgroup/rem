package es.pfsgroup.plugin.recovery.procuradores.recordatorio.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
		
		if(!Checks.esNulo(dto.getSort())){
			if(dto.getSort().equals("fechaTareaUno")){dto.setSort("rec.tareaUno.fechaVenc");}
			if(dto.getSort().equals("fechaTareaDos")){dto.setSort("rec.tareaDos.fechaVenc");}
			if(dto.getSort().equals("fechaTareaTres")){dto.setSort("rec.tareaTres.fechaVenc");}
		}

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
	 * Método que devuelve cuantas tareas de recordatorios existen.
	 * 
	 * @param 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCountListadoTareasRecordatorios(ModelMap model) {
		model.put("total", proxyFactory.proxy(RECRecordatorioApi.class).getCountListadoTareasRecordatorios());
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreVentanaNuevoRecordatorio( WebRequest request,  ModelMap map){
		
		
		if(!Checks.esNulo(request.getParameter("idRecordatorio"))){
			
			RECRecordatorio rec = proxyFactory.proxy(RECRecordatorioApi.class).getRecRecordatorio(Long.parseLong(request.getParameter("idRecordatorio")));
			map.put("recordatorio", rec);
			
			Calendar calendar = new GregorianCalendar();
			
			///Obtenmos el numero de días de las tareas apartir de la fecha de tarea y la de señalamiento
			
			if(!Checks.esNulo(rec.getTareaUno())){
				
				calendar.setTime(rec.getTareaUno().getFechaVenc());
				int dias = 0;
				
				while(calendar.getTime().before(rec.getFecha())){
					if(calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SATURDAY && calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SUNDAY){
						///Incrementamos días habiles encontrados
						dias ++;
					}
					calendar.add(Calendar.DAY_OF_MONTH, 1);
				}

				map.put("diasTareaUno", dias);
			}
			
			if(!Checks.esNulo(rec.getTareaDos())){
				
				calendar.setTime(rec.getTareaDos().getFechaVenc());
				int dias = 0;
				
				while(calendar.getTime().before(rec.getFecha())){
					if(calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SATURDAY && calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SUNDAY){
						///Incrementamos días habiles encontrados
						dias ++;
					}
					calendar.add(Calendar.DAY_OF_MONTH, 1);
				}
				
				map.put("diasTareaDos", dias);
			}
			
			if(!Checks.esNulo(rec.getTareaTres())){
				
				calendar.setTime(rec.getTareaTres().getFechaVenc());
				int dias = 0;
				
				while(calendar.getTime().before(rec.getFecha())){
					if(calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SATURDAY && calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SUNDAY){
						///Incrementamos días habiles encontrados
						dias ++;
					}
					calendar.add(Calendar.DAY_OF_MONTH, 1);
				}
				map.put("diasTareaTres", dias);
			}
			
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
