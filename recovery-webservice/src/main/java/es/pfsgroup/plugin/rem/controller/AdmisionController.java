package es.pfsgroup.plugin.rem.controller;

import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.AdmisionApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.model.DtoActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import es.pfsgroup.commons.utils.Checks;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AdmisionController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(AdmisionController.class);
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	
	
	@Autowired
	private AdmisionApi admisionApi;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAgendaRevisionTitulo(Long idActivo, ModelMap model) {
		try {
				
			model.put(RESPONSE_DATA_KEY, admisionApi.getListAgendaRevisionTitulo(idActivo));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("Error en getListAgendaRevisionTitulo AdmisionController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView createAgendaRevisionTitulo(Long idActivo, String subtipologias, String observaciones, ModelMap model) {
		try {
			//
			admisionApi.createAgendaRevisionTitulo(idActivo,subtipologias,observaciones);

			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("Error en createAgendaRevisionTitulo AdmisionController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView deleteAgendaRevisionTitulo(Long idActivoAgendaRevisionTitulo, ModelMap model) {
		try {
			
			admisionApi.deleteAgendaRevisionTitulo(idActivoAgendaRevisionTitulo);

			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("Error en deleteAgendaRevisionTitulo AdmisionController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateAgendaRevisionTitulo(DtoActivoAgendaRevisionTitulo dto, ModelMap model) {
		try {
			
			if(dto.getIdActivoAgendaRevisionTitulo() != null) {
				admisionApi.actualizarAgendaRevisionTitulo(dto);
				model.put(RESPONSE_SUCCESS_KEY, true);
			}else {
				model.put(RESPONSE_SUCCESS_KEY, false);	
			}

		} catch (Exception e) {
			logger.error("Error en deleteAgendaRevisionTitulo AdmisionController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
}
