package es.pfsgroup.plugin.recovery.busquedaTareas.web;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;

import es.pfsgroup.commons.utils.web.dto.factory.DTOFactory;
import es.pfsgroup.plugin.recovery.busquedaTareas.BTABusquedaTareaManager;
import es.pfsgroup.plugin.recovery.busquedaTareas.dto.BTADtoBusquedaTareas;

@Controller
public class BTABusquedaTareasController {

	@Resource
	Properties appProperties;
	
    @Autowired
	private Executor executor;

    @Autowired
    private DTOFactory dtoFactory;

    @Autowired
    private BTABusquedaTareaManager btaBusquedaTareaManager;

    
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String busquedaTareas(WebRequest request, ModelMap model) {
    	
    	BTADtoBusquedaTareas dto;
	
		try {
			dto = dtoFactory.creaYRellenaDTO("busquedaTareas", request, BTADtoBusquedaTareas.class);
			
			// Llamada al manager
		   	Page page = (Page) btaBusquedaTareaManager.buscarTareas(dto);
			//Page page = (Page) executor.execute("plugin.busquedaTareas.BTABusquedaTareaManager.BuscarTareas", dto);
		   	
		   	model.put("tareas", page);
		   	
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    	
		
    	
    	return "plugin/busquedaTareas/BTAListadoTareasJSON";
    	
    }
    
    
    @SuppressWarnings("unchecked")
	@RequestMapping
    public String exportacionTareasCount(WebRequest request, ModelMap model) {
    	
    	BTADtoBusquedaTareas dto;
	
		try {
			dto = dtoFactory.creaYRellenaDTO("busquedaTareas", request, BTADtoBusquedaTareas.class);
			
			// Llamada al manager
		   	Integer count = (Integer) executor.execute("plugin.busquedaTareas.BTABusquedaTareaManager.BuscarTareasCount", dto);
		   	
		   	model.put("count", count);
	    	model.put("limit", appProperties.getProperty("exportar.excel.limite.busqueda.tareas"));
	    	
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
        return "plugin/busquedaTareas/BTAExportTareasCountJSON";
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String exportacionTareasPage(WebRequest request, ModelMap model) {
    	
    	BTADtoBusquedaTareas dto;
	
		try {
			dto = dtoFactory.creaYRellenaDTO("busquedaTareas", request, BTADtoBusquedaTareas.class);
			model.put("dto", dto);
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
        return "plugin/busquedaTareas/BTAListaTareasExcel";

    }
    
}
