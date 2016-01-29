package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.sidhiweb.api.SIDHIIterJudicialApi;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;


@Controller
public class SIDHIInfoJudicialController {
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String getInfoJudicialAsunto(WebRequest request, ModelMap map){
		SIDHIDtoBuscarAcciones dto = mapeaDto(request);
		Page acciones = proxyFactory.proxy(SIDHIIterJudicialApi.class).getIterJudicialAsunto(dto);
		map.put("acciones", acciones);
		
		return "plugin/sidhiweb/generico/tabInfoJudicialJSON";
	}
	
	@RequestMapping
	public String getInfoJudicialExpediente(WebRequest request, ModelMap map){
		SIDHIDtoBuscarAcciones dto = mapeaDtoExp(request);
		Page acciones =  proxyFactory.proxy(SIDHIIterJudicialApi.class).getIterJudicialExpediente(dto);
		map.put("acciones", acciones);
		
		return "plugin/sidhiweb/generico/tabInfoJudicialJSON";
		
	}

	private SIDHIDtoBuscarAcciones mapeaDtoExp(WebRequest request) {
SIDHIDtoBuscarAcciones dto = new SIDHIDtoBuscarAcciones();
		
		dto.setLimit(new Integer(request.getParameter("limit")));
		dto.setStart(new Integer(request.getParameter("start")));
		dto.setSort("fechaAccion");
		dto.setDir("DESC");
		dto.setIdExpediente(Long.parseLong(request.getParameter("id")));

		return dto;
	}

	private SIDHIDtoBuscarAcciones mapeaDto(WebRequest request) {
		SIDHIDtoBuscarAcciones dto = new SIDHIDtoBuscarAcciones();
		dto.setLimit(new Integer(request.getParameter("limit")));
		dto.setStart(new Integer(request.getParameter("start")));
		dto.setSort("fechaAccion");
		dto.setDir("DESC");
		dto.setIdAsunto(Long.parseLong(request.getParameter("id")));

		return dto;
	}

}
