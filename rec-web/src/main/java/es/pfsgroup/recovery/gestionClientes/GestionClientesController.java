package es.pfsgroup.recovery.gestionClientes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;

@Controller
public class GestionClientesController {
	
	@Autowired
	private GestionClientesManager manager;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getContadores(WebRequest request, ModelMap model ){
		List<GestionClientesCountDTO> tareas = manager.getContadoresGestionVencidos();
		
		model.put("count", tareas.size());
		model.put("tareas", tareas);
		return "gestionClientes/gestionClientesCountJSON";
	}
	
	@RequestMapping
	public String getListadoGestionClientes(WebRequest request, ModelMap model){
		return "gestionClientes/listadoGestionClientes";
	}

	@RequestMapping
	public String getListadoVencidos(WebRequest request, ModelMap model) {
		return "gestionClientes/listadoVencidos";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoSintomaticos(WebRequest request, ModelMap model) {
		//TODO
		return null;
	}
	
	@RequestMapping
	public String getListadoSistematicos(WebRequest request, ModelMap model) {
		//TODO
		return null;
	}
	
	@RequestMapping
	public String getDatosVencidos(WebRequest request, ModelMap model) {
		
		Page vencidos = manager.getDatosVencidos();
				
		model.put("pagina", vencidos);
		return "gestionClientes/gestionVencidosJSON";
	}
}
