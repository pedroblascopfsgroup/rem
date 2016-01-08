//package es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc.controller;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.ModelMap;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.context.request.WebRequest;
//
//import es.capgemini.devon.pagination.Page;
//import es.pfsgroup.commons.utils.Checks;
//import es.pfsgroup.commons.utils.api.ApiProxyFactory;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.SIDHIAccionNoProcApi;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.hitoIter.SIDHIHitoIterApi;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
//
//@Controller
//public class SIDHIAccionesNoProcController {
//	
//	@Autowired
//	ApiProxyFactory proxyFactory;
//	
//	@RequestMapping
//	public String getAccionesNoProcAsunto(WebRequest request, ModelMap map){
//		SIDHIDtoBuscarAcciones dto = mapeaDto(request);
//		dto.setIdAsunto(Long.parseLong(request.getParameter("id")));
//		Page acciones = proxyFactory.proxy(SIDHIAccionNoProcApi.class).getAccionesNoProcAsunto(dto);
//		map.put("acciones", acciones);
//		
//		return "plugin/sidhiweb/generico/tabActuacionesNoProcJSON";
//	}
//	
//	@RequestMapping
//	public String getAccionesNoProcExpediente(WebRequest request, ModelMap map){
//		SIDHIDtoBuscarAcciones dto = mapeaDto(request);
//		dto.setIdExpediente(Long.parseLong(request.getParameter("id")));
//		Page acciones = proxyFactory.proxy(SIDHIAccionNoProcApi.class).getAccionesNoProcExpediente(dto);
//		map.put("acciones", acciones);
//		
//		return "plugin/sidhiweb/generico/tabActuacionesNoProcJSON";
//		
//	}
//	
//	@RequestMapping
//	public String getHitoExtraJudicialAsunto(WebRequest request, ModelMap map){
//		SIDHIDtoBuscarAcciones dto = mapeaDto(request);
//		dto.setIdAsunto(Long.parseLong(request.getParameter("id")));
//		Page hitos = proxyFactory.proxy(SIDHIHitoIterApi.class).getHitosAsunto(dto);
//		map.put("hitos", hitos);
//		
//		return "plugin/sidhiweb/generico/tabHitosIterJSON";
//	}
//	
//	@RequestMapping
//	public String getHitoExtraJudicialExpediente(WebRequest request, ModelMap map){
//		SIDHIDtoBuscarAcciones dto = mapeaDto(request);
//		dto.setIdExpediente(Long.parseLong(request.getParameter("id")));
//		Page hitos = proxyFactory.proxy(SIDHIHitoIterApi.class).getHitosExpediente(dto);
//		map.put("hitos", hitos);
//		return "plugin/sidhiweb/generico/tabHitosIterJSON";
//	}
//	
//	private SIDHIDtoBuscarAcciones mapeaDto(WebRequest request) {
//		SIDHIDtoBuscarAcciones dto = new SIDHIDtoBuscarAcciones();
//		dto.setLimit(new Integer(request.getParameter("limit")));
//		dto.setStart(new Integer(request.getParameter("start")));
////		if (Checks.esNulo(request.getParameter("sort"))){
////			dto.setSort("fechaAccion");
////			dto.setSort("idAccion");
////		}else{
////			dto.setSort(request.getParameter("sort"));
////			dto.setSort("idAccion");
////		}
//		if (Checks.esNulo(request.getParameter("sort"))){
//			dto.setDir("ASC");
//		}else{
//			dto.setDir(request.getParameter("dir"));
//		}
//
//		return dto;
//	}
//
//}
