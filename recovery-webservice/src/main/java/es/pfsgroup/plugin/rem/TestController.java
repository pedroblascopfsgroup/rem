package es.pfsgroup.plugin.rem;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TestController {

	@RequestMapping
	public String test(){
		
		
		return "default";
	}
}
