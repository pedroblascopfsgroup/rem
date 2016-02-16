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
	
	@RequestMapping
	public String getListadoSintomaticos(WebRequest request, ModelMap model) {
		return "gestionClientes/listadoSintomaticos";
	}
	
	@RequestMapping
	public String getListadoSistematicos(WebRequest request, ModelMap model) {
		return "gestionClientes/listadoSistematicos";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDatosVencidos(GestionClientesBusquedaDTO dto, ModelMap model) {
		
		Page vencidos = manager.getDatosVencidos(dto);
				
		model.put("pagina", vencidos);
		return "gestionClientes/gestionClientesJSON";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDatosSeguimientoSistematico(GestionClientesBusquedaDTO dto, ModelMap model) {
		
		Page vencidos = manager.getDatosSeguimientoSistematico(dto);
				
		model.put("pagina", vencidos);
		return "gestionClientes/gestionClientesJSON";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDatosSeguimientoSintomatico(GestionClientesBusquedaDTO dto, ModelMap model) {
		
		Page vencidos = manager.getDatosSeguimientoSintomatico(dto);
				
		model.put("pagina", vencidos);
		return "gestionClientes/gestionClientesJSON";
	}
}
