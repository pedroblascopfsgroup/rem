package es.pfsgroup.plugin.precontencioso.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PrecontenciosoController {

	private static final String DEFAULT = "default";
	private static final String PRECONTENCIOSO_TAB = "plugin/precontencioso/precontenciosoTab";

	@RequestMapping
	public String tab(ModelMap model) {
		return PRECONTENCIOSO_TAB;
	}
}