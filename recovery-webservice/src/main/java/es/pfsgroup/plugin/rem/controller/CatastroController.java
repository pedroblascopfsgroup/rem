package es.pfsgroup.plugin.rem.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.api.CatastroApi;

@Controller
public class CatastroController {

	@Autowired
	private CatastroApi catastroApi;
	
	private static final String RESPONSE_DATA_KEY = "data";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListRefCatastralActivo(Long idActivo, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, catastroApi.getComboReferenciaCatastralByidActivo(idActivo));

		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getReferenciaCatastralGrid(Long idActivo, ModelMap model) {
		
		model.put(RESPONSE_DATA_KEY, catastroApi.getGridReferenciaCatastralByidActivo(idActivo));
		
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComparativaReferenciaCatastralGrid(Long idActivo,String refCatastral, ModelMap model) {
		
		model.put(RESPONSE_DATA_KEY, catastroApi.getGridReferenciaCatastralByRefCatastral(refCatastral, idActivo));
		
		return new ModelAndView("jsonView", model);
	}
	

}
