package es.pfsgroup.plugin.rem.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

@Controller
public class InfoController {
	@Autowired
	private RestApi restApi;

	/**
	 * Para ver la ip con la que llegas al servidor: info/getInfo.htm
	 * 
	 * @param request
	 * @param model
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void getInfo(HttpServletRequest request, ModelMap model, HttpServletResponse response) {
		String miIp = restApi.getClientIpAddr(request);
		model.put("request ip", miIp);
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void getPeticionInfo(HttpServletRequest request, ModelMap model, HttpServletResponse response,
			@RequestParam(required = true) String id) {

		PeticionRest peticion = restApi.getLastPeticionByToken(id);
		if (peticion != null) {
			model.put("ip", peticion.getIp());
			model.put("fecha", peticion.getAuditoria().getFechaCrear());
			model.put("endpoint", peticion.getQuery());
			model.put("metodo", peticion.getMetodo());
			model.put("peticion", peticion.getData());
			if (peticion.getResult().equals(RestApi.CODE_ERROR)) {
				model.put("error", StringEscapeUtils.escapeJavaScript(peticion.getErrorDesc()));
			}
			model.put("respuesta", peticion.getResponse());
			model.put("tiempo ejecución", peticion.getTiempoEjecucion());
		} else {
			model.put("error", "No existe la petición");
		}
		restApi.sendResponse(response, model, null);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void getLlamadaInfo(HttpServletRequest request, ModelMap model, HttpServletResponse response,
			@RequestParam(required = true) String id) {

		PeticionRest peticion = restApi.getLastPeticionByToken(id);
		if (peticion != null) {
			model.put("ip", peticion.getIp());
			model.put("fecha", peticion.getAuditoria().getFechaCrear());
			model.put("endpoint", peticion.getQuery());
			model.put("metodo", peticion.getMetodo());
			model.put("peticion", peticion.getData());
			if (peticion.getResult().equals(RestApi.CODE_ERROR)) {
				model.put("error", StringEscapeUtils.escapeJavaScript(peticion.getErrorDesc()));
			}
			model.put("respuesta", peticion.getResponse());
			model.put("tiempo ejecución", peticion.getTiempoEjecucion());
		} else {
			model.put("error", "No existe la petición");
		}
		restApi.sendResponse(response, model, null);
	}

}
