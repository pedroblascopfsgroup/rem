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
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activoJuntaPropietarios.ActivoJuntaPropietariosManager;
import es.pfsgroup.plugin.rem.api.ActivoJuntaPropietariosApi;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ACCION_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ENTIDAD_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.REQUEST_STATUS_CODE;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.rest.dto.ActivoDto;

@Controller
public class ActivoJuntaPropietariosController extends ParadiseJsonController {

	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	
	@Autowired
	private ActivoJuntaPropietariosApi activoJuntaPropietariosApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private ActivoJuntaPropietariosManager activoJuntaPropietariosManager;
	
	@Autowired
	private LogTrustEvento trustMe;
	
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
	
	// PESTAÑA DATOS (JUNTAS)
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabJunta(Long id, String tab, ModelMap model, HttpServletRequest request) {
		
		try {
			model.put(RESPONSE_DATA_KEY, activoJuntaPropietariosApi.getTabJunta(id, tab));
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_PROVEEDOR , tab, ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error("Error en ActivoJuntaPropietariosController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_PROVEEDOR, tab, ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);

		}

		return createModelAndViewJson(model);
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivosJuntas(ModelMap model, Long idJunta, HttpServletRequest request) {
		try {
			model.put("data", activoJuntaPropietariosApi.getActivosJuntasVista(idJunta));
//			model.put(RESPONSE_DATA_KEY, dto.getResults());
//			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idJunta, ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "activos", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ActivoJuntaPropietariosController", e);
			trustMe.registrarError(request, idJunta, ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "activos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}
	
	
	
	//---------------------------------------  GESTOR DOCUMENTAL ---------------------------------------------------------------------
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long idJunta, ModelMap model, HttpServletRequest request){

		try {
			model.put(RESPONSE_DATA_KEY, activoJuntaPropietariosManager.getAdjuntosJunta(idJunta));
			trustMe.registrarSuceso(request, idJunta, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "adjuntos", ACCION_CODIGO.CODIGO_VER);

		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
			trustMe.registrarError(request, idJunta, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "adjuntos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);

		} catch (Exception e) {
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idJunta, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "adjuntos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}
	
	
	
	 // Recibe y guarda un adjunto
	 
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		try {
			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

			String errores = activoJuntaPropietariosManager.uploadDocumento(fileItem, null, null);
			model.put("errores", errores);
			model.put(RESPONSE_SUCCESS_KEY, errores == null);

		} catch (GestorDocumentalException eGd) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", eGd.getMessage());
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
			logger.error("Error en ActivoJuntaPropietariosController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
    public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto) {
		
		boolean success= false;
		
		try {
			success = activoJuntaPropietariosApi.deleteAdjunto(dtoAdjunto);
		} catch(Exception ex) {
			logger.error(ex.getMessage());
		}
    	
    	return createModelAndViewJson(new ModelMap("success", success));

    }
	
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoJunta (HttpServletRequest request, HttpServletResponse response) {
        
		DtoAdjunto dtoAdjunto = new DtoAdjunto();
		
		dtoAdjunto.setId(Long.parseLong(request.getParameter("id")));
		dtoAdjunto.setIdEntidad(Long.parseLong(request.getParameter("idJunta")));
		String nombreDocumento = request.getParameter("nombreDocumento");
		dtoAdjunto.setNombre(nombreDocumento);
		
       	FileItem fileItem = activoJuntaPropietariosApi.getFileItemAdjunto(dtoAdjunto);
		
       	try { 

       		if(!Checks.esNulo(fileItem)) {
	       		ServletOutputStream salida = response.getOutputStream();

	       		response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
	       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
	       		response.setHeader("Cache-Control", "max-age=0");
	       		response.setHeader("Expires", "0");
	       		response.setHeader("Pragma", "public");
	       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
	       		response.setContentType(fileItem.getContentType());

	       		// Write
	       		FileUtils.copy(fileItem.getInputStream(), salida);
	       		salida.flush();
	       		salida.close();
       		}
       		
       	} catch (Exception e) { 
       		logger.error(e.getMessage(),e);
       	}

	}
	
	
}
