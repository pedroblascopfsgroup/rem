package es.pfsgroup.plugin.rem.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.adapter.GestorSustitutoAdapter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;

@Controller
public class GestorSustitutoController extends ParadiseJsonController {
	
	protected static final Log logger = LogFactory.getLog(GestorSustitutoController.class);
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_MESSAGE_KEY = "msg";
	private static final String RESPONSE_ERROR_MESSAGE_KEY= "msgError";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	
	@Autowired
	private GestorSustitutoAdapter adapter;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getGestoresSustitutos(DtoGestoresSustitutosFilter dtoGestoresSustitutosFiltro, ModelMap model, HttpServletRequest request) {
		try {			
			Page page = adapter.getGestoresSustitutos(dtoGestoresSustitutosFiltro);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en gestorSustitutoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createGestorSustituto(DtoGestoresSustitutosFilter dtoGestoresSustitutosFiltro, ModelMap model) {

		try {
			
			String result = adapter.createGestorSustituto(dtoGestoresSustitutosFiltro);
			if(!Checks.esNulo(result) && result.length() > 0) {			
				model.put("data", result);
				model.put("success", false);
			}else {
				model.put("success", true);
			}
		} catch (Exception e) {
			logger.error(e);
			model.put("data", e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGestorSustitutoById(DtoGestoresSustitutosFilter dtoGestoresSustitutosFiltro, ModelMap model) {

		try {
			adapter.deleteGestorSustitutoById(dtoGestoresSustitutosFiltro);
			model.put("success", true);
			
		} catch (Exception e) {
			logger.error(e);
			model.put("data", e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	
}
