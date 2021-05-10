package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.WebHookRequest;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class FotosController {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private ServletContext servletContext;

	private ObjectMapper mapper = new ObjectMapper();

	@Autowired
	private ActivoApi activoManager;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionManager;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private RestApi restApi;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/fotos")
	public void fotos(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		try {
			WebHookRequest requestData = mapper.readValue(request.getBody(), WebHookRequest.class);
			List<Long> idsError = new ArrayList<Long>();
			// modificados o creados
			if (requestData.getModified() != null) {
				for (es.pfsgroup.plugin.rem.rest.dto.File file : requestData.getModified()) {
					HashMap<String, String> errorsList = new HashMap<String, String>();
					HashMap<String, Object> map = new HashMap<String, Object>();
					try {
						if (file.getMetadata().containsKey("propiedad")) {
							if (file.getMetadata().get("propiedad").equals("activo")) {
								activoManager.uploadFoto(file);
							} else if (file.getMetadata().get("propiedad").equals("agrupacion")) {
								activoAgrupacionManager.uploadFoto(file);
							} else if (file.getMetadata().get("propiedad").equals("subdivision")) {
								activoAgrupacionManager.uploadFotoSubdivision(file);
							}
						}
					} catch (Exception e) {
						errorsList.put("Exception", e.getMessage());
					}
					if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
						map.put("id", file.getId());
						map.put("success", true);
					} else {
						map.put("id", file.getId());
						map.put("success", false);
						map.put("error", errorsList);
						idsError.add(file.getId());
					}
					listaRespuesta.add(map);

				}
			}
			// borrados
			if (requestData.getDeleted() != null) {
				for (es.pfsgroup.plugin.rem.rest.dto.File file : requestData.getDeleted()) {
					HashMap<String, String> errorsList = new HashMap<String, String>();
					HashMap<String, Object> map = new HashMap<String, Object>();
					try {
						activoAdapter.deleteFotoByRemoteId(file.getId());
					} catch (Exception e) {
						errorsList.put("Exception", e.getMessage());
					}
					if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
						map.put("id", file.getId());
						map.put("success", true);
					} else {
						map.put("id", file.getId());
						map.put("success", false);
						map.put("error", errorsList);
						idsError.add(file.getId());
					}
					listaRespuesta.add(map);
				}
			}			
			model.put("id", null);
			model.put("data", listaRespuesta);
			String error = null;
			if(idsError.isEmpty()) {
				request.getPeticionRest().setResult("OK");
				model.put("success", true);
			}else if(idsError.size() == (requestData.getModified() != null ? requestData.getModified().size() : 0)
					+ (requestData.getDeleted() != null ? requestData.getDeleted().size() : 0)) {
				error = "[ERROR] Todas las fotos han fallado.";
				model.put("success", false);
			}else {
				error = "[WARNING] Las fotos con id: ";
				for(Long id : idsError)
					error += id + ", ";
				error = error.substring(0, error.length()-2);
				error += " han fallado, el resto han ido bien.";
				model.put("success", false);
			}
			request.getPeticionRest().setErrorDesc(error == null ? error : error.length() > 200 ? error.substring(0, 200) : error);
			model.put("error", error == null ? "null" : error);
		} catch (Exception e) {
			request.getPeticionRest().setResult("ERROR");
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", null);
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			model.put("success", false);
			logger.error("Error fotos", e);
		}
		restApi.sendResponse(response, model, request);
	}

	@RequestMapping(method = RequestMethod.POST, value = "/fotos/fueraToken")
	public void fueraToken(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		servletContext.setAttribute("idAuthToken", null);
	}

	@RequestMapping(method = RequestMethod.GET, value = "/fotos/download")
	public ModelAndView getFotoActivoById(Long idFoto, RestRequestWrapper request, HttpServletResponse response) {
		request.setTrace(false);
		ActivoFoto actvFoto = activoAdapter.getFotoActivoById(idFoto);
		if (actvFoto.getRemoteId() != null) {
			// response.setHeader("Location", actvFoto.getUrl());
			return new ModelAndView("redirect:" + actvFoto.getUrl());
		} else {
			FileItem fileItem = activoAdapter.getFotoActivoById(idFoto).getAdjunto().getFileItem();

			try {
				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the
														// proxy

				if (fileItem.getContentType() != null) {
					response.setContentType(fileItem.getContentType());
				} else {
					response.setContentType("Content-type: image/jpeg");
				}
				request.getPeticionRest().setResult("OK");
				// Write
				FileUtils.copy(fileItem.getInputStream(), salida);
				salida.flush();
				salida.close();

			} catch (Exception e) {
				logger.error(e);
			}
			return null;
		}

	}

}
