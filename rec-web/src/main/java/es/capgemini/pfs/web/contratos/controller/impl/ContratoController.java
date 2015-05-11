package es.capgemini.pfs.web.contratos.controller.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.web.contratos.controller.api.ContratoControllerApi;
import es.capgemini.pfs.web.utils.RecWebConstants.ContratoConstants;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ContratoApi;


@Controller
public class ContratoController implements ContratoControllerApi{

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
		
	/**
	 * {@inheritDoc} 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	@Override
	public String getRecibos(Long idContrato, WebRequest request, ModelMap model) {
		
		Page recibos = proxyFactory.proxy(ContratoApi.class).getRecibosContrato(idContrato);
		model.put("recibos", recibos);
		
		return ContratoConstants.RECWEB_CONTRATO_RECIBOS_JSON;
	}

	@RequestMapping
	@Override
	public String getDisposiciones(Long idContrato, WebRequest request,
			ModelMap model) {
		Page disposiciones = proxyFactory.proxy(ContratoApi.class).getDisposicionesContrato(idContrato);
		model.put("disposiciones", disposiciones);
		
		return ContratoConstants.RECWEB_CONTRATO_DISPOSICIONES_JSON;
	}

	@RequestMapping
	@Override
	public String getEfectos(Long idContrato, WebRequest request,
			ModelMap model) {
		Page efectos = proxyFactory.proxy(ContratoApi.class).getEfectosContrato(idContrato);
		model.put("efectos", efectos);
		
		return ContratoConstants.RECWEB_CONTRATO_EFECTOS_JSON;
	}

}
