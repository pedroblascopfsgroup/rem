package es.pfsgroup.plugin.recovery.instruccionesExterna.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Controller
public class instruccionesExternaController {

	public static final String JSON_LIST_TIPO_TAREA  ="plugin/instruccionesExterna/tipoTareaJSON";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaTiposTarea(ModelMap model, Long idProcedimiento){
		
		List<TareaProcedimiento> lista =  proxyFactory.proxy(instruccionesExternaApi.class).listaTareasProcedimiento(idProcedimiento);
		model.put("lista", lista);
		
		return JSON_LIST_TIPO_TAREA;
	}
}
