package es.pfsgroup.plugin.rem.controller;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
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

	@RequestMapping(method = RequestMethod.POST, value = "/fotos")
	@Transactional(readOnly = false)
	public void fotos(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		try {
			WebHookRequest requestData = mapper.readValue(request.getBody(), WebHookRequest.class);
			// modificados o creados
			if (requestData.getModified() != null) {
				for (es.pfsgroup.plugin.rem.rest.dto.File file : requestData.getModified()) {
					if (file.getMetadata().containsKey("propiedad")) {
						if (file.getMetadata().get("propiedad").equals("activo")) {
							activoManager.uploadFoto(file);
						} else if (file.getMetadata().get("propiedad").equals("agrupacion")) {
							activoAgrupacionManager.uploadFoto(file);
						} else if (file.getMetadata().get("propiedad").equals("subdivision")) {
							activoAgrupacionManager.uploadFotoSubdivision(file);
						}
					}

				}
			}
			// borrados
			if (requestData.getDeleted() != null) {
				for (es.pfsgroup.plugin.rem.rest.dto.File file : requestData.getDeleted()) {
					activoAdapter.deleteFotoByRemoteId(file.getId());
				}
			}
			request.getPeticionRest().setResult("OK");
		} catch (Exception e) {
			request.getPeticionRest().setResult("ERROR");
			request.getPeticionRest().setErrorDesc(e.getMessage());
			logger.error("Error fotos", e);
		}
	}

	@RequestMapping(method = RequestMethod.POST, value = "/fotos/fueraToken")
	public void fueraToken(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		servletContext.setAttribute("idAuthToken", null);
	}

}
