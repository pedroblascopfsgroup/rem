package es.pfsgroup.plugin.rem.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ReintegroApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ReintegroDto;
import es.pfsgroup.plugin.rem.rest.dto.ReintegroRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller

public class ReintegroController {

	@Autowired
	private RestApi restApi;


	@Autowired
	private ReintegroApi reintegroApi;
	
	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/reintegro")
	public void reintegroReservaInmueble(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {

		ReintegroRequestDto jsonData = null;
		ReintegroDto reintegroDto = null;
		JSONObject jsonFields = null;
		HashMap<String, String> errorsList = null;
		
		try {
			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);
			
			jsonData = (ReintegroRequestDto) request.getRequestData(ReintegroRequestDto.class);
			reintegroDto = jsonData.getData();
				
			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			}
				
			errorsList = reintegroApi.validateReintegroPostRequestData(reintegroDto, jsonFields);			
			if (!Checks.esNulo(errorsList) && errorsList.size() == 0) {				
				model.put("id", jsonFields.get("id"));
				model.put("ofertaHRE", jsonData.getData().getOfertaHRE());
				model.put("error", "");
			} else {
				model.put("id", jsonFields.get("id"));
				model.put("ofertaHRE", jsonData.getData().getOfertaHRE());
				model.put("error", errorsList);
			}
			
		} catch (Exception e) {
			logger.error("Error reintegro", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			if (jsonFields != null) {
				model.put("id", jsonFields.get("id"));
			}
			model.put("ofertaHRE", jsonData.getData().getOfertaHRE());
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			
		} finally {
			logger.debug("RESPUESTA: " + model);
		}
		
		restApi.sendResponse(response, model,request);
	}

}