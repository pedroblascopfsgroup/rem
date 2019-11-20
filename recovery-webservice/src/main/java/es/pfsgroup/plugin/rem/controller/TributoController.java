package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.nio.charset.Charset;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.TributoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;


@Controller
public class TributoController extends ParadiseJsonController {
	
	protected static final Log logger = LogFactory.getLog(TributoController.class);
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	

	@Autowired
	private ActivoAdapter adapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private TributoAdapter tributoAdapter;
	
	@Autowired
	private ActivoTributoApi activoTributoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request) {

		ModelMap model = new ModelMap();

		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			if(activoTributoApi.comprobarSiExisteActivoTributo(webFileItem)) {
				tributoAdapter.upload(webFileItem);
				model.put("success", true);
			}else {
				model.put("success", false);
				model.put("errorMessage", "Ya existe un documento para este tributo");
			}
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
		Long idTributo = null;
		Long id = null;
		try {
			idTributo = Long.parseLong(request.getParameter("idTributo"));
			Filter filtroAdjuntoActivoTributo = genericDao.createFilter(FilterType.EQUALS, "activoTributo.id", idTributo);
			Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroRest = null;
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				filtroRest = genericDao.createFilter(FilterType.NOTNULL, "idDocRestClient");
			}else {
				filtroRest = genericDao.createFilter(FilterType.NULL, "idDocRestClient");
			}

			
			ActivoAdjuntoTributo activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filtroAdjuntoActivoTributo,filtroRest, filtroAuditoria);
			
			if(!Checks.esNulo(activoAdjuntoTributo)) {
				id = activoAdjuntoTributo.getIdDocRestClient();
				
				String nombreDocumento = request.getParameter("nombreDocumento");
				salida = response.getOutputStream();
				FileItem fileItem = tributoAdapter.download(id,nombreDocumento);
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
			}
		}catch(UserException ex) {
			try {
				salida.write(ex.toString().getBytes(Charset.forName("UTF-8")));
			} catch (IOException e) {
				e.printStackTrace();
			}
	
		} catch (Exception e) {
			logger.error("error en activoController", e);
		}finally {
			try {
				salida.flush();			
				salida.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(Long idActivo,Long idTributo, ModelMap model) {
	
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoTributoApi.deleteAdjuntoDeTributo(idTributo));

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

}
