package es.pfsgroup.plugin.recovery.config.delegaciones.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DelegacionTareasController {

	

	private static final String VIEW_CREAR_DELEGACION_TAREA = "plugin/config/delegacionTareas/delegacionTareas";
	private static final String VIEW_DEFAULT = "default";

    
	@RequestMapping
	public String nuevaDelegacion(ModelMap map) {

		return VIEW_CREAR_DELEGACION_TAREA;
	}
	
	@RequestMapping
	public String crearDelegacion(ModelMap map) {

		return VIEW_DEFAULT;
	}
	
}
