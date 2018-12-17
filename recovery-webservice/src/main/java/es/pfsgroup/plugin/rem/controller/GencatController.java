package es.pfsgroup.plugin.rem.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.api.GencatApi;

@Controller
public class GencatController {
	
	protected static final Log logger = LogFactory.getLog(GencatController.class);
	
	@Autowired
	private GencatApi gencatApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDetalleGencatByIdActivo(Long id, ModelMap model) {

		try {
			model.put("data", gencatApi.getDetalleGencatByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getOfertasAsociadasByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getOfertasAsociadasByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getReclamacionesByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getReclamacionesByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getAdjuntosActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoComunicacionesByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getHistoricoComunicacionesByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDetalleHistoricoByIdComunicacionHistorico(Long id, Long idHComunicacion, ModelMap model) {

		try {
			model.put("data", gencatApi.getDetalleHistoricoByIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoOfertasAsociadasIdComunicacionHistorico(Long idHComunicacion, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getHistoricoOfertasAsociadasIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoReclamacionesByIdComunicacionHistorico(Long idHComunicacion, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getHistoricoReclamacionesByIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
}
