package es.pfsgroup.plugin.recovery.coreextension;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.dto.DTOTerminosExcel;
import es.capgemini.pfs.acuerdo.dto.DTOTerminosFiltro;
import es.capgemini.pfs.acuerdo.dto.DTOTerminosResultado;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.model.Provisiones;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTDDTipoGestorApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

//FIXME Hay que eliminar esta clase o renombrarla
//No a�adir nueva funcionalidad
@Controller
public class coreextensionController {

	private static final String TIPO_GESTOR_JSON = "plugin/coreextension/asunto/tipoGestorJSON";
	private static final String TIPO_DESPACHO_JSON = "plugin/coreextension/asunto/tipoDespachoJSON";
	private static final String TIPO_USUARIO_JSON = "plugin/coreextension/asunto/tipoUsuarioJSON";
	private static final String TIPO_USUARIO_PAGINATED_JSON = "plugin/coreextension/asunto/tipoUsuarioPaginatedJSON";
	private static final String GESTORES_ADICIONALES_JSON = "plugin/coreextension/multigestor/multiGestorAdicionalDataJSON";
	private static final String OK_KO_RESPUESTA_JSON = "plugin/coreextension/OkRespuestaJSON";
	private static final String JSON_LIST_TIPO_PROCEDIMIENTO = "procedimientos/listadoTiposProcedimientoJSON";
	private static final String TIPO_USUARIO_DEFECTO_JSON = "plugin/coreextension/asunto/tipoUsuarioGestorDefectoJSON";
	private static final String GESTORES_DESPACHOS_USUARIO_AUTO_JSON = "plugin/coreextension/asunto/listadoUsuariosAutomaticosJSON";
	private static final String LISTADO_BUSQUEDA_TERMINOS_JSON = "plugin/coreextension/acuerdo/listadoTerminosJSON";
	private static final String JSON_LISTADO_DESPACHOS = "plugin/coreextension/acuerdo/listadoDespachosJSON";
	private static final String JSON_LISTADO_TIPOS_ACUERDO = "plugin/coreextension/acuerdo/listadoTiposAcuerdoJSON";
	private static final String JSON_CODIGO_NIVEL = "plugin/coreextension/listadoCodigoNivelJSON";
	private static final String JSON_LISTA_DICCIONARIO_GENERICO_LIST = "plugin/coreextension/diccionarioGenericoListJSON";

	@Autowired
	public ApiProxyFactory proxyFactory;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private CoreProjectContext coreProjectContext;
	
	@Autowired
    private Executor executor;

    @Autowired
	private EXTDDTipoGestorApi tipoGestorApi;

	@Autowired
	private coreextensionApi coreextensionApi;
    
    @Autowired
    private GestorAdicionalAsuntoApi gestorAdicionalApi;
    
    @Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;
    

    @Resource
    private MessageService messageService;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoGestorData(@RequestParam(value="ugCodigo",required = true)String ugCodigo, ModelMap model){
		
		List<EXTDDTipoGestor> listadoGestores = proxyFactory.proxy(coreextensionApi.class).getList(ugCodigo);
		model.put("listadoGestores", listadoGestores);
		
		return TIPO_GESTOR_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoGestorProponente(ModelMap model){
		
		List<EXTDDTipoGestor> listado = new ArrayList<EXTDDTipoGestor>();
		listado=proxyFactory.proxy(coreextensionApi.class).getListTipoGestorProponente();
		model.put("listadoGestores", listado);
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
			@RequestParam(value="procuradorAdicional", required=false) Boolean procuradorAdicional,
			@RequestParam(value="incluirBorrados", required=false) Boolean incluirBorrados,
			@RequestParam(value="idAsunto", required=false) Long idAsunto,
			@RequestParam(value="estadoLetrado", required=false) Boolean estadoLetrado){
		
		List<DespachoExterno> listadoDespachos = null;
		
		if (porUsuario==null) porUsuario = false;
		if (adicional==null) adicional = false;
		if (procuradorAdicional==null) procuradorAdicional = false;
		if (incluirBorrados==null) incluirBorrados = false;
		if (estadoLetrado==null) estadoLetrado = false;
		
		// POR USUARIO
		if (porUsuario) {
			Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListDespachosDeUsuario(idTipoGestor, usuario.getId(), adicional, procuradorAdicional);
		} else {
			listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListAllDespachos(idTipoGestor, incluirBorrados);
		}
		
		// PRODUCTO-1496 tenemos que ver si nos encontramos en HAYA-CAJAMAR. En
		// ese caso, mostramos solo los despachos de procuradores que sirven,
		// para ello usaremos el coreProjectContext
		String codEntidad = usuarioManager.getUsuarioLogado().getEntidad().getCodigo();
		EXTDDTipoGestor tipoGestor = tipoGestorApi.getByCod("PROC");

		Map<String, List<String>> despachosProcuradores = coreProjectContext.getDespachosProcuradores();
		if (despachosProcuradores.containsKey(codEntidad) && !Checks.esNulo(tipoGestor) && tipoGestor.getId().equals(idTipoGestor)) {

			// PRODUCTO-1969 Además, si el asunto NO tiene CENTROPROCURA
			// asignado, debemos mostrar TODOS los despachos
			List<Usuario> usu;
			String codigoGestor = null;
			EXTDDTipoGestor tipoGestorCentroProcura = tipoGestorApi.getByCod("CENTROPROCURA");
			if (!Checks.esNulo(tipoGestorCentroProcura)) {
				codigoGestor = tipoGestorCentroProcura.getCodigo();
			}
			usu = gestorAdicionalApi.findGestoresByAsunto(idAsunto, codigoGestor);
			Iterator<DespachoExterno> iter = listadoDespachos.iterator();
			List<String> despachosValidos = despachosProcuradores.get(codEntidad);
			if (!Checks.estaVacio(usu)) {
				while (iter.hasNext()) {
					if (!despachosValidos.contains(iter.next().getDespacho())) {
						iter.remove();
					}
				}
			}
		}
				
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
	
	/**
	 * Controlador que devuelve un JSON con la lista de usuarios, despachos y tipo de gestores para un tipo de asunto. 
	 * 
	 * @param model
	 * @param idTipoDespacho id del despacho. {@link DespachoExterno}
	 * @return JSON
	 */
	@SuppressWarnings({ "unchecked" })
	@RequestMapping
	public String getListUsuariosDefectoByTipoAsunto(ModelMap model,String idTipoAsunto, String idExpediente,
			@RequestParam(value="porUsuario", required=false) Boolean porUsuario,
			@RequestParam(value="adicional", required=false) Boolean adicional,
			@RequestParam(value="procuradorAdicional", required=false) Boolean procuradorAdicional){
		
		List<EXTDDTipoGestor> listadoTipoGestores = null;
		List<DespachoExterno> listaDespachos = null;
		List<DespachoExterno> listaDespachos2 = new ArrayList<DespachoExterno>();;
		List<Usuario> listaUsuarios= null;
		List<EXTDDTipoGestor> listadoTipoGestoresFinal= new ArrayList<EXTDDTipoGestor>();
		List<DespachoExterno> listaDespachoFinal= new ArrayList<DespachoExterno>();
		List<Usuario> listaUsuariosFinal= new ArrayList<Usuario>();
		listadoTipoGestores= proxyFactory.proxy(coreextensionApi.class).getListTipoGestorAdicionalPorAsunto(idTipoAsunto);
		String codigoEntidadUsuario= usuarioManager.getUsuarioLogado().getEntidad().getCodigo();
		
		for(EXTDDTipoGestor tipoGestor: listadoTipoGestores){
			if(tipoGestor!=null){
				listaDespachos = proxyFactory.proxy(coreextensionApi.class).getListAllDespachos(tipoGestor.getId(), false);
				if(listaDespachos!=null && listaDespachos.size()>0){
					listaDespachos2.clear();
					listaDespachos2.add(listaDespachos.get(0));
				}
				for(DespachoExterno despacho: listaDespachos2){
					listaUsuarios=null;
					listaUsuarios = proxyFactory.proxy(coreextensionApi.class).getListAllUsuariosPorDefectoData(despacho.getId(), false);
					if(listaUsuarios== null || listaUsuarios.size()==0){
						List<Usuario> listaUsuariosNoDefecto= proxyFactory.proxy(coreextensionApi.class).getListAllUsuariosData(despacho.getId(), false);
						if(listaUsuariosNoDefecto!= null && listaUsuariosNoDefecto.size()!=0){
							listaUsuarios.add(proxyFactory.proxy(coreextensionApi.class).getListAllUsuariosData(despacho.getId(), false).get(0));
						}
					}
					HashMap<String,Set<String>> perfilesMap= proxyFactory.proxy(coreextensionApi.class).getListPerfilesGestoresEspeciales(codigoEntidadUsuario);
					if(perfilesMap!=null && !perfilesMap.isEmpty() && Integer.parseInt(idTipoAsunto)==21){
						Set<String> perfiles= perfilesMap.get(tipoGestor.getCodigo());
						if(perfiles!=null && !perfiles.isEmpty()){
							for(String perfil: perfiles){
								Usuario usuarioFinal= new Usuario();
								long idexp= Long.valueOf(idExpediente);
								List<Usuario> usuarioFinales= proxyFactory.proxy(coreextensionApi.class).getUsuarioGestorOficinaExpedienteGestorDeuda(idexp, perfil);
								if(!usuarioFinales.isEmpty()){
									usuarioFinal= usuarioFinales.get(0); 
									listadoTipoGestoresFinal.add(tipoGestor);
									listaDespachoFinal.add(despacho);
									listaUsuariosFinal.add(usuarioFinal);
								}
							}
						}
						else{
							for(Usuario usuario: listaUsuarios){
								
								Usuario usuarioFinal= new Usuario();
									usuarioFinal= usuario;
									listadoTipoGestoresFinal.add(tipoGestor);
									listaDespachoFinal.add(despacho);
									listaUsuariosFinal.add(usuarioFinal);
							}
						}
					}
					else{
						if(listaUsuarios!= null && listaUsuarios.size()!=0){
							for(Usuario usuario: listaUsuarios){
								
								Usuario usuarioFinal= new Usuario();
									usuarioFinal= usuario;
									listadoTipoGestoresFinal.add(tipoGestor);
									listaDespachoFinal.add(despacho);
									listaUsuariosFinal.add(usuarioFinal);
							}
						}
					}
				}
			}
		}
		
		//Supervisores
		if(codigoEntidadUsuario.equals("HAYA")){
			Usuario supervisor= proxyFactory.proxy(coreextensionApi.class).getSupervisorPorAsuntoEntidad(codigoEntidadUsuario, idTipoAsunto);
			EXTDDTipoGestor tipoGestorSupervisor= proxyFactory.proxy(coreextensionApi.class).getTipoGestorSupervisorPorAsuntoEntidad(codigoEntidadUsuario, idTipoAsunto);
			DespachoExterno despachoGestorSupervisor= proxyFactory.proxy(coreextensionApi.class).getDespachoSupervisorPorAsuntoEntidad(codigoEntidadUsuario, idTipoAsunto);
			
			if(supervisor!= null && tipoGestorSupervisor!= null && despachoGestorSupervisor!= null){
				listadoTipoGestoresFinal.add(tipoGestorSupervisor);
				listaDespachoFinal.add(despachoGestorSupervisor);
				listaUsuariosFinal.add(supervisor);
			}
			
			
			
		}
		
		
		model.put("listadoGestores", listadoTipoGestoresFinal);
		model.put("listadoDespachos", listaDespachoFinal);
		model.put("listadoUsuarios", listaUsuariosFinal);
		
		return GESTORES_DESPACHOS_USUARIO_AUTO_JSON;
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
	
	/**
	 * Comprueba si el procurador asociado al asunto tiene provisiones 
	 * 
	 * @param idAsunto
	 * @return String
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isProcuradorConProvisiones(Long idAsunto
			, WebRequest request, ModelMap model) throws Exception{
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		Provisiones prov = genericDao.get(Provisiones.class, genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		//Es un usuario Procurador Con provisiones
		if (Checks.esNulo(asu) || Checks.esNulo(prov)){
			model.put("okko",(String)"KO");
		}else{
			if ( (Checks.esNulo(prov.getFechaBaja())) && (asu.getProcurador() != null ) ){
				model.put("okko","OK");
			}else{
				model.put("okko","KO");
			}
		}
		return OK_KO_RESPUESTA_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoProcedimientosPorTipoActuacionByPropiedadAsunto(ModelMap model, String codigoTipoAct, Long prcId) {
		
		List<TipoProcedimiento> list = proxyFactory.proxy(coreextensionApi.class).getListTipoProcedimientosPorTipoActuacionByPropiedadAsunto(codigoTipoAct, prcId);
		model.put("listado", list);
		
		return JSON_LIST_TIPO_PROCEDIMIENTO;
	}
	
	/**
	 * Controlador que devuelve un JSON con la lista de usuarios para un tipo de despacho, donde se tiene
	 * en cuenta si existe un gestor por Defecto de dicho despacho.
	 * @param model
	 * @param idTipoDespacho id del despacho. {@link DespachoExterno}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosDefectoPaginatedData(ModelMap model, UsuarioDto usuarioDto){
		
		Page page = proxyFactory.proxy(coreextensionApi.class).getListUsuariosDefectoPaginatedData(usuarioDto);
		model.put("pagina", page);
		
		return TIPO_USUARIO_DEFECTO_JSON;
	}
	
	/**
	 * Controlador que devuelve un JSON con la lista de acuerdos en base a los filtros utilizados en el buscador de acuerdos
	 * @param model
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String listBusquedaAcuerdos(ModelMap model, DTOTerminosFiltro terminosFiltroDto){
		
		//Si en la pestaña de jerarquía hemos seleccionado algún centro, lo añade a codigoZonas, en caso contrario,
		//las extrae a través del usuario logado.
		List<DTOTerminosResultado> results = new ArrayList<DTOTerminosResultado>();
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
    	EventFactory.onMethodStart(this.getClass());
    	Set<String> zonas;
        if (terminosFiltroDto.getCentros() != null && terminosFiltroDto.getCentros().trim().length() > 0) {
            /*
        	StringTokenizer tokens = new StringTokenizer(terminosFiltroDto.getCentros(), ",");
            Set<String> zonas = new HashSet<String>();
            while (tokens.hasMoreTokens()) {
                String zona = tokens.nextToken();
                zonas.add(zona);
            }
            */
        	List<String> list = Arrays.asList((terminosFiltroDto.getCentros()).split(","));
			zonas = new HashSet<String>(list);
			terminosFiltroDto.setCodigoZonas(zonas);
		} else {
			// Usuario usuario = (Usuario) executor
			// .execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			// zonas = usuario.getCodigoZonas();
			zonas = new HashSet<String>();
			terminosFiltroDto.setCodigoZonas(zonas);
		}
        
        EventFactory.onMethodStop(this.getClass());
        
        List<Long> idGrpsUsuario = null;
        if (usuario.getUsuarioExterno()) {
			idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuario(usuario);
		}
		
		Page page = proxyFactory.proxy(coreextensionApi.class).listBusquedaAcuerdosData(terminosFiltroDto, usuario,idGrpsUsuario);	
		model.put("pagina",page);
		
		return LISTADO_BUSQUEDA_TERMINOS_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String exportarExcel(ModelMap model, DTOTerminosFiltro terminosFiltroDto) throws Exception {

		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_ACUERDOS);		
		
		Integer limite = Integer.parseInt(param.getValor());
//		
		terminosFiltroDto.setStart(0);
		terminosFiltroDto.setLimit(limite);

		//Si en la pestaña de jerarquía hemos seleccionado algún centro, lo añade a codigoZonas, en caso contrario,
		//las extrae a través del usuario logado.
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
    	EventFactory.onMethodStart(this.getClass());
    	Set<String> zonas;
        if (terminosFiltroDto.getCentros() != null && terminosFiltroDto.getCentros().trim().length() > 0) {
        	List<String> list = Arrays.asList((terminosFiltroDto.getCentros()).split(","));
			zonas = new HashSet<String>(list);
			terminosFiltroDto.setCodigoZonas(zonas);
		} else {
			zonas = new HashSet<String>();
			terminosFiltroDto.setCodigoZonas(zonas);
		}
        
        EventFactory.onMethodStop(this.getClass());
        
        List<Long> idGrpsUsuario = null;
        if (usuario.getUsuarioExterno()) {
			idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuario(usuario);
		}
		
		Page page = proxyFactory.proxy(coreextensionApi.class).listBusquedaAcuerdosData(terminosFiltroDto, usuario,idGrpsUsuario);
		List<Object[]> listaTerminos = (List<Object[]>) page.getResults();
		
		model.put("acuerdos", convertListToExportExcel(listaTerminos));

		return "reportXLS/plugin/coreextension/acuerdo/listaAcuerdos";
	}
	
	private List<DTOTerminosExcel> convertListToExportExcel(List<Object[]> acuerdos) {

		final List<DTOTerminosExcel> acuExcel = new ArrayList<DTOTerminosExcel>();

		for (Object[] object : acuerdos) {
			EXTAcuerdo acu = (EXTAcuerdo) object[0];
			TerminoAcuerdo terAcu = (TerminoAcuerdo) object[1];
			
			final DTOTerminosExcel acuerdoExcel = new DTOTerminosExcel();
			
			if(!Checks.esNulo(acu)) {
				acuerdoExcel.setIdAcuerdo(acu.getId().toString());
				if(!Checks.esNulo(acu.getAsunto())) {
					acuerdoExcel.setIdAsunto(acu.getAsunto().getId().toString()); 
					acuerdoExcel.setNombreAsunto(acu.getAsunto().getNombre()); 
					if(!Checks.esNulo(acu.getAsunto().getExpediente()) && 
							!Checks.esNulo(acu.getAsunto().getExpediente().getContratoPase()) && 
							!Checks.estaVacio(acu.getAsunto().getExpediente().getContratoPase().getContratoPersona()) &&
							!Checks.esNulo(acu.getAsunto().getExpediente().getContratoPase().getContratoPersona().get(0).getPersona())) {
						
						acuerdoExcel.setCliente(acu.getAsunto().getExpediente().getContratoPase().getContratoPersona().get(0).getPersona().getNom50()); 						
					}
				}
				
				if(!Checks.esNulo(acu.getExpediente())) {
					acuerdoExcel.setIdExpediente(acu.getExpediente().getId().toString()); 					
					acuerdoExcel.setDescripcionExpediente(acu.getExpediente().getDescripcion()); 
					if(!Checks.esNulo(acu.getExpediente().getTipoExpediente())) {
						acuerdoExcel.setTipoExpediente(acu.getExpediente().getTipoExpediente().getCodigo()); 						
					}
					if(!Checks.esNulo(acu.getExpediente().getContratoPase()) && 
							!Checks.estaVacio(acu.getExpediente().getContratoPase().getContratoPersona()) && 
							!Checks.esNulo(acu.getExpediente().getContratoPase().getContratoPersona().get(0).getPersona())) {
						acuerdoExcel.setCliente(acu.getExpediente().getContratoPase().getContratoPersona().get(0).getPersona().getNom50());								
					}
				}
				
				if(!Checks.esNulo(acu.getTipoAcuerdo())) {
					acuerdoExcel.setTipoAcuerdo(acu.getTipoAcuerdo().getDescripcion());					
				}
				
				if(!Checks.esNulo(acu.getGestorDespacho()) && 
						!Checks.esNulo(acu.getGestorDespacho().getDespachoExterno())) {
					acuerdoExcel.setSolicitante(acu.getGestorDespacho().getDespachoExterno().getDescripcion()); 
					if(!Checks.esNulo(acu.getGestorDespacho().getDespachoExterno().getTipoDespacho())) {
						acuerdoExcel.setTipoSolicitante(acu.getGestorDespacho().getDespachoExterno().getTipoDespacho().getDescripcion()); 						
					}
				}
				
				if(!Checks.esNulo(acu.getEstadoAcuerdo())) {
					acuerdoExcel.setEstado(acu.getEstadoAcuerdo().getDescripcion()); 					
				}
				
				acuerdoExcel.setFechaAlta(DateFormat.toString(acu.getFechaPropuesta())); 
				acuerdoExcel.setFechaEstado(DateFormat.toString(acu.getFechaEstado())); 
				acuerdoExcel.setFechaVigencia(DateFormat.toString(acu.getFechaLimite())); 				
			}
			if(!Checks.esNulo(terAcu)) {
				acuerdoExcel.setIdTermino(terAcu.getId().toString()); 	
				if(!Checks.estaVacio(terAcu.getContratosTermino()) && 
						!Checks.esNulo(terAcu.getContratosTermino().get(0).getContrato())) {
					acuerdoExcel.setIdContrato(terAcu.getContratosTermino().get(0).getContrato().getCodigoContrato());					
				}
				if(!Checks.esNulo(terAcu.getTipoAcuerdo())) {
					acuerdoExcel.setTipoAcuerdo(terAcu.getTipoAcuerdo().getDescripcion()); 									
				}
			}

			acuExcel.add(acuerdoExcel);

		}
		return acuExcel;

	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDespachosExternosByTipo(String codigo, String query, ModelMap model) {
		
		Page despachos = proxyFactory.proxy(coreextensionApi.class).getDespachosExternosByTipo(codigo,query);
		model.put("despachos", despachos);
		return JSON_LISTADO_DESPACHOS;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTipoAcuerdosByEntidad(String codigo,ModelMap model) {

		Page tiposAcuerdo = proxyFactory.proxy(coreextensionApi.class).getTipoAcuerdosByEntidad(codigo);
		
		model.put("tiposAcuerdo", tiposAcuerdo);
		return JSON_LISTADO_TIPOS_ACUERDO;
	}

	/**
	 * Controlador que devuelve un JSON con la lista de usuarios 
	 * @param model
	 * @param UsuarioDto 
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListAllUsersPaginated(ModelMap model, UsuarioDto usuarioDto){
		
		Page page = coreextensionApi.getListAllUsersPaginated(usuarioDto);
		model.put("pagina", page);
		
		return TIPO_USUARIO_PAGINATED_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCodigoNivelPorDescripcion(String descripcion, ModelMap model) {

		Integer codigo= proxyFactory.proxy(coreextensionApi.class).getCodigoNivelPorDescripcion(descripcion);
		model.put("codigo", codigo);
		return JSON_CODIGO_NIVEL;
	}
	


    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping
    public String getDictionary(String dictionary, ModelMap model) throws ClassNotFoundException {

    	List dictionaryData = utilDiccionarioApi.dameValoresDiccionario(Class.forName(dictionary));
		
        model.put("pagina", dictionaryData);

        return JSON_LISTA_DICCIONARIO_GENERICO_LIST;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    @RequestMapping
    public String getDictionaryDenormalized(String dictionary, ModelMap model) throws ClassNotFoundException {

    	List dictionaryData = utilDiccionarioApi.dameValoresDiccionarioSinBorrado(Class.forName(dictionary));
		
        model.put("pagina", dictionaryData);

        return JSON_LISTA_DICCIONARIO_GENERICO_LIST;
    }
	
}
