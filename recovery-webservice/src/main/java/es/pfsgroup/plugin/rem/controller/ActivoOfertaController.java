package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.util.List;

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
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.adapter.ActivoOfertaAdapter;
import es.pfsgroup.plugin.rem.api.GdprApi;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;

@Controller
public class ActivoOfertaController extends ParadiseJsonController {
	
	
	@Autowired 
    private UploadAdapter uploadAdapter;
	
	@Autowired 
    private ActivoOfertaAdapter activoOfertaAdapter;
	
	
	@Autowired
	private GdprApi gdprManager;
	
	protected static final Log logger = LogFactory.getLog(ActivoOfertaController.class);
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_ERROR_MESSAGE_KEY = "errorMessage";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(String docCliente, Long idActivo, Long idAgrupacion) {
		ModelMap model = new ModelMap();
		try {
			String idPersonaHaya = gdprManager.obtenerIdPersonaHaya(docCliente);
			model.put(RESPONSE_DATA_KEY, activoOfertaAdapter.getAdjunto(idPersonaHaya, docCliente, idActivo, idAgrupacion/*, idClienteTmp*/));
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDocumentoAdjuntoOferta(String docCliente, String idEntidad, HttpServletRequest request) {
		
		ModelMap model = new ModelMap();
		WebFileItem fileItem = null;
		
		try {
			
			String idPersonaHaya = gdprManager.obtenerIdPersonaHaya(docCliente);
			fileItem = uploadAdapter.getWebFileItem(request);
			String errores = null;
			if(idPersonaHaya != null && !idPersonaHaya.isEmpty()){
				errores = activoOfertaAdapter.uploadDocumento(fileItem, idPersonaHaya, docCliente);
				model.put("errores", errores);
				model.put(RESPONSE_SUCCESS_KEY, errores==null);
				FileUtils.deleteFile(fileItem.getFileItem().getFile().getPath());
			}else{
				throw new Exception("idPersonaHaya no puede ser null");
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}finally{
			try {
				FileUtils.deleteFile(fileItem.getFileItem().getFile().getPath());			
			} catch (IOException e) 
			{
				logger.error(e.getMessage(),e);
				model.put(RESPONSE_SUCCESS_KEY, false);
			    model.put("errorMessage", e.getMessage());
				
			}
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView eliminarDocumentoAdjuntoOferta(String docCliente) {

		ModelMap model = new ModelMap();
		List<DtoAdjunto> listaAdjuntos = null;

		try {
			String idPersonaHaya = gdprManager.obtenerIdPersonaHaya(docCliente);
			listaAdjuntos = activoOfertaAdapter.getAdjunto(idPersonaHaya, docCliente, null, null);

			if (!Checks.estaVacio(listaAdjuntos)) {
				AdjuntoComprador adjComprador = gdprManager.obtenerAdjuntoComprador(docCliente, listaAdjuntos.get(0).getId());

				boolean success = false;
				if (adjComprador != null) {
					// esta en el ggdd y en el modelo de datos
					success = gdprManager.deleteAdjuntoPersona(adjComprador, docCliente);
				} else {
					// esta en el ggdd pero no en el modelo
					success = activoOfertaAdapter.deleteAdjunto(listaAdjuntos.get(0).getId());
				}

				model.put(RESPONSE_SUCCESS_KEY, success);
			}
		} catch (Exception e) {
			model.put("success", false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error(e.getMessage(), e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteTmpClienteByDocumento(ModelMap model, String docCliente) {
		try {
			gdprManager.deleteTmpClienteByDocumento(docCliente);
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
}
