package es.pfsgroup.recovery.gestionClientes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.plugin.recovery.mejoras.cliente.dto.MEJBuscarClientesDto;

@Controller
public class GestionClientesController {
	
	@Autowired
	private GestionClientesManager manager;
	
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
	public String getVencidos(WebRequest request, ModelMap model) {
		
		MEJBuscarClientesDto clientesDto = new MEJBuscarClientesDto();
		
		return "gestionClientes/gestionVencidosJSON";
	}
}
