package es.pfsgroup.plugin.recovery.uvem.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastasServicioTasacionDelegateApi;

@Controller
public class UvemController {
	
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String solicitarNumeroActivo(@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map){
		
		proxyFactory.proxy(SubastasServicioTasacionDelegateApi.class).solicitarNumeroActivo(idBien);
		return "default";
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String solicitarTasacion(@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map){
		
		proxyFactory.proxy(SubastasServicioTasacionDelegateApi.class).solicitarTasacion(idBien);
		return "default";
		
	}

}
