package es.pfsgroup.plugin.recovery.config.delegaciones.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.config.delegaciones.api.DelegacionApi;
import es.pfsgroup.plugin.recovery.config.delegaciones.dao.DelegacionDao;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionFiltrosBusquedaDto;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;

@Controller
public class DelegacionTareasController {

	

	private static final String VIEW_CREAR_DELEGACION_TAREA = "plugin/config/delegacionTareas/delegacionTareas";
	private static final String VIEW_HISTORICO_DELEGACIONES = "plugin/config/delegacionTareas/historicoDelegaciones";
	private static final String HISTORICO_DELEGACIONES_JSON = "plugin/config/delegacionTareas/listadoDelegacionesJSON";
	private static final String TIPO_USUARIO_PAGINATED_JSON = "plugin/coreextension/asunto/tipoUsuarioPaginatedJSON";
	private static final String VIEW_DEFAULT = "default";
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private DelegacionApi delegacionApi;
	
	@Autowired
	private DelegacionDao delegacionDao;
	
	@Autowired
	private coreextensionApi coreextensionApi;
	
	@Autowired
	private UsuarioDao usuarioDao;

    
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevaDelegacion(ModelMap map) {

		map.put("userNameOrigen", usuarioManager.getUsuarioLogado().getApellidoNombre());
		map.put("idUserOrigen", usuarioManager.getUsuarioLogado().getId());
		
		return VIEW_CREAR_DELEGACION_TAREA;
	}
	
	@RequestMapping
	public String createOrUpdateDelegacion(ModelMap map, DelegacionDto dto) {
		
		delegacionApi.saveOrUpdateDelegacion(dto);

		return VIEW_DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String historicoDelegaciones(ModelMap map) {

		map.put("userNameOrigen", usuarioManager.getUsuarioLogado().getApellidoNombre());
		map.put("idUserOrigen", usuarioManager.getUsuarioLogado().getId());
		
		return VIEW_HISTORICO_DELEGACIONES;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaDelegaciones(ModelMap map, DelegacionFiltrosBusquedaDto dto) {
		
		map.put("pagina", delegacionApi.getListDelegaciones(dto));

		return HISTORICO_DELEGACIONES_JSON;
	}
	
	@RequestMapping
	public String borrarDelegacion(ModelMap map, Long idDelegacion) {
		
		delegacionApi.borrarDelegacion(idDelegacion);

		return VIEW_DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editDelegacion(ModelMap map, Long idDelegacion) {

		map.put("userNameOrigen", usuarioManager.getUsuarioLogado().getApellidoNombre());
		map.put("idUserOrigen", usuarioManager.getUsuarioLogado().getId());
		map.put("idDelegacion", idDelegacion);
		map.put("delegacion", delegacionApi.convertDelegacionTODelegacionDto(delegacionDao.get(idDelegacion)));
		
		return VIEW_CREAR_DELEGACION_TAREA;
	}
	
	/**
	 * Controlador que devuelve un JSON con la lista de usuarios 
	 * @param model
	 * @param UsuarioDto 
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListAllUsersPaginated(ModelMap model, Long idUsuario, UsuarioDto usuarioDto){
	
		if(!Checks.esNulo(idUsuario)){
			List<Usuario> user = new ArrayList<Usuario>();
			user.add(usuarioDao.get(idUsuario));
			PageSql page = new PageSql();
			page.setResults(user);
			page.setTotalCount(user.size());
			model.put("pagina", page);
		}else{
			Page page = coreextensionApi.getListAllUsersPaginated(usuarioDto);
			model.put("pagina", page);
		}

		return TIPO_USUARIO_PAGINATED_JSON;
	}
	
}
