package es.pfsgroup.plugin.recovery.busquedaTareas.prorroga.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.prorroga.model.CausaProrroga;
import es.capgemini.pfs.prorroga.model.DDTipoProrroga;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.busquedaTareas.BTABusquedaTareaManager;
import es.pfsgroup.plugin.recovery.busquedaTareas.dto.BTADtoBusquedaTareas;
import es.pfsgroup.plugin.recovery.masivo.api.MSVComponenteMasivoApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResultadoOperacionMasivaDto;

@Controller
public class BTAAutoprorrogaMasivaController {
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private BTABusquedaTareaManager btaBusquedaTareaManager;
	
	@RequestMapping
	public String autoprorrogarTareas(WebRequest request, ModelMap map){

		String lista = request.getParameter("lista");
		String scope = request.getParameter("scope");
		String paramBusquedaJSON = request.getParameter("paramBusquedaJSON");
		
		@SuppressWarnings("unchecked")
		List<CausaProrroga> causas=(List<CausaProrroga>) executor.execute(InternaBusinessOperation.BO_PRORR_MGR_OBTENER_CAUSAS, DDTipoProrroga.TIPO_PRORROGA_EXTERNA);
		map.put("causas", causas);
		map.put("lista", lista);
		map.put("scope", scope);
		
		map.put("paramBusquedaJSON", paramBusquedaJSON.replace("&amp;", "&").replace("&quot;", "\""));
		
		return "plugin/busquedaTareas/generarAutoprorrogaMasiva";
	}
	
	@RequestMapping
	public String operacionProrrogaMasiva(BTADtoBusquedaTareas dtoParamBusqueda, WebRequest request,ModelMap map){
		List<Long> ids = new ArrayList<Long>();
		
		if ("ALL".equals(request.getParameter("scope"))) {
		
			List<TareaNotificacion> tareas = btaBusquedaTareaManager.buscarTareasParaExcel(dtoParamBusqueda);
			for (TareaNotificacion tareaNotificacion : tareas) {
				ids.add(tareaNotificacion.getId());
			}
		
		} else {
			ids = (List<Long>) Conversiones.createLongCollection(request.getParameter("lista"), ",");
		}
		
		MSVResultadoOperacionMasivaDto resultado = proxyFactory.proxy(MSVComponenteMasivoApi.class).ejecutaOperacionMasiva(ids, request.getParameter("nombre"), request);
		
		map.put("resultado", resultado);
		
		//return "default";
		return "plugin/masivo/resultadoOperacionMasivaJSON";
	}


}
