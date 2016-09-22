package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.rest.dto.InformemediadorRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

@Controller
public class InformemediadorController {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RestApi restApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/informemediador")
	public ModelAndView saveInformeMediador(ModelMap model, RestRequestWrapper request){
		model.put("hola", "hola");
		InformemediadorRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		
		try {
			jsonData = (InformemediadorRequestDto) request.getRequestData(InformemediadorRequestDto.class);
			List<InformeMediadorDto> informes = jsonData.getData();

			for (InformeMediadorDto informe : informes) {
				List<String> error = restApi.validateRequestObject(informe,Insert.class);
				for(String e : error){
					System.out.println(e);
				}
				System.out.println(informe.getIdUsuarioRemAccion());
			}
		} catch (Exception  e) {
			logger.error(e);
			model.put("id", jsonData.getId());	
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		}
		
		return new ModelAndView("jsonView", model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/informemediador/dos")
	public ModelAndView saveInformeMediador2(ModelMap model, RestRequestWrapper request){
		model.put("hola", "hola");
		InformemediadorRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		
		try {
			jsonData = (InformemediadorRequestDto) request.getRequestData(InformemediadorRequestDto.class);
			List<InformeMediadorDto> informes = jsonData.getData();

			for (InformeMediadorDto informe : informes) {
				List<String> error = restApi.validateRequestObject(informe,Update.class);
				for(String e : error){
					System.out.println(e);
				}
				System.out.println(informe.getIdUsuarioRemAccion());
			}
		} catch (Exception  e) {
			logger.error(e);
			model.put("id", jsonData.getId());	
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		}
		
		return new ModelAndView("jsonView", model);
		
	}

}
