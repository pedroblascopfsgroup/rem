package es.pfsgroup.plugin.rem.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.PerfilApi;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.perfilAdministracion.dto.DtoPerfilAdministracionFilter;

@Controller
public class PerfilController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(PerfilController.class);
	
	@Autowired
	private PerfilApi perfilApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getPerfiles(DtoPerfilAdministracionFilter dtoPerfilFilter, ModelMap model) {
		try {
			List<DtoPerfilAdministracionFilter> resultados = perfilApi.getPerfiles(dtoPerfilFilter);

			model.put("data", resultados);
			if (!Checks.estaVacio(resultados)) {
				model.put("totalCount", resultados.get(0).getTotalCount());

			} else {
				model.put("totalCount", 0);
			}

			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en Perfil", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPerfilById(Long id, ModelMap model, HttpServletRequest request) {
		model.put("data", perfilApi.getPerfilById(id));
		model.put("success", true);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFuncionesByPerfilId(Long id, DtoPerfilAdministracionFilter dto, ModelMap model, HttpServletRequest request) {
		List<DtoPerfilAdministracionFilter> listado = perfilApi.getFuncionesByPerfilId(id, dto);
		model.put("data", listado);
		model.put("success", true);
		
		if(!listado.isEmpty()) {
			model.put("totalCount", listado.get(0).getTotalCount());
		} else {
			model.put("totalCount", 0);
		}
		

		return createModelAndViewJson(model);
	}
	
}