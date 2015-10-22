package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ListadoPreProyectadoController {

	static final String BUSQUEDA_PREPROYECTADO = "plugin/expediente/listadoPreProyectado/busqueda/preProyectado";
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirBusqueda(ModelMap model) {

//		model.put("id", id);
		return BUSQUEDA_PREPROYECTADO;
	}

}
