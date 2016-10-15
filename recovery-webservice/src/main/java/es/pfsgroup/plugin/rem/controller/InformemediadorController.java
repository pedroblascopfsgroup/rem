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

import es.pfsgroup.plugin.rem.api.InformeMediadorApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.rest.dto.InformemediadorRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class InformemediadorController {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	@Autowired
	private InformeMediadorApi informeMediadorApi;

	@SuppressWarnings({ "unchecked" })
	@RequestMapping(method = RequestMethod.POST, value = "/informemediador")
	public void saveInformeMediador(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		InformemediadorRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

		try {
			jsonData = (InformemediadorRequestDto) request.getRequestData(InformemediadorRequestDto.class);
			List<InformeMediadorDto> informes = jsonData.getData();

			listaRespuesta = informeMediadorApi.saveOrUpdateInformeMediador(informes);
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", null);
		} catch (Exception e) {
			logger.error(e);
			if (jsonData != null) {
				model.put("id", jsonData.getId());
			}

			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		}

		restApi.sendResponse(response, model);
	}
}
