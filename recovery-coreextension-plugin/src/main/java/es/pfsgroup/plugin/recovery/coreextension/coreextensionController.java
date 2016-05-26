package es.pfsgroup.plugin.recovery.coreextension;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.model.Provisiones;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;
import es.capgemini.pfs.acuerdo.dto.DTOTerminosFiltro;
import es.capgemini.pfs.acuerdo.dto.DTOTerminosResultado;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
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

	@Autowired
	public ApiProxyFactory proxyFactory;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private	MEJAcuerdoManager mejAcuerdoManager;
	
	@Autowired
    private Executor executor;
	
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
	
	/**
	 * Controlador que devuelve un JSON con la lista de usuarios, despachos y tipo de gestores para un tipo de asunto. 
	 * 
	 * @param model
	 * @param idTipoDespacho id del despacho. {@link DespachoExterno}
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosDefectoByTipoAsunto(ModelMap model,String idTipoAsunto, String idExpediente,
			@RequestParam(value="porUsuario", required=false) Boolean porUsuario,
			@RequestParam(value="adicional", required=false) Boolean adicional,
			@RequestParam(value="procuradorAdicional", required=false) Boolean procuradorAdicional){
		
		List<EXTDDTipoGestor> listadoTipoGestores = null;
		List<DespachoExterno> listaDespachos = null;
		List<Usuario> listaUsuarios= null;
		List<EXTDDTipoGestor> listadoTipoGestoresFinal= new ArrayList<EXTDDTipoGestor>();
		List<DespachoExterno> listaDespachoFinal= new ArrayList<DespachoExterno>();
		List<Usuario> listaUsuariosFinal= new ArrayList<Usuario>();
		listadoTipoGestores= proxyFactory.proxy(coreextensionApi.class).getListTipoGestorAdicionalPorAsunto(idTipoAsunto);
		String codigoEntidadUsuario= usuarioManager.getUsuarioLogado().getEntidad().getCodigo();
		
		for(EXTDDTipoGestor tipoGestor: listadoTipoGestores){
			listaDespachos = proxyFactory.proxy(coreextensionApi.class).getListAllDespachos(tipoGestor.getId(), false);
			for(DespachoExterno despacho: listaDespachos){
				listaUsuarios = proxyFactory.proxy(coreextensionApi.class).getListAllUsuariosPorDefectoData(despacho.getId(), false);
				HashMap<String,Set<String>> perfilesMap= proxyFactory.proxy(coreextensionApi.class).getListPerfilesGestoresEspeciales(codigoEntidadUsuario);
				if(!perfilesMap.isEmpty() && Integer.parseInt(idTipoAsunto)==21){
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
        if (terminosFiltroDto.getCentros() != null && terminosFiltroDto.getCentros().trim().length() > 0) {
            StringTokenizer tokens = new StringTokenizer(terminosFiltroDto.getCentros(), ",");
            Set<String> zonas = new HashSet<String>();
            while (tokens.hasMoreTokens()) {
                String zona = tokens.nextToken();
                zonas.add(zona);
            }
            terminosFiltroDto.setCodigoZonas(zonas);
        } else {
           
        	terminosFiltroDto.setCodigoZonas(usuario.getCodigoZonas());
        }
        EventFactory.onMethodStop(this.getClass());
               
		Page page = proxyFactory.proxy(coreextensionApi.class).listBusquedaAcuerdosData(terminosFiltroDto, usuario);
		
		results=preparaResultadosTerminos(page, terminosFiltroDto);
		
		model.put("results",results);
		model.put("totalTerminos",page.getTotalCount());
		
		return LISTADO_BUSQUEDA_TERMINOS_JSON;
	}

	private List<DTOTerminosResultado> preparaResultadosTerminos(Page page,DTOTerminosFiltro terminosFiltroDto) {
					
		List<DTOTerminosResultado> results = new ArrayList<DTOTerminosResultado>();
		List<TerminoAcuerdo> listadoTerminos = (List<TerminoAcuerdo>) page.getResults();
		
		for(int i=0;i<listadoTerminos.size();i++){
			
			DTOTerminosResultado terminos= new DTOTerminosResultado();

			String idAcuerdo="";
			String idTermino="";
			String idAsunto="";
			String nombreAsunto="";
			String idExpediente="";
			String tipoExpediente="";
			String descripcionExpediente="";
			String contratoPrincipal = "";
			String tipoAcuerdo="";
			String estado="";
			String solicitante="";
			String tipoSolicitante="";
			String fechaAlta="";
			String fechaEstado="";
			String fechaVigencia="";
			String clientePase="";
			
			TerminoAcuerdo terminoAcuerdo = listadoTerminos.get(i);
			
			idTermino=terminoAcuerdo.getId().toString();
			idAcuerdo=terminoAcuerdo.getAcuerdo().getId().toString();
			
			if(!Checks.esNulo(terminoAcuerdo.getAcuerdo().getAsunto())){
				idAsunto=terminoAcuerdo.getAcuerdo().getAsunto().getId().toString();
				if(!Checks.esNulo(terminoAcuerdo.getAcuerdo().getAsunto().getNombre())){
					nombreAsunto=terminoAcuerdo.getAcuerdo().getAsunto().getNombre();
				}
			}
			if(!Checks.esNulo(terminoAcuerdo.getAcuerdo().getExpediente())){
				idExpediente=terminoAcuerdo.getAcuerdo().getExpediente().getId().toString();
				if(!Checks.esNulo(terminoAcuerdo.getAcuerdo().getExpediente().getTipoExpediente())){
					tipoExpediente= terminoAcuerdo.getAcuerdo().getExpediente().getTipoExpediente().getCodigo();
				}
				if(!Checks.esNulo(terminoAcuerdo.getAcuerdo().getExpediente().getDescripcion())){
					descripcionExpediente=terminoAcuerdo.getAcuerdo().getExpediente().getDescripcion();
				}			
			}
			
			List<TerminoContrato> contratosTermino=terminoAcuerdo.getContratosTermino();
			
			Acuerdo acuerdo = terminoAcuerdo.getAcuerdo();
			
			Expediente expediente = acuerdo.getExpediente();
			if(!Checks.esNulo(terminoAcuerdo.getAcuerdo().getTipoAcuerdo())){
				
				if(!terminoAcuerdo.getAcuerdo().getTipoAcuerdo().getTipoEntidad().getCodigo().equals("ASU")){
					if(!Checks.esNulo(expediente.getContratoPase())){	
						if(expediente.getContratoPase().getContratoPersona().size()>0){
							clientePase=expediente.getContratoPase().getContratoPersona().get(0).getPersona().getNom50();
						}			
					}
				}else{	
					if(!Checks.esNulo(expediente.getContratoPase())){
						Asunto asunto = acuerdo.getAsunto();
						if(asunto.getExpediente().getContratoPase().getContratoPersona().size()>0){
							clientePase=asunto.getExpediente().getContratoPase().getContratoPersona().get(0).getPersona().getNom50();
						}
					}
				}
			}
			
				
			if(contratosTermino.size()!=0){
				contratoPrincipal=contratosTermino.get(0).getContrato().getCodigoContrato();
			}
			
			if(!Checks.esNulo(terminoAcuerdo.getAcuerdo())){
				if(!Checks.esNulo(terminoAcuerdo.getAcuerdo().getTipoAcuerdo())){
					tipoAcuerdo= terminoAcuerdo.getAcuerdo().getTipoAcuerdo().getDescripcion();
				}	
			}
			
			if(!Checks.esNulo(acuerdo.getEstadoAcuerdo())){
				estado=acuerdo.getEstadoAcuerdo().getDescripcion();
			}
			
			GestorDespacho gestorDespacho = acuerdo.getGestorDespacho();
			if(!Checks.esNulo(gestorDespacho)){
				DespachoExterno despachoExterno = gestorDespacho.getDespachoExterno();
				if(!Checks.esNulo(despachoExterno)){
					solicitante=despachoExterno.getDescripcion();	
					tipoSolicitante=despachoExterno.getTipoDespacho().getDescripcion();
				}			
			}
			
			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			
			if(!Checks.esNulo(acuerdo.getFechaPropuesta())){
				fechaAlta=format.format(acuerdo.getFechaPropuesta());
			}
			
			if(!Checks.esNulo(acuerdo.getFechaEstado())){
				fechaEstado=format.format(acuerdo.getFechaEstado());
			}
			
			if(!Checks.esNulo(acuerdo.getFechaLimite())){
				fechaVigencia=format.format(acuerdo.getFechaLimite());
			}
			
			terminos.setIdTermino(idTermino);
			terminos.setIdAcuerdo(idAcuerdo);
			terminos.setIdAsunto(idAsunto);
			terminos.setNombreAsunto(nombreAsunto);
			terminos.setIdExpediente(idExpediente);
			terminos.setTipoExpediente(tipoExpediente);
			terminos.setDescripcionExpediente(descripcionExpediente);
			terminos.setIdContrato(contratoPrincipal);
			terminos.setNroCliente(clientePase);
			terminos.setTipoAcuerdo(tipoAcuerdo);
			terminos.setSolicitante(solicitante);
			terminos.setTipoSolicitante(tipoSolicitante);
			terminos.setEstado(estado);
			terminos.setFechaAlta(fechaAlta);
			terminos.setFechaEstado(fechaEstado);
			terminos.setFechaVigencia(fechaVigencia);
			
			results.add(terminos);
		}
		return results;
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
	
}
