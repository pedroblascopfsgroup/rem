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

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.TramitacionOfertasApi;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;

@Controller
public class TramitacionOfertasController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(TramitacionOfertasController.class);
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_MESSAGE_KEY = "msg";
	private static final String ENTIDAD_ARUPACION = "agrupacion";
	
	@Autowired
	private TramitacionOfertasApi tramitacionOfertasManager;

	//ActivoController
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOferta(DtoOfertaActivo ofertaActivoDto, ModelMap model, HttpServletRequest request, String entidad) {
		try {
			boolean success = tramitacionOfertasManager.saveOferta(ofertaActivoDto, ENTIDAD_ARUPACION.equals(entidad));
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

}
