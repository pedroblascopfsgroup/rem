package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.net.SocketException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

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

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.TributoAdapter;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoTributo;


@Controller
public class TributoController extends ParadiseJsonController {
	
	protected static final Log logger = LogFactory.getLog(TributoController.class);
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private TributoAdapter tributoAdapter;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request) {

		ModelMap model = new ModelMap();

		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
				tributoAdapter.upload(webFileItem);
				model.put("success", true);
		} catch (GestorDocumentalException e) {
			logger.error("error en tributoController", e);
			model.put("success", false);
			model.put("errorMessage", "Gestor documental: No existe la tributo o no tiene permiso para subir el documento");
		} catch (Exception e) {
			logger.error("error en tributoController", e);
			model.put("success", false);
			model.put("errorMessage",e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoActivoTributo(HttpServletRequest request, HttpServletResponse response) {
		ServletOutputStream salida = null;
		
		try {
			Long id = Long.parseLong(request.getParameter("id"));
			String nombreDocumento = request.getParameter("nombreDocumento");
			salida = response.getOutputStream();
			FileItem fileItem = tributoAdapter.download(id, nombreDocumento);
			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the proxy
			if(!Checks.esNulo(fileItem.getContentType())) {
				response.setContentType(fileItem.getContentType());
			}

			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);

		} catch(UserException ex) {
			try {
				if (salida != null) {
					salida.write(ex.toString().getBytes(Charset.forName("UTF-8")));
				}
			} catch (IOException e) {
				logger.error("error en activoController", e);
			}
	
		}
		catch (SocketException e) {
			logger.warn("error en activoController", e);
		}catch (Exception e) {
			logger.error("error en activoController", e);
		}finally {
			try {
				if (salida != null) {
					salida.flush();			
					salida.close();
				}
			} catch (IOException e) {
				logger.error("error en activoController", e);
			}
		}

	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(DtoAdjuntoTributo dto, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, tributoAdapter.deleteAdjunto(dto));

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDocumentosTributo(Long idTributo, ModelMap model, HttpServletRequest request) {
		
		List<DtoAdjuntoTributo> listaDocs = new ArrayList<DtoAdjuntoTributo>();
		
		try {
			if(idTributo != null) {
				listaDocs = tributoAdapter.getAdjuntos(idTributo);
			}
			model.put(RESPONSE_DATA_KEY, listaDocs);

		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
			
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}

}
