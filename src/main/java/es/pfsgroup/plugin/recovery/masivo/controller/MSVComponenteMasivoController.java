package es.pfsgroup.plugin.recovery.masivo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVComponenteMasivoApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResultadoOperacionMasivaDto;


@Controller
public class MSVComponenteMasivoController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String operacionMasiva(WebRequest request,ModelMap map){
		
		List<Long> ids= (List<Long>) Conversiones.createLongCollection(request.getParameter("lista"), ",");
		
		MSVResultadoOperacionMasivaDto resultado = proxyFactory.proxy(MSVComponenteMasivoApi.class).ejecutaOperacionMasiva(ids, request.getParameter("nombre"), request);
		
		map.put("resultado", resultado);
		
		//return "default";
		return "plugin/masivo/resultadoOperacionMasivaJSON";
	}

}
