package es.pfsgroup.plugin.recovery.mejoras.itinerarios.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.itinerario.DDEstadoItinerarioManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;

@Controller
public class ItinerariosController {
	
	public static final String JSON_TIPOS_ESTADOS_ITINERARIO  = "plugin/mejoras/itinerarios/tiposDeEstadosDelItinerarioJSON";

	
	@Autowired
	DDEstadoItinerarioManager ddEstadoItinerarioManager;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getEstadosExpedientesByTipoItinerario(WebRequest request, ModelMap model){
		
		List<DDEstadoItinerario> tiposEstadosItinerarios= ddEstadoItinerarioManager.getEstadosItiExpedientesByTipoItinerario(request.getParameter("codigoTipoItinerario"));
		model.put("tiposEstadosItinerarios", tiposEstadosItinerarios);
		
		return JSON_TIPOS_ESTADOS_ITINERARIO;
	}	
	
}
