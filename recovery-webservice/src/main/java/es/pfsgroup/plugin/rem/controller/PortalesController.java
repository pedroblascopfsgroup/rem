package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;
import es.pfsgroup.plugin.rem.rest.dto.PortalesRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class PortalesController {

	@Autowired
	private ActivoApi activoApi;

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/portales")
	public void portales(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {

		PortalesRequestDto jsonData = null;
		List<PortalesDto> listaPortalesDto = null;
		ArrayList<Map<String, Object>> listaRespuesta = null;
		JSONObject jsonFields = null;
		
		try {
			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);
			
			jsonData = (PortalesRequestDto) request.getRequestData(PortalesRequestDto.class);
			listaPortalesDto = jsonData.getData();
			listaRespuesta = activoApi.saveOrUpdate(listaPortalesDto);
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", null);

		} catch (Exception e) {
			logger.error("Error portales", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);

		} finally {
			logger.debug("RESPUESTA: " + model);
		}

		restApi.sendResponse(response, model,request);
	}

}
