package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.api.UrsusApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.UrsusDto;
import es.pfsgroup.plugin.rem.rest.dto.UrsusRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class UrsusController {
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	@Autowired
	private UrsusApi ursusApi;

	@SuppressWarnings({ "unchecked" })
	@RequestMapping(method = RequestMethod.POST, value = "/ursus")
	public void saveNumerosUrsus(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		UrsusRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;
		
		try {
			jsonFields = request.getJsonObject();
			
			jsonData = (UrsusRequestDto) request.getRequestData(UrsusRequestDto.class);
			List<UrsusDto> informes = jsonData.getData();

			listaRespuesta = ursusApi.saveOrUpdateNumerosUrsus(informes,jsonFields);
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", null);
			
		} catch (Exception e) {
			logger.error("Error informe", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			if (jsonFields != null) {
				model.put("id", jsonFields.get("id"));
			}
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		}

		restApi.sendResponse(response, model,request);
	}
}