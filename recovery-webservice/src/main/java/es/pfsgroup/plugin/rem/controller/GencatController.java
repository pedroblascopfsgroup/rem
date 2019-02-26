package es.pfsgroup.plugin.rem.controller;

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

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GencatAdapter;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.AdjuntoComunicacion;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAltaVisita;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.DtoNotificacionActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoComunicacion;


@Controller
public class GencatController {
	
	protected static final Log logger = LogFactory.getLog(GencatController.class);
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_SUCCESS_DATA = "data";

	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private GencatAdapter gencatAdapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDetalleGencatByIdActivo(Long id, ModelMap model) {

		try {
			model.put("data", gencatApi.getDetalleGencatByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getOfertasAsociadasByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getOfertasAsociadasByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getReclamacionesByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getReclamacionesByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntosComunicacionByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getListAdjuntosComunicacionByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoComunicacionesByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getHistoricoComunicacionesByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDetalleHistoricoByIdComunicacionHistorico(Long id, Long idHComunicacion, ModelMap model) {

		try {
			model.put("data", gencatApi.getDetalleHistoricoByIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoOfertasAsociadasIdComunicacionHistorico(Long idHComunicacion, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getHistoricoOfertasAsociadasIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoReclamacionesByIdComunicacionHistorico(Long idHComunicacion, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getHistoricoReclamacionesByIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntosComunicacionHistoricoByIdComunicacionHistorico(Long idHComunicacion, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getListAdjuntosComunicacionHistoricoByIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	/**
	 * Descarga un adjunto de una comunicacion o de una comunicacion del historico
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoComunicacion(HttpServletRequest request, HttpServletResponse response) {

		Long id = null;
		try {
			id = Long.parseLong(request.getParameter("id"));
			String nombreDocumento = request.getParameter("nombreDocumento");
			ServletOutputStream salida = response.getOutputStream();
			FileItem fileItem =  null;
			fileItem = activoAdapter.downloadComunicacionGencat(id,nombreDocumento);
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
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
		}

	}
	
	/**
	 * Recibe y guarda un adjunto de una comunicacion
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadAdjuntoComunicacion(HttpServletRequest request) {

		ModelMap model = new ModelMap();
		
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			gencatAdapter.upload(webFileItem);
			model.put("success", true);
		} 
		catch (GestorDocumentalException e) {
			logger.error("error en gencatController", e);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero al gestor documental.");
		}
		catch (Exception e) {
			logger.error("error en gencatController", e);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero.");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getNotificacionesByIdActivo(Long id, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getNotificacionesByIdActivo(id));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getNotificacionesHistoricoByIdComunicacionHistorico(Long idHComunicacion, ModelMap model) {
		
		try {
			model.put("data", gencatApi.getNotificacionesHistoricoByIdComunicacionHistorico(idHComunicacion));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	/**
	 * Recibe y inserta una notificación en una comunicación
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearNotificacionComunicacion(HttpServletRequest request, DtoNotificacionActivo notificacionActivo) {

		ModelMap model = new ModelMap();
		
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			String idAdjunto = gencatAdapter.upload(webFileItem);
			notificacionActivo.setIdDocumento(idAdjunto);
			//model.put("success", true);
			model.put("data", gencatApi.createNotificacionComunicacion(notificacionActivo));
			model.put("success", true);
		}
		catch (Exception e) {
			logger.error("error en gencatController", e);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema durante la creación de la notificación.");
		}
		
		return createModelAndViewJson(model);
	}

	/**
	 * Guarda los datos del apartado saveDatosComunicacion
	 * 
	 * @param gencatDto
	 * @param id
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosComunicacion(DtoGencatSave gencatDto, ModelMap model) {

		model.remove("dtoGencatSave");
		if( gencatApi.saveDatosComunicacion(gencatDto) )
		{
			model.put("success", true);			
		}
		else
		{
			logger.warn("error en gencatController");
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema en el guardado del formulario.");
		}
		
		return createModelAndViewJson(model);
	}
	
	/**
	 * Recibe y da de alta una visita de una comunicación
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView altaVisitaComunicacion(DtoAltaVisita dtoAltaVisita) {

		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gencatApi.altaVisitaComunicacion(dtoAltaVisita));
			model.put(RESPONSE_SUCCESS_KEY, true);
		}
		catch (Exception e) {
			logger.error("error en gencatController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, gencatApi.deleteAdjunto(dtoAdjunto));

		} catch (Exception e) {
			logger.error("error en gencatController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateFechaReclamacion(DtoReclamacionActivo gencatDto, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, gencatApi.updateFechaReclamacion(gencatDto));
		} catch (Exception e) {
			logger.error("error en gencatController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTiposDocumentoComunicacion(ModelMap model) {
		
		try {
			model.put(RESPONSE_SUCCESS_DATA, gencatApi.getTiposDocumentoComunicacion());
		} catch (Exception e) {
			logger.error("error en gencatController", e);
			model.put(RESPONSE_SUCCESS_DATA, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTiposDocumentoNotificacion(ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_DATA, gencatApi.getTiposDocumentoNotificacion());
		} catch (Exception e) {
			logger.error("error en gencatController", e);
			model.put(RESPONSE_SUCCESS_DATA, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	public ModelAndView comprobacionDocumentoAnulacion(Long idActivo, ModelMap model) {
		
		try {
			model.put("data", gencatApi.comprobacionDocumentoAnulacion(idActivo));
			model.put("success", true);
		} 
		catch (Exception e) {
			logger.error("Error en gencatController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
}
