package es.pfsgroup.plugin.rem.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.rest.dto.RequestVisitaDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class VisitasController {

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/visitas")
	public ModelAndView insertUpdateVisita(ModelMap model, RestRequestWrapper request) {
		try {

			RequestVisitaDto jsonData = (RequestVisitaDto) request.getRequestData(RequestVisitaDto.class);
			
			for(int i=0; i<jsonData.getData().size();i++){
				System.out.println("---------------------------------------------------");
				System.out.println(jsonData.getData().get(i).getIdClienteRem());
				System.out.println(jsonData.getData().get(i).getIdVisitaWebcom());
			}
			

			model.put("id", jsonData.getId());
			model.put("data", "hola mon update");
		} catch (Exception e) {
			model.put("data", e);
		}

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET, value = "/visitas")
	public ModelAndView getVisita(ModelMap model, RestRequestWrapper request) {
		try {

			RequestVisitaDto jsonData = (RequestVisitaDto) request.getRequestData(RequestVisitaDto.class);
			
			
			model.put("id", jsonData.getId());
			model.put("data", "hola mon get");
		} catch (Exception e) {
			model.put("data", e);
		}

		return new ModelAndView("jsonView", model);
	}

}
