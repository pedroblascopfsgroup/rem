package es.pfsgroup.plugin.rem.controller;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class FotosController {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@RequestMapping(method = RequestMethod.POST, value = "/fotos")
	public void fotos(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		logger.error("############################################### WEBHOOK ##############################################");
		logger.error(request.getBody());
		logger.error("######################################################################################################");
	}

}
