package es.pfsgroup.plugin.recovery.config.despachoExterno.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMDespachoExternoManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMUsuarioDao;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao;

@Controller
public class ADMDespachoExternoController {
	
	static final String JSON_LISTADO_USUARIOS = "plugin/config/despachoExterno/listadoGestoresJSON";
	static final String JSON_LISTADO_DESPACHOS = "plugin/config/despachoExterno/listadoDespachosSinAsociarJSON";
	
	private static final String TIPO_GESTOR_JSON = "plugin/config/usuarios/tipoGestorJSON";
	private static final String TIPO_DESPACHO_JSON = "plugin/config/usuarios/tipoDespachoJSON";
	private static final String TIPO_USUARIO_JSON = "plugin/config/usuarios/tipoUsuarioJSON";
	
	private static final String DEFAULT = "default";

    @Autowired
    private ADMUsuarioDao admUsuarioDao;
    
    @Autowired
    private GenericABMDao genericDao;
    
	@Autowired
	private EXTGestoresDao extGestoresDao;
	
	@Autowired
	private GestorDespachoDao gestorDao;
	
	@Autowired
	private ADMDespachoExternoManager despachoManager;
	
	@Autowired
	private DespachoExternoDao despachoDao;
	
	@Autowired
	private ADMDespachoExternoDao admDespachoDao;
	
	@Autowired
	public ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getUsuariosInstant(Integer idDespacho, String query, ModelMap model) {

		List<Usuario> listaUsuarios = admUsuarioDao.getListByExternosAndNombre(query);
		List<Usuario> listaUsuariosExistentes = extGestoresDao.getGestoresByDespacho(idDespacho);
		
		listaUsuarios.removeAll(listaUsuariosExistentes);
		model.put("listaGestoresExternos", listaUsuarios);
		
		return JSON_LISTADO_USUARIOS;
	}
	
	@RequestMapping
	public String guardarGestores(Integer id, String listaUsuariosId, ModelMap model) {
		String[] idUsuarios = listaUsuariosId.split(",");
		
		for(int i = 0; i < idUsuarios.length;i++) {
			despachoManager.guardarGestorDespacho(this.rellenarGestor(Long.parseLong(id.toString()), Long.parseLong(idUsuarios[i])));
		}
		
		return DEFAULT;
	}
	
	private GestorDespacho rellenarGestor(Long idDespacho, Long idUsuario) {
		GestorDespacho gestor = new GestorDespacho();
		
		gestor.setDespachoExterno(genericDao.get(DespachoExterno.class, genericDao.createFilter(FilterType.EQUALS, "id", idDespacho)));
		gestor.setUsuario(genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", idUsuario)));
		gestor.setGestorPorDefecto(false);
		gestor.setSupervisor(false);
		
		return gestor;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDespachosInstant(String idUsuario, String query, ModelMap model) {
		
		List<DespachoExterno> listaDespachos = admDespachoDao.getListByNombre(query);
		List<DespachoExterno> listaDespachosAsociados = despachoDao.getDespachosAsociadosAlUsuario(Long.parseLong(idUsuario));
		
		//Borramos los ya existentes
		listaDespachos.removeAll(listaDespachosAsociados);
		model.put("listaDespachos", listaDespachos);
		
		return JSON_LISTADO_DESPACHOS;
	}

	@RequestMapping
	public String guardaDespachoAsociados(Integer id, String listadoDespachosId, ModelMap model) {
		if(!Checks.esNulo(id) && !Checks.esNulo(listadoDespachosId)) {
			String[] arrayDespachos = listadoDespachosId.split(",");
			for(int i = 0; i< arrayDespachos.length; i++) {
				despachoManager.guardarGestorDespacho(this.rellenarGestor(Long.parseLong(arrayDespachos[i]), Long.parseLong(id.toString())));
			}
		}
		
		return DEFAULT;
	}
	
	
	/**
	 * Controlador que devuelve un JSON con la lista de tipos de gestores de la tabla DD_TGE_TIPO_GESTOR 
	 * @param model
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoGestorAdicionalData(ModelMap model, 
			@RequestParam(value="porUsuario", required=false) Boolean porUsuario,
			@RequestParam(value="adicional", required=false) Boolean adicional,
			@RequestParam(value="procuradorAdicional", required=false) Boolean procuradorAdicional){
		
		List<EXTDDTipoGestor> listadoGestores = null;
		if (porUsuario==null) porUsuario = false;
		if (adicional==null) adicional = false;
		if (procuradorAdicional==null) procuradorAdicional = false;

		// POR USUARIO
		if (porUsuario) {
			Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			listadoGestores = proxyFactory.proxy(coreextensionApi.class).getListTipoGestorDeUsuario(usuario.getId(), adicional, procuradorAdicional);
		} else {
			listadoGestores = proxyFactory.proxy(coreextensionApi.class).getListTipoGestorAdicional();
		}
		//////
		
		model.put("listadoGestores", listadoGestores);
		return TIPO_GESTOR_JSON;
	}
	
	
	/**
	 * Controlador que devuelve un JSON con la lista de despachos para un tipo de gestor dado.
	 *  
	 * @param model
	 * @param idTipoGestor id del tipo de gestor. {@link EXTDDTipoGestor}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoDespachoData(ModelMap model, Long idTipoGestor, 
			@RequestParam(value="porUsuario", required=false) Boolean porUsuario,
			@RequestParam(value="adicional", required=false) Boolean adicional,
			@RequestParam(value="procuradorAdicional", required=false) Boolean procuradorAdicional,
			@RequestParam(value="incluirBorrados", required=false) Boolean incluirBorrados){
		
		List<DespachoExterno> listadoDespachos = null;
		
		if (porUsuario==null) porUsuario = false;
		if (adicional==null) adicional = false;
		if (procuradorAdicional==null) procuradorAdicional = false;
		if (incluirBorrados==null) incluirBorrados = false;
		
		// POR USUARIO
		if (porUsuario) {
			Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListDespachosDeUsuario(idTipoGestor, usuario.getId(), adicional, procuradorAdicional);
		} else {
			listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListAllDespachos(idTipoGestor, incluirBorrados);
		}
		//////
		
		model.put("listadoDespachos", listadoDespachos);
		return TIPO_DESPACHO_JSON;
	}
	
	/**
	 * Controlador que devuelve un JSON con la lista de usuarios para un tipo de despacho. 
	 * 
	 * @param model
	 * @param idTipoDespacho id del despacho. {@link DespachoExterno}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosData(ModelMap model, Long idTipoDespacho,
			@RequestParam(value="incluirBorrados", required=false) Boolean incluirBorrados){
		
		incluirBorrados = incluirBorrados != null ? incluirBorrados : false;
		
		List<Usuario> listadoUsuarios = proxyFactory.proxy(coreextensionApi.class).getListAllUsuariosData(idTipoDespacho, incluirBorrados);
		model.put("listadoUsuarios", listadoUsuarios);
		
		return TIPO_USUARIO_JSON;
	}
}
