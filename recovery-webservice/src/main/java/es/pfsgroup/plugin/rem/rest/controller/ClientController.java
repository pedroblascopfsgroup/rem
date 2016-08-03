package es.pfsgroup.plugin.rem.rest.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ClientController {
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method =RequestMethod.GET,value="get")
	public ModelAndView client(ModelMap model){
		
		model.put("data", "hola monnnn");
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method =RequestMethod.GET,value="/rest/client/juanito")
	public ModelAndView client2(ModelMap model){
		
		model.put("data", "hola monnnn!!!!!!!!!!!");
		return new ModelAndView("jsonView", model);
	}

}
