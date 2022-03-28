package es.pfsgroup.plugin.rem.controller;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.api.RecomendacionApi;
import es.pfsgroup.plugin.rem.model.DtoConfiguracionRecomendacion;

@Controller
public class RecomendacionController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(RecomendacionController.class);
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_MESSAGE_KEY= "msgError";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	
	private static final String CONFIG_EXISTENTE = "Ya existe una configuración";
	
	@Autowired
	private RecomendacionApi recomendacionApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getConfiguracionesRecomendacion(ModelMap model) {
		try {
			List<DtoConfiguracionRecomendacion> resultados = recomendacionApi.getConfiguracionesRecomendacion();
			model.put(RESPONSE_DATA_KEY, resultados);
			if (!Checks.estaVacio(resultados)) {
				model.put(RESPONSE_TOTALCOUNT_KEY, resultados.size());
			} else {
				model.put(RESPONSE_TOTALCOUNT_KEY, 0);
			}
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("Error en RecomendacionController.getConfiguracionesRecomendacion(model)", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveConfigRecomendacion(DtoConfiguracionRecomendacion dtoConfiguracionRecomendacion, ModelMap model) {
		try {
			boolean success = recomendacionApi.saveConfigRecomendacion(dtoConfiguracionRecomendacion);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			
			Throwable t = e.getCause();
		    while ((t != null) && !(t instanceof ConstraintViolationException)) {
		        t = t.getCause();
		    }
		    if (t instanceof ConstraintViolationException) {
		    	model.put(RESPONSE_ERROR_MESSAGE_KEY, CONFIG_EXISTENTE);
		    	logger.debug("RecomendacionController.saveConfigRecomendacion(dtoTestigoObligatorio, model): "+CONFIG_EXISTENTE);
		    } else {
		    	logger.error("Error en RecomendacionController.saveConfigRecomendacion(dtoTestigoObligatorio, model)", e);
		    }
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteConfigRecomendacion(DtoConfiguracionRecomendacion dtoConfiguracionRecomendacion, ModelMap model) {
		try {
			boolean success = recomendacionApi.deleteConfigRecomendacion(dtoConfiguracionRecomendacion);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("Error en RecomendacionController.deleteConfigRecomendacion(dtoTestigoObligatorio, model)", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

}
