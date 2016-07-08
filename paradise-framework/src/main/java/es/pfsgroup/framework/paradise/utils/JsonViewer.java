package es.pfsgroup.framework.paradise.utils;

import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

public class JsonViewer {

	public static ModelAndView createModelAndViewJson(ModelMap model) {
		return new ModelAndView("jsonView", model);
	}
	
}
