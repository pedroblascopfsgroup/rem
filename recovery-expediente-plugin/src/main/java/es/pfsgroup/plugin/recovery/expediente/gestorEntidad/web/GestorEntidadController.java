package es.pfsgroup.plugin.recovery.expediente.gestorEntidad.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;

/**
 * Controlador que atiende las peticiones de las pantallas de gestores
 * 
 */
@Controller
public class GestorEntidadController {

	static final String DEFAULT_JSON = "plugin/expediente/defaultJSON";

	private static final String TIPO_GESTOR_JSON = "plugin/coreextension/asunto/tipoGestorJSON";
	private static final String TIPO_DESPACHO_JSON = "plugin/coreextension/asunto/tipoDespachoJSON";
	private static final String TIPO_USUARIO_JSON = "plugin/coreextension/asunto/tipoUsuarioJSON";
	private static final String TIPO_USUARIO_PAGINATED_JSON = "plugin/coreextension/asunto/tipoUsuarioPaginatedJSON";
	private static final String GESTORES_ADICIONALES_JSON = "plugin/expediente/gestorEntidad/json/multiGestorAdicionalDataJSON";
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListGestoresAdicionalesHistoricoData(ModelMap model, GestorEntidadDto dto) {

		List<GestorEntidadHistorico> listadoGestoresAdicionales = proxyFactory.proxy(GestorEntidadApi.class).getListGestoresAdicionalesHistoricoData(dto);
		model.put("listaGestoresAdicionales", listadoGestoresAdicionales);

		return GESTORES_ADICIONALES_JSON;
	}

	/**
	 * Controlador que devuelve un JSON con la lista de tipos de gestores de la
	 * tabla DD_TGE_TIPO_GESTOR
	 * 
	 * @param model
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoGestorEntidadData(ModelMap model, GestorEntidadDto dto) {

		List<EXTDDTipoGestor> listadoGestores = proxyFactory.proxy(coreextensionApi.class).getListTipoGestorAdicional();
		model.put("listadoGestores", listadoGestores);

		return TIPO_GESTOR_JSON;
	}

	/**
	 * Controlador que devuelve un JSON con la lista de despachos para un tipo
	 * de gestor dado.
	 * 
	 * @param model
	 * @param idTipoGestor
	 *            id del tipo de gestor. {@link EXTDDTipoGestor}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListDespachosData(ModelMap model, Long idTipoGestor) {

		List<DespachoExterno> listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListDespachos(idTipoGestor);
		model.put("listadoDespachos", listadoDespachos);

		return TIPO_DESPACHO_JSON;
	}

	/**
	 * Controlador que devuelve un JSON con la lista de usuarios para un tipo de
	 * despacho.
	 * 
	 * @param model
	 * @param idTipoDespacho
	 *            id del despacho. {@link DespachoExterno}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosPaginatedData(ModelMap model, Long idTipoDespacho) {

		List<Usuario> listadoUsuarios = proxyFactory.proxy(coreextensionApi.class).getListUsuariosData(idTipoDespacho);
		model.put("listadoUsuarios", listadoUsuarios);

		return TIPO_USUARIO_JSON;
	}

	/**
	 * Controlador que devuelve un JSON con la lista de usuarios para un tipo de
	 * despacho. Soporta paginación y búsqueda.
	 * 
	 * @param model
	 * @param usuarioDto
	 *            dto con los paránmetro de filtrado. {@link UsuarioDto}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosPaginatedData(ModelMap model, UsuarioDto usuarioDto) {

		Page page = proxyFactory.proxy(coreextensionApi.class).getListUsuariosPaginatedData(usuarioDto);
		model.put("pagina", page);

		return TIPO_USUARIO_PAGINATED_JSON;
	}

	@RequestMapping
	public String insertarGestor(Long idTipoGestor, Long idAsunto, Long idUsuario) throws Exception {

		boolean existe = proxyFactory.proxy(EXTMultigestorApi.class).existeTipoGestor(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, idAsunto, idTipoGestor, idUsuario);

		if (!existe)
			proxyFactory.proxy(coreextensionApi.class).insertarGestor(idTipoGestor, idAsunto, idUsuario);
		else
			throw new Exception("Ya existe un gestor de ese tipo");

		return "default";
	}

	/**
	 * Controlador que inserta un gestor en la tabla de gestores adicionales del
	 * asunto {@link EXTGestorAdicionalAsunto}. También se guada el histórico de
	 * cambios en {@link EXTGestorAdicionalAsuntoHistorico}
	 * 
	 * @param idTipoGestor
	 *            id del tipo de gestor, {@link EXTDDTipoGestor}
	 * @param idAsunto
	 *            id del {@link Asunto}
	 * @param idUsuario
	 *            id del {@link Usuario}
	 * @param idTipoDespacho
	 *            id del tipo de despacho, {@link GestorDespacho}
	 * @return
	 * @throws Exception
	 */
	@RequestMapping
	public String insertarGestorAdicionalEntidad(GestorEntidadDto dto) throws Exception {

		proxyFactory.proxy(GestorEntidadApi.class).insertarGestorAdicionalEntidad(dto);
		return "default";
	}

	@RequestMapping
	public String removeGestor(GestorEntidadDto dto) throws Exception {

		proxyFactory.proxy(GestorEntidadApi.class).borrarGestorAdicionalEntidad(dto);

		return "default";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoGestorEditables(ModelMap model, Long idTipoGestor){
		
		List<EXTDDTipoGestor> listadoGestores = proxyFactory.proxy(GestorEntidadApi.class).getListTipoGestorEditables(idTipoGestor);
		model.put("listadoGestores", listadoGestores);
		
		return TIPO_GESTOR_JSON;
		
	}
	
}
