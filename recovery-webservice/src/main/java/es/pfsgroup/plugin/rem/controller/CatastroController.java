package es.pfsgroup.plugin.rem.controller;

import java.util.Arrays;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.api.CatastroApi;

@Controller
public class CatastroController extends ParadiseJsonController {

	@Autowired
	private CatastroApi catastroApi;
	
	protected static final Log logger = LogFactory.getLog(CatastroController.class);

	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";

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

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCatastro(Long idActivo, String refCatastral, ModelMap model){
		try{
			
			model.put("datosRem", catastroApi.getDatosCatastroRem(idActivo));
			model.put("datosCatastro", catastroApi.getDatosCatastroWs(idActivo)); //TODO se tendrá que pasar la referencia catastral
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView eliminarCatastro(Long id, ModelMap model){
		try{
			catastroApi.eliminarCatastro(id);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView saveCatastro(Long idActivo, String[] arrayReferencias , ModelMap model){
		try{
			catastroApi.saveCatastro(idActivo, Arrays.asList(arrayReferencias));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView updateCatastro(Long idActivo, String referenciaAnterior, String nuevaReferencia, ModelMap model){
		try{
			catastroApi.updateCatastro( idActivo,  referenciaAnterior,  nuevaReferencia);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}
		return createModelAndViewJson(model);
	}
}
