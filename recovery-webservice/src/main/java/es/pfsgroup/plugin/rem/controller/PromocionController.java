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
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.PromocionAdapter;


@Controller
public class PromocionController extends ParadiseJsonController {
	
	protected static final Log logger = LogFactory.getLog(PromocionController.class);
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private PromocionAdapter promocionAdapter;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntosPromocion(Long id, ModelMap model) {

		try {
			model.put("data", promocionAdapter.getAdjuntosPromocion(id));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request) {

		ModelMap model = new ModelMap();

		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			promocionAdapter.upload(webFileItem);
			model.put("success", true);
		} catch (GestorDocumentalException e) {
			logger.error("error en promocionController", e);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero de promociones al gestor documental.");
		} catch (Exception e) {
			logger.error("error en promocionController", e);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero de promociones.");
		}
		return createModelAndViewJson(model);
	}

}
