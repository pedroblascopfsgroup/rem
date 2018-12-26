package es.pfsgroup.plugin.rem.controller;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
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
		} catch (GestorDocumentalException e) {
			model.put("success", false);
			model.put("errorMessage",
					"Ha habido un problema con la subida del fichero de promociones al gestor documental.");
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
	
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoActivoPromocion(HttpServletRequest request, HttpServletResponse response) {

		Long id = null;
		try {
			id = Long.parseLong(request.getParameter("id"));
			String nombreDocumento = request.getParameter("nombreDocumento");
			ServletOutputStream salida = response.getOutputStream();
			FileItem fileItem = promocionAdapter.download(id,nombreDocumento);
			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the
													// proxy
			if(!Checks.esNulo(fileItem.getContentType())) {
				response.setContentType(fileItem.getContentType());
			}
			
			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);
			salida.flush();
			salida.close();
		} catch (Exception e) {
			logger.error("error en activoController", e);
		}

	}

}
