package es.pfsgroup.plugin.recovery.ayuda;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AyudaController {

	@RequestMapping
	public String mostrar(@RequestParam(required = true) String item) {
		return "plugin/ayuda/helpPanel";
	}
	
	@RequestMapping
	public String html(@RequestParam(required = true) String item) {
		item = item.replaceAll("\\.", "");
		item = item.replaceAll("/", "");
		item = item.replaceAll(";", "");
		return "plugin/ayuda/" + item + "/index";
	}
}
