package es.pfsgroup.recovery.geninformes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.geninformes.api.GENINFEmailsPendientesApi;

@Controller
public class GENINFEnvioCorreosController {

	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	/**
	 * Metodo que procesa los emails pendientes de envío.
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String procesaEmailsPendientes(ModelMap model) {

		apiProxyFactory.proxy(GENINFEmailsPendientesApi.class).procesarEmailsPendientes();

		return "default";
	}
	
}
