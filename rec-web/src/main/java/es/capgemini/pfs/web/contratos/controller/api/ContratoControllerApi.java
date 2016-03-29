package es.capgemini.pfs.web.contratos.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

public interface ContratoControllerApi {
	
	/**
	 * Obtiene los recibos del contrato
	 * @param request
	 * @param model
	 * @return
	 */
	
	String getRecibos(Long idContrato, WebRequest request, ModelMap model);
	
	String getDisposiciones(Long idContrato, WebRequest request, ModelMap model);

	String getEfectos(ModelMap model,
			@RequestParam(value = "idContrato", required = true)Long idContrato,
			@RequestParam(value = "limit", required = true) Integer limit,
			@RequestParam(value = "start", required = true) Integer start
			);	
}
