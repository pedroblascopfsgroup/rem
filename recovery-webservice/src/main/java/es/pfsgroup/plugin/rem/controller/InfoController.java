package es.pfsgroup.plugin.rem.controller;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

@Controller
public class InfoController {
	@Autowired
	private RestApi restApi;
	@Autowired
	private GenericAdapter genericAdapter;
	@Autowired
	private ServletContext servletContext;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void closeRest(HttpServletRequest request, ModelMap model, HttpServletResponse response,
			@RequestParam(required = true) String servicios) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			if (!servicios.isEmpty() && (!servicios.equals(RestApi.REST_API_ALL)
					&& !servicios.equals(RestApi.REST_API_BANKIA) && !servicios.equals(RestApi.REST_API_WEBCOM))) {
				model.put("result", "Servicios, valores posibles: " + RestApi.REST_API_ALL + ","
						+ RestApi.REST_API_BANKIA + "," + RestApi.REST_API_WEBCOM);
			} else {
				if(servicios.equals(RestApi.REST_API_ALL)){
					servletContext.setAttribute(RestApi.REST_API_BANKIA, true);
					servletContext.setAttribute(RestApi.REST_API_WEBCOM, true);
					
				}
				servletContext.setAttribute(servicios, true);
				model.put("result", "REST API CERRADA. Servicios: ".concat(servicios));
			}

		}
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void openRest(HttpServletRequest request, ModelMap model, HttpServletResponse response,
			@RequestParam(required = true) String servicios) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
			if (!servicios.isEmpty() && (!servicios.equals(RestApi.REST_API_ALL)
					&& !servicios.equals(RestApi.REST_API_BANKIA) && !servicios.equals(RestApi.REST_API_WEBCOM))) {
				model.put("result", "Servicios, valores posibles: " + RestApi.REST_API_ALL + ","
						+ RestApi.REST_API_BANKIA + "," + RestApi.REST_API_WEBCOM);
			} else {
				if(servicios.equals(RestApi.REST_API_ALL)){
					servletContext.setAttribute(RestApi.REST_API_BANKIA, false);
					servletContext.setAttribute(RestApi.REST_API_WEBCOM, false);
					
				}
				servletContext.setAttribute(servicios, false);
				model.put("result", "REST API "+servicios+" ABIERTA");
			}
			
		}
		restApi.sendResponse(response, model, null);
	}

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

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
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
		}
		restApi.sendResponse(response, model, null);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void getLlamadaInfo(HttpServletRequest request, ModelMap model, HttpServletResponse response,
			@RequestParam(required = true) String id) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (genericAdapter.isSuper(usuarioLogado)) {
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
		}
		restApi.sendResponse(response, model, null);
	}

}
