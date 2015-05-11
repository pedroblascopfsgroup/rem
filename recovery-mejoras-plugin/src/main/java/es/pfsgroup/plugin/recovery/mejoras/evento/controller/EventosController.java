package es.pfsgroup.plugin.recovery.mejoras.evento.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.evento.EventoAbrirDetalleHandler;
import es.pfsgroup.recovery.api.EventoApi;

@Controller
public class EventosController {
	
	private static final String DEFAULT_ABRE_DETALLE_JSP = "tareas/consultaNotificacion";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired(required = false)
	private List<EventoAbrirDetalleHandler> handlers;
	
	@RequestMapping
	public String getListadoHistoricoEventos(Long idEntidad, String tipoEntidad, ModelMap model){
		List<Evento> lista = proxyFactory.proxy(EventoApi.class).getHistoricoEventos(tipoEntidad, idEntidad);
		model.put("eventos", lista);
		return "plugin/mejoras/historicos/MEJhistoricoEventosJSON";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreDetalleEvento(ModelMap model, WebRequest request) {
		
		if (Checks.estaVacio(handlers)) {
			return getDefaultOpenHistoryView(model, request);
		}else{
			String idTarea = request.getParameter("idTarea");
			String idTraza = request.getParameter("idTraza");
			String idEntidad = request.getParameter("idEntidad");
			EventoAbrirDetalleHandler handler = buscaHandler(idTarea);
			if (handler != null) {
				try{
					Object o = handler.getViewData(Long.parseLong(idTarea), Long.parseLong(idTraza), Long.parseLong(idEntidad));
					model.put("data",o);
					
					if(o instanceof HashMap<?,?>){
						HashMap<String,Object> params = (HashMap<String,Object>)o;
						for(String key:params.keySet()){
							
							model.put(key,params.get(key));
						}
					}
					return handler.getJspName();
				}catch(Exception e){e.printStackTrace();};
			}else {
				return getDefaultOpenHistoryView(model, request);
			}
		
		}
		
		return getDefaultOpenHistoryView(model, request);
	}
	
	@SuppressWarnings("unchecked")
	private String getDefaultOpenHistoryView(ModelMap model, WebRequest request) {

		String idEntidad = request.getParameter("idEntidad");
		String codigoTipoEntidad = request.getParameter("codigoTipoEntidad");
		String descripcion = request.getParameter("descripcion");
		String fecha = request.getParameter("fecha");
		String situacion = request.getParameter("situacion");
		String descripcionTareaAsociada = request.getParameter("descripcionTareaAsociada");
		String idTareaAsociada = request.getParameter("idTareaAsociada");
		String idTarea = request.getParameter("idTarea");
		String tipoTarea = request.getParameter("tipoTarea");
		boolean readOnly = true;
		
		model.put("idEntidad",idEntidad );
		model.put("codigoTipoEntidad",codigoTipoEntidad);
		model.put("descripcion",descripcion);
		model.put("fecha",fecha);
		model.put("situacion",situacion);
		model.put("descripcionTareaAsociada",descripcionTareaAsociada);
		model.put("idTareaAsociada",idTareaAsociada);
		model.put("idTarea",idTarea);
		model.put("tipoTarea",tipoTarea);
		model.put("readOnly",readOnly);
		return DEFAULT_ABRE_DETALLE_JSP;
	}
	
	private EventoAbrirDetalleHandler buscaHandler(String idTarea) {
		
		EXTTareaNotificacion tarea = (EXTTareaNotificacion) proxyFactory.proxy(TareaNotificacionApi.class).get(Long.parseLong(idTarea));
		String tipoTarea = tarea.getSubtipoTarea().getCodigoSubtarea();
		String codUg = null;
		
		if(tarea.getExpediente() != null)
			codUg = DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE;
		else if(tarea.getCliente() != null)
			codUg = DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE;
		else if(tarea.getPersona() != null)
			codUg = "9";
		for (EventoAbrirDetalleHandler h : handlers) {
			if (h.isValid(tipoTarea,codUg)) {
				return h;
			}
		}
		return null;
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}
}
