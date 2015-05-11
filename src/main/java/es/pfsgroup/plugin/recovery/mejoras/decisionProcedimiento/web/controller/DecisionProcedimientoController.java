package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJProcedimientoApi;

@Controller
public class DecisionProcedimientoController {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String desparalizarProcedimiento(Long idProcedimiento){
		proxyFactory.proxy(MEJProcedimientoApi.class).desparalizarProcedimiento(idProcedimiento);
		return "default";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isDesparalizable(Long idProcedimiento,ModelMap map){
		
		boolean res = proxyFactory.proxy(MEJProcedimientoApi.class).isDespararizable(idProcedimiento);
		map.put("isDesparalizable", res);
		return "plugin/mejoras/procedimientos/procedimientoDesparalizableJSON";
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String esTramiteSubastaByPrcId(Long prcId, ModelMap map){
		
		boolean res =  proxyFactory.proxy(MEJProcedimientoApi.class).esTramiteSubastaByPrcId(prcId);
		map.put("esTramiteSubasta", res);

		return "plugin/mejoras/procedimientos/procedimientoTSubastaJSON";
	}
	
}
