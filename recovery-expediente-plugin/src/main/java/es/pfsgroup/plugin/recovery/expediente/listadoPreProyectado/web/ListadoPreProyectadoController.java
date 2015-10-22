package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ListadoPreProyectadoController {

	static final String LISTADO_PREPROYECTADO = "plugin/expediente/listadoPreProyectado/listadoPreProyectado";
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirListado(ModelMap model) {

//		model.put("id", id);
		return LISTADO_PREPROYECTADO;
	}

}
