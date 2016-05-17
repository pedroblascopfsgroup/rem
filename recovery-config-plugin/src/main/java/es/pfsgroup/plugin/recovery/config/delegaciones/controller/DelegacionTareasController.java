package es.pfsgroup.plugin.recovery.config.delegaciones.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.plugin.recovery.config.delegaciones.api.DelegacionApi;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionDto;

@Controller
public class DelegacionTareasController {

	

	private static final String VIEW_CREAR_DELEGACION_TAREA = "plugin/config/delegacionTareas/delegacionTareas";
	private static final String VIEW_DEFAULT = "default";
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private DelegacionApi delegacionApi;

    
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevaDelegacion(ModelMap map) {

		map.put("userNameOrigen", usuarioManager.getUsuarioLogado().getApellidoNombre());
		map.put("idUserOrigen", usuarioManager.getUsuarioLogado().getId());
		
		return VIEW_CREAR_DELEGACION_TAREA;
	}
	
	@RequestMapping
	public String crearDelegacion(ModelMap map, DelegacionDto dto) {
		
		delegacionApi.saveDelegacion(dto);

		return VIEW_DEFAULT;
	}
	
}
