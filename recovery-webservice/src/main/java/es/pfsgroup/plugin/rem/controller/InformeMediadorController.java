package es.pfsgroup.plugin.rem.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class InformeMediadorController {
	
	@RequestMapping(method = RequestMethod.POST, value = "/informeMediador")
	public ModelAndView saveInformeMediador(ModelMap model, RestRequestWrapper request){
		model.put("hola", "hola");
		return new ModelAndView("jsonView", model);
		
	}

}
