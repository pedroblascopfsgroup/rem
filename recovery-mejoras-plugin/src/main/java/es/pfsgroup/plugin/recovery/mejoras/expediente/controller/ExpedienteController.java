package es.pfsgroup.plugin.recovery.mejoras.expediente.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.plugin.recovery.mejoras.expediente.MEJExpedienteApi;

@Controller
public class ExpedienteController {

	static final String JSON_LISTADO_ZONAS = "plugin/mejoras/expedientes/listadoZonasJSON";

	@Autowired
	private MEJExpedienteApi mejExpedienteApi;
	
	@Autowired
	private UsuarioManager usuarioManager;

	/**
	 * Obtiene la lista de Contratos asociados aun asunto.
	 * 
	 * @param idAsunto
	 *            el id del asunto
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getZonasInstant(Integer idJerarquia, String query, ModelMap model) {
		List<DDZona> zonas = mejExpedienteApi.getZonasJerarquiaByCodDesc(idJerarquia, query);
		model.put("zonas", zonas);
		return JSON_LISTADO_ZONAS;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String paginaInicio(String comboEntidad, ModelMap model) {
		usuarioManager.cambiarEntidadUsuarioLogado(comboEntidad);
		Usuario usu = usuarioManager.cambiarEntidadBaseDatos(comboEntidad);
		model.put("usuario", usu);
		return "plugin/mejoras/main/main";
	}
}
