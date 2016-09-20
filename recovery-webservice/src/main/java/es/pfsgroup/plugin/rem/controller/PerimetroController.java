package es.pfsgroup.plugin.rem.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.api.PerimetroApi;


@Controller
public class PerimetroController {


	@Autowired
	private PerimetroApi perimetroApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;


	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getPerimetro(Long idActivo,
			ModelMap model) {

		return null;

	}

}
