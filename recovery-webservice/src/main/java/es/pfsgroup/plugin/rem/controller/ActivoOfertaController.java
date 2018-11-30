package es.pfsgroup.plugin.rem.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;

@Controller
public class ActivoOfertaController extends ParadiseJsonController {
	
	protected static final Log logger = LogFactory.getLog(ActivoController.class);
	
	private static final String DOC_ADJUNTO_CREAR_OFERTA = "Guardando documento adjunto crear oferta.";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDocumentoAdjuntoOferta(Long id, WebDto webDto, ModelMap model) {
		
		model.put("data", "true");
		logger.info(DOC_ADJUNTO_CREAR_OFERTA);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView eliminarDocumentoAdjuntoOferta(Long id, WebDto webDto, ModelMap model) {
		
		model.put("data", "true");
		logger.info(DOC_ADJUNTO_CREAR_OFERTA);

		return createModelAndViewJson(model);
	}

}
