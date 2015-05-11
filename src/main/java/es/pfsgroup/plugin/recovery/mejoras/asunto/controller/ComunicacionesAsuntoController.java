package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Controller
public class ComunicacionesAsuntoController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String exportarComunicaciones(@RequestParam(value = "id", required = true) Long id, ModelMap map) {
				
		//List<TareaNotificacion> comunicaciones = proxyFactory.proxy(TareaNotificacionApi.class).getListComunicacionesAsunto(id);
		//map.put("comunicaciones", comunicaciones);
		
		return "reportPDF/plugin/mejoras/asuntos/listadoComunicacionesAsunto";
	}
	

}
