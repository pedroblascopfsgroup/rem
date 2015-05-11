package es.pfsgroup.plugin.recovery.coreextension;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;

//FIXME Hay que eliminar esta clase o renombrarla
//No a�adir nueva funcionalidad
@Controller
public class coreextensionController {

	private static final String TIPO_GESTOR_JSON = "plugin/coreextension/asunto/tipoGestorJSON";
	private static final String TIPO_DESPACHO_JSON = "plugin/coreextension/asunto/tipoDespachoJSON";
	private static final String TIPO_USUARIO_JSON = "plugin/coreextension/asunto/tipoUsuarioJSON";
	private static final String TIPO_USUARIO_PAGINATED_JSON = "plugin/coreextension/asunto/tipoUsuarioPaginatedJSON";
	private static final String GESTORES_ADICIONALES_JSON = "plugin/coreextension/multigestor/multiGestorAdicionalDataJSON";
	
	@Autowired
	public ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoGestorData(@RequestParam(value="ugCodigo",required = true)String ugCodigo, ModelMap model){
		
		List<EXTDDTipoGestor> listadoGestores = proxyFactory.proxy(coreextensionApi.class).getList(ugCodigo);
		model.put("listadoGestores", listadoGestores);
		
		return TIPO_GESTOR_JSON;
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
			@RequestParam(value="procuradorAdicional", required=false) Boolean procuradorAdicional){
		
		List<DespachoExterno> listadoDespachos = null;
		
		if (porUsuario==null) porUsuario = false;
		if (adicional==null) adicional = false;
		if (procuradorAdicional==null) procuradorAdicional = false;

		// POR USUARIO
		if (porUsuario) {
			Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListDespachosDeUsuario(idTipoGestor, usuario.getId(), adicional, procuradorAdicional);
		} else {
			listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListDespachos(idTipoGestor);
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
	public String getListUsuariosData(ModelMap model, Long idTipoDespacho){
		
		List<Usuario> listadoUsuarios = proxyFactory.proxy(coreextensionApi.class).getListUsuariosData(idTipoDespacho);
		model.put("listadoUsuarios", listadoUsuarios);
		
		return TIPO_USUARIO_JSON;
	}
	
	/**
	 * Controlador que devuelve un JSON con la lista de usuarios para un tipo de despacho. 
	 * Soporta paginaci�n y b�squeda.
	 * 
	 * @param model
	 * @param idTipoDespacho id del despacho. {@link DespachoExterno}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosPaginatedData(ModelMap model, UsuarioDto usuarioDto){
		
		Page page = proxyFactory.proxy(coreextensionApi.class).getListUsuariosPaginatedData(usuarioDto);
		model.put("pagina", page);
				
		return TIPO_USUARIO_PAGINATED_JSON;
	}
	
	/**
	 * Controlador que devuelve un JSON con la lista de gestores de un asunto, as� como el hist�rico de cambios. 
	 * Los datos se obtienen de {@link EXTGestorAdicionalAsuntoHistorico}
	 * 
	 * @param model
	 * @param idAsunto id del asunto. {@link Asunto}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListGestoresAdicionalesHistoricoData(ModelMap model, Long idAsunto){
		
		List<EXTGestorAdicionalAsuntoHistorico> listadoGestoresAdicionales = proxyFactory.proxy(coreextensionApi.class).getListGestorAdicionalAsuntoHistoricosData(idAsunto);
		model.put("listaGestoresAdicionales", listadoGestoresAdicionales);
		
		return GESTORES_ADICIONALES_JSON;
	}
	
	@RequestMapping
	public String insertarGestor(Long idTipoGestor, Long idAsunto, Long idUsuario) throws Exception{
		
		boolean existe = proxyFactory.proxy(EXTMultigestorApi.class).existeTipoGestor(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, idAsunto, idTipoGestor, idUsuario);
		
		if(!existe)
			proxyFactory.proxy(coreextensionApi.class).insertarGestor(idTipoGestor,idAsunto,idUsuario);
		else
			throw new Exception("Ya existe un gestor de ese tipo");
		
		return "default";
	}
	
	/**
	 * Controlador que inserta un gestor en la tabla de gestores adicionales del asunto {@link EXTGestorAdicionalAsunto}.
	 * Tambi�n se guada el hist�rico de cambios en {@link EXTGestorAdicionalAsuntoHistorico} 
	 * 
	 * @param idTipoGestor id del tipo de gestor, {@link EXTDDTipoGestor}
	 * @param idAsunto id del {@link Asunto}
	 * @param idUsuario id del {@link Usuario}
	 * @param idTipoDespacho id del tipo de despacho, {@link GestorDespacho}
	 * @return
	 * @throws Exception
	 */
	@RequestMapping
	public String insertarGestorAdicionalAsuto(Long idTipoGestor, Long idAsunto, Long idUsuario, Long idTipoDespacho) throws Exception{
		
		proxyFactory.proxy(coreextensionApi.class).insertarGestorAdicionalAsunto(idTipoGestor,idAsunto,idUsuario, idTipoDespacho);
		return "default";
	}
	
	@RequestMapping
	public String removeGestor(String id, Long idAsunto) throws Exception{
		
		String[] idCompuesto = id.split("_");
		Long idUsuario = Long.parseLong(idCompuesto[0]);
		String codTipoGestor = idCompuesto[1];
		
		proxyFactory.proxy(coreextensionApi.class).removeGestor(idAsunto, idUsuario, codTipoGestor);
		
		
		return "default";
	}
	
	

	public void setGenericDao(GenericABMDao genericDao) {
		this.genericDao = genericDao;
	}

	public GenericABMDao getGenericDao() {
		return genericDao;
	}
}
