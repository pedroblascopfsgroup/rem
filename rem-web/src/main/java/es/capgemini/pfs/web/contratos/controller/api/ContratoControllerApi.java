package es.capgemini.pfs.web.contratos.controller.api;

import org.springframework.ui.ModelMap;
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

	String getEfectos(Long idContrato, WebRequest request, ModelMap model);
	
}
