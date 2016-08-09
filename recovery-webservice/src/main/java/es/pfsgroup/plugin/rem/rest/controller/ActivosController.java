package es.pfsgroup.plugin.rem.rest.controller;

import javax.ws.rs.PathParam;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import net.sf.json.JSONObject;

@Controller
public class ActivosController {

	@Autowired
	private ActivoAdapter activoAdapter;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET, value = "get")
	public ModelAndView getActivo(ModelMap model, @RequestParam(value = "data") String data) {
		try {
			JSONObject jsonData = JSONObject.fromObject(data);
			Activo actv = activoAdapter
					.getActivoById(new Long(((JSONObject) jsonData.get("data")).getString("idActivoBien")));
			model.put("data", actv);
		} catch (Exception e) {
			model.put("data", e);
		}
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET, value = "test/{dd}")
	public ModelAndView test(ModelMap model, @PathParam(value = "dd") String test) {
		model.put("data", test);
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "update")
	public ModelAndView updateActivo(ModelMap model) {

		model.put("data", "hola update");
		return new ModelAndView("jsonView", model);
	}

}
