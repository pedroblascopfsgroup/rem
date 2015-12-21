package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.asunto.EditAsuntoDtoInfo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Controller
public class EditAsuntoController {
		
	@Autowired
	private AsuntoApi asuntoApi;
	
	

	@RequestMapping
	public String open(@RequestParam(value = "id", required = true) Long id, ModelMap map) {
				
		Asunto asunto = asuntoApi.get(id);
		map.put("asunto", asunto);
		
		return "plugin/mejoras/asuntos/formulario/editaNombreAsunto";
	}
	
	@RequestMapping
	public String save(@RequestParam(value = "id", required = true) final Long id,
			@RequestParam(value = "nombre", required = true) final String nombre) {
		
		EditAsuntoDtoInfo dto = new EditAsuntoDtoInfo() {
			
			@Override
			public String getNombre() {
				return nombre;
			}
			
			@Override
			public Long getId() {
				return id;
			}
		};;;
		
		
		asuntoApi.actualizaAsunto(dto);
		
		return "default";
	}

}
