package es.pfsgroup.recovery.gestionClientes;

import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

@Controller
public class GestionClientesController {
	
	@RequestMapping
	public String getContadores(WebRequest request, ModelMap model ){
		ArrayList<GestionClientesCountDTO> tareas = new ArrayList<GestionClientesCountDTO>();
		GestionClientesCountDTO dto = new GestionClientesCountDTO();
		dto.setDescripcion("Gestion de Vencidos");
		dto.setDescripcion("Clientes a gestionar vencidos: 38017");
		dto.setSubtipo("Gestión Previa");
		dto.setCodigoSubtipoTarea("1");
		dto.setDtype("TareaNotificacion");
		
		model.put("tareas", tareas);
		return "gestionClientes/gestionClientesCountJSON";
	}

}
