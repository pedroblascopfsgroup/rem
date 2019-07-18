package es.pfsgroup.plugin.rem.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoJuntaPropietariosApi;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;

@Controller
public class ActivoJuntaPropietariosController extends ParadiseJsonController {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ActivoJuntaPropietariosApi activoJuntaPropietariosApi;
	
	
	/**
	 * Método que recupera un ActivoJuntaPropietarios  según su id y lo mapea a un DTO
	 * @param id ActivoJuntaPropietarios
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findOne(Long id, ModelMap model){

		model.put("data", activoJuntaPropietariosApi.findOne(id));
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios, ModelMap model) {
		try {

			DtoPage page = activoJuntaPropietariosApi.getListJuntas(dtoActivoJuntaPropietarios);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);
			model.put("exception", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
}
