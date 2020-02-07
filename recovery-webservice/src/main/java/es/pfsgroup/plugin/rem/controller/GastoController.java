package es.pfsgroup.plugin.rem.controller;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import es.pfsgroup.commons.utils.Checks;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GastoController {

	protected static final Log logger = LogFactory.getLog(GastoController.class);
	private static final String ERROR_GASTO_NOT_EXISTS = "No existe el gasto que esta buscando, pruebe con otro Nº de Activo";
	private static final String ERROR_GASTO_NO_NUMERICO = "El campo introducido es de carácter numérico";
	private static final String ERROR_GENERICO = "La operación no se ha podido realizar";

	@Autowired
	private GastoApi gastoApi;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListGastos(DtoGastosFilter dtoGastosFilter, ModelMap model) {
		try {
			DtoPage page = gastoApi.getListGastos(dtoGastosFilter);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en GastoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	private ModelAndView createModelAndViewJson(ModelMap model) {
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getGastoExists(String numGasto, ModelMap model) {

		try {
			Long idGasto = gastoApi.getGastoExists(Long.parseLong(numGasto));

			if(!Checks.esNulo(idGasto)) {
				model.put("success", true);
				model.put("data", idGasto);
			}else {
				model.put("success", false);
				model.put("error", ERROR_GASTO_NOT_EXISTS);
			}
		} catch (NumberFormatException e) {
			model.put("success", false);
			model.put("error", ERROR_GASTO_NO_NUMERICO);
		} catch(Exception e) {
			logger.error("error obteniendo el activo ",e);
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}
		return createModelAndViewJson(model);
	}
}
