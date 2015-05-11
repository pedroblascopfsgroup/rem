package es.pfsgroup.plugin.recovery.masivo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.launcher.MSVCargaDocumentacionLauncherApi;


@Controller
public class MSVPruebasController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String iniciaProcesoCargaDocumentos(WebRequest request,ModelMap map){
		
//		String resultado = proxyFactory.proxy(MSVCargaDocumentacionLauncherApi.class).comenzarServicio();
		String resultado = proxyFactory.proxy(MSVCargaDocumentacionLauncherApi.class).ejecutarServicio("9999");
		
		map.put("resultado", resultado);
		
		return "default";
	}

	@RequestMapping
	public String pararProcesoCargaDocumentos(WebRequest request,ModelMap map){
		
//		proxyFactory.proxy(MSVCargaDocumentacionLauncherApi.class).detenerServicio();
		
		return "default";
	}

}
