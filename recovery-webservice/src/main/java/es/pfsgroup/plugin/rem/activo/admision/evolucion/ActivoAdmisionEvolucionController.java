package es.pfsgroup.plugin.rem.activo.admision.evolucion;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.activo.admision.evolucion.api.ActivoAdmisionEvolucionApi;

@Controller
public class ActivoAdmisionEvolucionController extends ParadiseJsonController {

	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	
	@Autowired
	private ActivoAdmisionEvolucionApi activoAdmisionEvolucionApi;
	
	/**
	 * Método que recupera una lista de hacia el grid Evolucion
	 * 
	 * 
	 * @return List
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoAgendaEvolucion(Long id, ModelMap model){

		model.put(RESPONSE_DATA_KEY,activoAdmisionEvolucionApi.getListActivoAgendaEvolucion(id));
		
		return createModelAndViewJson(model);
	}
	
	
	
}
