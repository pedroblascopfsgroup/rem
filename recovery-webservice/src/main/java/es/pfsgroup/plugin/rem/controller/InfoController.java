package es.pfsgroup.plugin.rem.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.rest.api.RestApi;

@Controller
public class InfoController {
	@Autowired
	private RestApi restApi;
	
	/**
	 * Para ver la ip con la que llegas al servidor:
	 * info/getInfo.htm
	 * @param request
	 * @param model
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void getInfo(HttpServletRequest request,ModelMap model, HttpServletResponse response){
		String miIp =restApi.getClientIpAddr(request);
		model.put("request ip", miIp);
		restApi.sendResponse(response, model);
	}

}
