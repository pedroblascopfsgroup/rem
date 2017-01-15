package es.pfsgroup.plugin.gestorDocumental.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;

@Controller
@RequestMapping("/gdtest")
public class GestorDocumentalTestController {
	
	
	@Autowired
	private GestorDocumentalExpedientesApi gestorDocumentalExpedientesApi;
	
	@Autowired
	private GestorDocumentalApi gestorDocumentalApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearGasto(CrearGastoDto crearGastoDto, ModelMap model) {
		
		try {
			
			RespuestaCrearExpediente respuesta = gestorDocumentalExpedientesApi.crearGasto(crearGastoDto);
			
			model.put("Respuesta", respuesta);
			
		} catch (GestorDocumentalException e) {
			model.put("Exception", e);
		}
		
		return new ModelAndView("jsonView", model);

	}

}
