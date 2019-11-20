package es.pfsgroup.plugin.rem.controller;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.api.FuncionesApi;
import es.pfsgroup.plugin.rem.api.PerfilApi;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;
import es.pfsgroup.plugin.rem.perfilAdministracion.dto.DtoPerfilAdministracionFilter;

@Controller
public class FuncionesController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(FuncionesController.class);
	
	@Autowired
	private FuncionesApi funcionesApi;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getFunciones(DtoFunciones funciones, ModelMap model) {
		List<DtoFunciones> resultados = funcionesApi.getFunciones(funciones);
		
		try {
			model.put("data", resultados);
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en FuncionesController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

}
