package es.pfsgroup.plugin.precontencioso.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PrecontenciosoController {

	private static final String DEFAULT = "default";

	@RequestMapping
	public String testPrecontencioso(ModelMap model) {
		return DEFAULT;
	}
}