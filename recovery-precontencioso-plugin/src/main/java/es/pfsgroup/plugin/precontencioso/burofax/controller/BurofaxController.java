package es.pfsgroup.plugin.precontencioso.burofax.controller;

import java.text.Collator;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.ContratoPersonaManual;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.diccionarios.comparator.DictionaryComparatorFactory;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.EXTPersonaManager;
import es.capgemini.pfs.persona.dto.DtoPersonaManual;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonaManual;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi;
import es.pfsgroup.plugin.precontencioso.burofax.dto.BurofaxDTO;
import es.pfsgroup.plugin.precontencioso.burofax.manager.BurofaxManager;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxEnvioIntegracionPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDResultadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Controller
public class BurofaxController {
	
	private static final String JSON_LIST_BUROFAX  ="plugin/precontencioso/burofax/json/listaBurofaxJSON";
	
	private static final String JSP_TIPO_BUROFAX  ="plugin/precontencioso/burofax/jsp/tipoBurofax";
	
	private static final String JSP_ALTA_DIRECCION  ="plugin/precontencioso/burofax/jsp/altaDireccionPCO";
	
	private static final String JSP_ALTA_PERSONA  ="plugin/precontencioso/burofax/jsp/altaPersonaPCO";
	
	private static final String JSP_ALTA_PERSONA_MANUAL  ="plugin/precontencioso/burofax/jsp/altaPersonaManualPCO";
	
	private static final String JSP_EDITAR_BUROFAX  ="plugin/precontencioso/burofax/jsp/editarBurofax";
	
	private static final String JSP_ENVIAR_BUROFAX  ="plugin/precontencioso/burofax/jsp/enviarBurofax";
	
	private static final String JSP_AGREGAR_NOTIFICACION  ="plugin/precontencioso/burofax/jsp/pantallaNotificacion";
	
	public static final String JSON_LISTA_PERSONAS = "plugin/precontencioso/burofax/json/listaPersonasJSON";
	
	private static final String DEFAULT = "default";
	
	private static final String JSON_RESPUESTA  ="plugin/precontencioso/burofax/json/respuestaJSON";
	
	public static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	
	public static final String JSON_LISTA_DOCUMENTOS = "plugin/precontencioso/documento/json/solicitudesDocumentoJSON";
	private static final String JSP_EDITAR_DIRECCION_BUROFAX  ="plugin/precontencioso/burofax/jsp/editarDireccionPCO";
	private static final String JSP_VER_DIRECCION_BUROFAX  ="plugin/precontencioso/burofax/jsp/verDireccionPCO";

	
	public static final String JSON_LISTA_CONTRATOS_PROCEDIMIENTOS = "plugin/precontencioso/burofax/json/listadoContratosProcedimientoIntevJSON";
	
	public static final String JSON_LISTA_TIPOS_INTERVENCION = "plugin/precontencioso/burofax/json/listadoTiposIntervencionJSON";
	
	private static final String OK_KO_RESPUESTA_JSON = "plugin/coreextension/OkRespuestaJSON";
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Resource
	private MessageService messageService;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private BurofaxManager burofaxManager;
	
	@Autowired
	private DictionaryManager dictionaryManager;	
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private PrecontenciosoProjectContext precontenciosoContext;
	
	@Autowired
	private DocumentoPCOApi documentoPCOApi;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GestorDespachoDao gestorDespachoDao;
	
	@Autowired
	private ProcedimientoPCODao procedimientoPCODao;

	@Autowired
	private ProcedimientoPcoApi procedimientoPcoApi;

	
	
	@Autowired
	private EXTPersonaManager personaManager; 
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	/**
	 * Carga el grid de Burofaxes
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaBurofax(ModelMap model,Long idProcedimiento) {
		
		    List<BurofaxDTO> listadoBurofax=new ArrayList<BurofaxDTO>();
			List<BurofaxPCO> listaBurofax=burofaxManager.getListaBurofaxPCO(idProcedimiento);
			
			
			for(BurofaxPCO burofax : listaBurofax){
				BurofaxDTO dto=new BurofaxDTO();
				dto.setId(burofax.getId());
				dto.setIdBurofax(burofax.getId());

				if(!Checks.esNulo(burofax.getTipoIntervencion())){
					dto.setTipoIntervencion(burofax.getTipoIntervencion().getDescripcion());
				}
				else{
					dto.setTipoIntervencion("");
				}
				if(!Checks.esNulo(burofax.getContrato())){
					dto.setContrato(burofax.getContrato().getNroContrato());
				}
				else{
					dto.setContrato("");
				}
				
				dto.setEstado(burofax.getEstadoBurofax().getDescripcion());
				
				List<Direccion> direcciones = new ArrayList<Direccion>();
				
				if(burofax.isEsPersonaManual()){
					dto.setEsPersonaManual("SI");
					if(Checks.esNulo(burofax.getDemandadoManual().getCodClienteEntidad()) && Checks.esNulo(burofax.getDemandadoManual().getPropietario())){
						dto.setIdCliente(burofax.getDemandadoManual().getId());
						dto.setCliente(burofax.getDemandadoManual().getApellidoNombre());
						dto.setTienePersona(false);
						if(!Checks.esNulo(burofax.getDemandadoManual().getDirecciones()) && burofax.getDemandadoManual().getDirecciones().size()>0){
							direcciones.addAll(burofax.getDemandadoManual().getDirecciones());
						}
					}else{
						///Obtenemos la persona no manual
						Persona per = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "codClienteEntidad", burofax.getDemandadoManual().getCodClienteEntidad()), genericDao.createFilter(FilterType.EQUALS, "propietario.id", burofax.getDemandadoManual().getPropietario().getId()) );
						dto.setIdCliente(per.getId());
						dto.setCliente(burofax.getDemandadoManual().getApellidoNombre());
						dto.setTienePersona(true);
						if(!Checks.esNulo(per.getDirecciones()) && per.getDirecciones().size()>0){
							direcciones.addAll(per.getDirecciones());
						}
					}
				}else{
					dto.setTienePersona(true);
					dto.setEsPersonaManual("NO");
					dto.setIdCliente(burofax.getDemandado().getId());
					dto.setCliente(burofax.getDemandado().getApellidoNombre());
					if(!Checks.esNulo(burofax.getDemandado().getDirecciones()) && burofax.getDemandado().getDirecciones().size()>0){
						direcciones.addAll(burofax.getDemandado().getDirecciones());
					}
				}
				
					
				if(direcciones.size()>0){	
					
					for(Direccion direccion : direcciones){
				    		if(!Checks.esNulo(burofax.getContrato())){
				    			dto.setId(burofax.getId()+burofax.getContrato().getId()+direccion.getId());
				    		}
				    		else{
				    			dto.setId(burofax.getId()+burofax.getDemandado().getId()+direccion.getId());
				    		}
				    		//dto.setIdCliente(burofax.getDemandado().getId());
				    		dto.setIdDireccion(direccion.getId());
				    		dto.setIdBurofax(burofax.getId());
				    		dto.setIdEnvio(Long.valueOf(-1));
				    		if(!Checks.esNulo(direccion.getDomicilio_n())){
				    			dto.setDireccion(direccion.getDomicilio().concat(" Nº ").concat(direccion.getDomicilio_n()));
				    		}
				    		else{
				    			dto.setDireccion(direccion.getDomicilio());
				    		}
				    		
			    			if(!Checks.esNulo(burofax.getContrato())){
			    				DDTipoBurofaxPCO tipoBurofax=burofaxManager.getTipoBurofaxPorDefecto(idProcedimiento,burofax.getContrato().getId());
			    				if(!Checks.esNulo(tipoBurofax) && !Checks.esNulo(tipoBurofax.getCodigo())){
			    					dto.setTipo(tipoBurofax.getCodigo());
			    					dto.setTipoDescripcion(tipoBurofax.getDescripcion());
			    					dto.setIdTipoBurofax(tipoBurofax.getId());
			    				}

			    			}
			    			else{
			    				dto.setTipo("");
			    			}
			    			if(burofax.getEnviosBurofax().size()>0){
			    				boolean direccionConEnvio=false;
				    			for(EnvioBurofaxPCO envioBurofax : burofax.getEnviosBurofax()){
				    				if(envioBurofax.getDireccion().getId().equals(direccion.getId())){
				    					direccionConEnvio=true;
				    					dto.setIdEnvio(envioBurofax.getId());
				    					dto.setIdDireccion(envioBurofax.getDireccion().getId());
				    					if(!Checks.esNulo(envioBurofax.getDireccion().getDomicilio_n())){
				    						dto.setDireccion(envioBurofax.getDireccion().getDomicilio().concat(" Nº ").concat(envioBurofax.getDireccion().getDomicilio_n()));
				    					}
				    					else{
				    						dto.setDireccion(envioBurofax.getDireccion().getDomicilio());
				    					}
				    					dto.setTipo(envioBurofax.getTipoBurofax().getCodigo());
				    					dto.setTipoDescripcion(envioBurofax.getTipoBurofax().getDescripcion());
				    					dto.setFechaSolicitud(envioBurofax.getFechaSolicitud());
				    					dto.setFechaEnvio(envioBurofax.getFechaEnvio());
				    					dto.setFechaAcuse(envioBurofax.getFechaAcuse());
				    					dto.setAcuseRecibo(envioBurofax.getAcuseRecibo());
				    					dto.setRefExternaEnvio(envioBurofax.getRefExternaEnvio());
				    					if(!Checks.esNulo(envioBurofax.getResultadoBurofax())){
				    						dto.setResultado(envioBurofax.getResultadoBurofax().getDescripcion());
				    					}
				    					
				    					listadoBurofax.add(dto);
						    			dto=new BurofaxDTO();
				    				}
				    				//Tanto si es la direccion del envio como si no , añadimos la fila con la direccion
				    				else{
					    				//listadoBurofax.add(dto);
						    			//dto=new BurofaxDTO();
				    				}
				    				
					    			//dto.setId(direccion.getId());
				    			}
				    			if(!direccionConEnvio){
				    				listadoBurofax.add(dto);
					    			dto=new BurofaxDTO();
				    			}
			    			}
			    			//Si el burofax no tiene envios añadimos la fila con la direccion
			    			else{
						    	listadoBurofax.add(dto);
				    			dto=new BurofaxDTO();
				    			dto.setId(direccion.getId());
			    			}
				    		
				    }
				}
				//Si el demandado no tiene direccion , agregamos la fila
				else{
					listadoBurofax.add(dto);
	    			dto=new BurofaxDTO();
				}
		
				
			}
			
		
		model.put("listadoBurofax", listadoBurofax);
		
		return JSON_LIST_BUROFAX;

		
	}
	
	
	
	/**
	 * Devuelve la pantalla para poder seleccionar el tipo de burofax
	 * @param request
	 * @param model
	 * @param idProcedimiento
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTipoBurofax(WebRequest request,ModelMap model) {
		String arrayIdDirecciones=request.getParameter("arrayIdDirecciones");
		String arrayIdBurofax=request.getParameter("arrayIdBurofax");
		
		List<DDTipoBurofaxPCO> listaTipoBurofax=burofaxManager.getTiposBurofaxex();
		
		model.put("tipoBurofax", listaTipoBurofax);
		model.put("arrayIdBurofax",arrayIdBurofax);
		model.put("arrayIdDirecciones", arrayIdDirecciones);
		
		return JSP_TIPO_BUROFAX;
		
	}
	
	
	public boolean esUsuarioTipoDespachoGestoria() {
		Usuario userLogged = usuarioManager.getUsuarioLogado(); 

		List<GestorDespacho> listaGestorDespacho = gestorDespachoDao.getGestorDespachoByUsuIdAndTipoDespacho(userLogged.getId(), DDTipoDespachoExterno.CODIGO_GESTORIA_PCO);

		return !listaGestorDespacho.isEmpty();
	}
	
	/**
	 * Se realizan las acciones pertinentes para cambiar el estado de un envio a preparado cuando se seleccione un tipo de burofax
	 * @param request
	 * @param map
	 * @param idTipoBurofax
	 * @param idProcedimiento
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping
	public String configurarTipoBurofax(WebRequest request, ModelMap model,Long idTipoBurofax,Long idDireccion,Long idBurofax, Long idDocumento) throws Exception{
		DocumentoPCO doc = null;
		String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").split(",");
		String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").split(",");
		if(!Checks.esNulo(idDocumento)){
    		doc = documentoPCOApi.getDocumentoPCOById(idDocumento);
    		if(!Checks.esNulo(doc)){
	    		if(Checks.esNulo(doc.getNotario()) || Checks.esNulo(doc.getFechaEscritura()) || Checks.esNulo(doc.getProtocolo()) || Checks.esNulo(doc.getProvinciaNotario())){
	    			model.put("msgError", messageService.getMessage("plugin.precontencioso.grid.burofax.mensajes.validacionTipoDocumento",null));
	    			return JSON_RESPUESTA;
	    		}
    		}
    	}

		burofaxManager.configurarTipoBurofax(idTipoBurofax,arrayIdDirecciones,arrayIdBurofax,null,doc);
		
		return JSON_RESPUESTA;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getEditarBurofax(WebRequest request,ModelMap model) {
		
		String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").split(",");
		String idEnvios="";
		
		
		for(int i=0;i<arrayIdEnvios.length;i++){
			idEnvios=idEnvios.concat(arrayIdEnvios[i].concat(","));
		}
		
		//Y si los envios son del mismo tipo pero han sido editados por separado con un contenido distinto
		String textoBurofax=burofaxManager.obtenerContenidoBurofax(Long.valueOf(arrayIdEnvios[0]));
		
		/**
		 * Cuando este preparada la capa de acceso a datos recuperaremos el texto del burofax segun el tipo de burofax seleccionado
		 */
		
		arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").split(",");
		model.put("textoBurofax",textoBurofax);
		model.put("arrayIdEnvios", idEnvios);
		
		
		return JSP_EDITAR_BUROFAX;
	}
	
	@RequestMapping
	private String editarBurofax(WebRequest request, ModelMap map,String contenidoBurofax) throws Exception{

		//Comprobamos que las variables no han sido modificadas al editar su estilo con el HTMLEditor. Las variables son indivisibles 
		String contenidoBurofaxAux=contenidoBurofax;
		
		while(contenidoBurofaxAux.length()>0 && contenidoBurofaxAux.indexOf("${") != -1){
			int inicioVariable=contenidoBurofaxAux.indexOf("$");
			int finalVariable=contenidoBurofaxAux.indexOf("}");
			
			if(finalVariable != -1) {
				String variable=contenidoBurofaxAux.substring(inicioVariable,finalVariable+1);
				
				if(variable.contains("<") || variable.contains("</")){
					throw new Exception("La definición de las variables es incorrecta. Compruebe el estilo de las variables");
				}
				else if(!precontenciosoContext.getVariablesBurofax().contains(StringUtils.substring(variable, variable.indexOf("{") + +1, variable.lastIndexOf("}")))) {
					throw new Exception("¡Atenci&oacute;n! se han encontrado variables err&oacute;neas en el texto");
				}
			}
			else {
				finalVariable = inicioVariable + 1;
			}
			
			contenidoBurofaxAux=contenidoBurofaxAux.substring(finalVariable+1);
		}
		
		String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").split(",");
		Long idEnvio = 1L;
		for(int i=0;i<arrayIdEnvios.length;i++){
			burofaxManager.configurarContenidoBurofax(Long.valueOf(arrayIdEnvios[i]), contenidoBurofax);
			idEnvio = Long.valueOf(arrayIdEnvios[i]);
		}
		EnvioBurofaxPCO envio = burofaxManager.getEnvioBurofaxById(idEnvio);
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(envio.getBurofax().getProcedimientoPCO().getProcedimiento().getId());
		
		return DEFAULT;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	private String getAltaDireccion(WebRequest request, ModelMap model,Long idProcedimiento,Long idCliente, boolean tienePersona){
		
		List<Dictionary> provincias = dictionaryManager.getList("DDProvincia", DictionaryComparatorFactory.getInstance().create(DictionaryComparatorFactory.COMPARATOR_BY_DESCRIPCION));
		model.put("provincias", provincias);

		List<DDTipoVia> tiposVia = (List<DDTipoVia>) proxyFactory.proxy(DireccionApi.class).getListTiposVia();
		model.put("tiposVia", tiposVia);
		model.put("idCliente", idCliente);
		model.put("idProcedimiento", idProcedimiento);
		model.put("tienePersona", tienePersona);
		
		return JSP_ALTA_DIRECCION;
	}	
	
	/**
	 * Guarda los datos de la dirección
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardaDireccion(WebRequest request, ModelMap model,Long idCliente,Long idProcedimiento, boolean tienePersona) throws Exception{
		
		DireccionAltaDto dto=new DireccionAltaDto();
		dto.setProvincia(request.getParameter("provincia"));
		dto.setCodigoPostal(request.getParameter("codigoPostal"));
		dto.setLocalidad(request.getParameter("localidad"));
		dto.setMunicipio(request.getParameter("municipio"));
		dto.setTipoVia(request.getParameter("tipoVia"));
		dto.setDomicilio(request.getParameter("domicilio"));
		dto.setNumero(request.getParameter("numero"));
		dto.setPortal(request.getParameter("portal"));
		dto.setPiso(request.getParameter("piso"));
		dto.setEscalera(request.getParameter("escalera"));
		dto.setPuerta(request.getParameter("puerta"));
		if(tienePersona){
			dto.setListaIdPersonas(idCliente.toString());	
		}else{
			dto.setListaIdPersonasManuales(idCliente.toString());
		}
		
		dto.setOrigen(request.getParameter("origen"));

	    
		burofaxManager.guardaDireccion(dto);
	    
		
	
		return DEFAULT;
		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	private String getAltaPersona(WebRequest request, ModelMap model,Long idProcedimiento){
		
		model.put("idProcedimiento", idProcedimiento);
		
		return JSP_ALTA_PERSONA;
	}

	@RequestMapping
	private String cancelarEnEstPrep(WebRequest request, ModelMap model,Long idEnvio, Long idCliente, 
			@RequestParam(value = "arrayidEnvios", required = false) List<Long> arrayidEnvios){
		
		burofaxManager.cancelarEnEstPrep(idEnvio, idCliente, arrayidEnvios);
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	private String saberOrigen(WebRequest request, ModelMap map,Long idDireccion){
		
		boolean result = burofaxManager.saberOrigen(idDireccion);
		map.put("esManual", result);
		return "plugin/precontencioso/burofax/json/esManualJSON";
		//return DEFAULT;
	}
	
	@RequestMapping
	private String borrarDirecManual(WebRequest request, ModelMap model,Long idDireccion){
		
		burofaxManager.borrarDireccionManualBurofax(idDireccion);
		return DEFAULT;
	}
	
	@RequestMapping
	private String descartarPersonaEnvio(WebRequest request, ModelMap model,String idsBurofax){
		burofaxManager.descartarPersona(idsBurofax);
		return DEFAULT;
	}
	
	@RequestMapping
	public String excluirBurofax(ModelMap model, String idsBurofax) {
		proxyFactory.proxy(BurofaxApi.class).excluirBurofaxPorIds(idsBurofax);
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	private String getAltaPersonaManual(WebRequest request, ModelMap model,Long idProcedimiento, Long idCliente, boolean tienePersona){
		
		model.put("idProcedimiento", idProcedimiento);
		
		if(!Checks.esNulo(idCliente)){
			
			///Se abre la ventana para editar
			model.put("isEditMode", true);	
			model.put("idCliente", idCliente);
			
			if(tienePersona){
				///Obtenemos los datos de PER_PERSONAS
				Persona pers = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", idCliente));
				model.put("DNI", pers.getDocId());	
				model.put("NOMBRE", pers.getNombre());	
				model.put("APELLIDO1", pers.getApellido1());	
				model.put("APELLIDO2", pers.getApellido2());
				model.put("tienePersona", true);
			}else{
				//Obtenemos los datos de PER_PERSONAS_MANUALES
				PersonaManual persM = genericDao.get(PersonaManual.class, genericDao.createFilter(FilterType.EQUALS, "id", idCliente));
				model.put("DNI", persM.getDocId());	
				model.put("NOMBRE", persM.getNombre());	
				model.put("APELLIDO1", persM.getApellido1());	
				model.put("APELLIDO2", persM.getApellido2());
				model.put("tienePersona", false);
			}
		}
		
		return JSP_ALTA_PERSONA_MANUAL;
	}
	
	
	@RequestMapping
	private String guardaPersona(WebRequest request, ModelMap model,Long idProcedimiento,@RequestParam(value = "arrayIdPersonas", required = true) Long[] arrayIdPersonas){
		
		for(int i=0;i<arrayIdPersonas.length;i++){
			burofaxManager.guardaPersonaCreandoBurofax(arrayIdPersonas[i],idProcedimiento);
		}
		
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(idProcedimiento);				
		
		return DEFAULT;
	}
	
	@RequestMapping
	private String guardaPersonaYPersonaManual(WebRequest request, 
			ModelMap model,
			@RequestParam(value = "idPersona", required = true) Long idPersona, 
			Long idProcedimiento,
			boolean esPersonaManual, 
			@RequestParam(value = "contratos", required = true) Long[] contratos, 
			@RequestParam(value = "tipoIntervencionContratos", required = true) String[] tiposIntervencion,
			String dni,
			String nombre,
			String primerApll,
			String segundoApll){
		
		if(esPersonaManual){
			
			///Creamos la persona manual si no existe
			PersonaManual persMan;
			if(Checks.esNulo(idPersona)){
				persMan = burofaxManager.guardaPersonaManual(dni, nombre, primerApll, segundoApll,null,null);
			}else{
				persMan = burofaxManager.updatePersonaManual(dni, nombre, primerApll, segundoApll, idPersona);
			}
			///Creamos su relacion con los contratos
			int i = 0;
			for(Long idContrato : contratos){
				ContratoPersonaManual cntPersMan = burofaxManager.guardaContratoPersonaManual(persMan.getId(), idContrato, tiposIntervencion[i]);
				if(!Checks.esNulo(cntPersMan)) burofaxManager.crearBurofaxPersonaManual(persMan.getId(),idProcedimiento, cntPersMan.getId());
				i++;
			}
			
		}else{
			///Comprobamos si existen las relaciones y no se ha modificado el tipo de intervencion
			int i = 0;
			PersonaManual persMan = null;
			ContratoPersonaManual cntPersMan = null;
			
			for(Long idContrato : contratos){
				ContratoPersona contratoPersona = genericDao.get(ContratoPersona.class, genericDao.createFilter(FilterType.EQUALS, "persona.id", idPersona), genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato), genericDao.createFilter(FilterType.EQUALS, "tipoIntervencion.codigo", tiposIntervencion[i]));
				if(Checks.esNulo(contratoPersona)){
					///Creamos la persona si no se ha creado en alguna iteración anterior
					if(Checks.esNulo(persMan)){
						Persona persona = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", idPersona));
						persMan = burofaxManager.guardaPersonaManual(persona.getDocId(), persona.getNombre(), persona.getApellido1(), persona.getApellido2(), persona.getPropietario().getCodigo(), persona.getCodClienteEntidad());
					}
					
					///Creamos PERSONAS_CONTRATO_MANUAL
					if(!Checks.esNulo(persMan)){
						cntPersMan = burofaxManager.guardaContratoPersonaManual(persMan.getId(), idContrato, tiposIntervencion[i]);
					}
					
					///Creamos el burofax
					if(!Checks.esNulo(cntPersMan)){
						if(!Checks.esNulo(cntPersMan)) burofaxManager.crearBurofaxPersonaManual(persMan.getId(),idProcedimiento, cntPersMan.getId());
					}
					
				}else{
					///Creamos el burofax
					burofaxManager.crearBurofaxPersona(idPersona,idProcedimiento, contratoPersona.getId());
				}
				
				i++;
			}
		}			
		
		return DEFAULT;
	}

	/**
     * Metodo que devuelve las personas para mostrarlos en el desplegable din�mico del campo Persona.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getPersonasInstant(String query, ModelMap model) {
    	
        model.put("data", burofaxManager.getPersonasConContrato(query));
        return JSON_LISTA_PERSONAS;
    }
    
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getPersonasInstantConManuales(String query, ModelMap model) {
    	
    	Collection<DtoPersonaManual> personas = burofaxManager.getPersonasConContrato(query,true);
    	
    	DtoPersonaManual nueva = new DtoPersonaManual();
    	nueva.setManual(true);
    	Persona persona = new Persona();
    	persona.setId(null);
    	persona.setNom50("Nueva Persona");
    	nueva.setPersona(persona);
    	
    	personas.add(nueva);
    	
        model.put("data", personas);
        return JSON_LISTA_PERSONAS;
    }
    
    /**
     * Metodo que devuelve la pantalla de configuracion del envio de burofax
     * @param request
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getEnvioBurofax(WebRequest request, ModelMap model,Boolean comboEditable,String codigoTipoBurofax){
    	
    	//Configuramos el tipo de burofax
    	String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").replace("&quot;", "").split(",");
    	String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").replace("&quot;", "").split(",");
    	String arrayIdEnvios=request.getParameter("arrayIdEnvios");

    	
		List<DDTipoBurofaxPCO> listaTipoBurofax=burofaxManager.getTiposBurofaxex();
		
		//A partir del id envio obtengo el tipo burofax para mostrarlo en un textfield No editable
		//Para las personas añadidas que no tienen contrato asociado no se precarga el combo en la ventana de enviar
		DDTipoBurofaxPCO tipoBurofax=null;
		
		if(!codigoTipoBurofax.equals("")){
			tipoBurofax=burofaxManager.getTipoBurofaxByCodigo(codigoTipoBurofax);
		}
		
		model.put("listaTipoBurofax", listaTipoBurofax);
		model.put("comboEditable",comboEditable);
		
		if(!Checks.esNulo(tipoBurofax)){
			model.put("idTipoBurofax", tipoBurofax.getId());
			model.put("descripcionTipoBurofax", tipoBurofax.getCodigo());
		}
		else{
			model.put("idTipoBurofax", "");
			model.put("descripcionTipoBurofax", "");
		}
		
		String idDirecciones="";
		for(int i=0;i<arrayIdDirecciones.length;i++){
			idDirecciones=idDirecciones.concat(arrayIdDirecciones[i].concat(","));
		}
		
		String idBurofax="";
		for(int i=0;i<arrayIdBurofax.length;i++){
			idBurofax=idBurofax.concat(arrayIdBurofax[i].concat(","));
		}
		model.put("arrayIdDirecciones", idDirecciones);
    	model.put("arrayIdBurofax",idBurofax);
    	model.put("arrayIdEnvios",arrayIdEnvios);
		
    	
    	return JSP_ENVIAR_BUROFAX;
    }
    
    /**
     * Metodo para guardar el envio de burofaxes en BD
     * @param request
     * @param model
     * @return
     * @throws Exception 
     */
    @RequestMapping
    public String guardarEnvioBurofax(WebRequest request, ModelMap model,Boolean certificado,Long idTipoBurofax,Boolean comboEditable,  Long idDocumento) throws Exception{
    	DocumentoPCO doc = null;
    	
    	if(!Checks.esNulo(idDocumento)){
    		doc = documentoPCOApi.getDocumentoPCOById(idDocumento);
    		if(!Checks.esNulo(doc)){
	    		if(Checks.esNulo(doc.getNotario()) || Checks.esNulo(doc.getFechaEscritura()) || Checks.esNulo(doc.getProtocolo()) || Checks.esNulo(doc.getProvinciaNotario())){
	    			model.put("msgError", messageService.getMessage("plugin.precontencioso.grid.burofax.mensajes.validacionTipoDocumento",null));
	    			return JSON_RESPUESTA;
	    		}
    		}
    	}
    	
    	String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").replace("&quot;", "").split(",");
    	
    	//Configuramos el tipo de burofax
    	List<EnvioBurofaxPCO> listaEnvioBurofaxPCO=new ArrayList<EnvioBurofaxPCO>();
    	if(comboEditable){
	    	String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	listaEnvioBurofaxPCO=burofaxManager.configurarTipoBurofax(idTipoBurofax,arrayIdDirecciones,arrayIdBurofax,arrayIdEnvios,doc);
    	}
    	else{
    		for(int i=0;i<arrayIdEnvios.length;i++){
    			listaEnvioBurofaxPCO.add(burofaxManager.getEnvioBurofaxById(Long.valueOf(arrayIdEnvios[i])));
    		}
    	}
    	
    	
    	
		burofaxManager.guardarEnvioBurofax(certificado,listaEnvioBurofaxPCO, doc);
		if(!Checks.estaVacio(listaEnvioBurofaxPCO)){
			proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(listaEnvioBurofaxPCO.get(0).getBurofax().getProcedimientoPCO().getProcedimiento().getId());
		}
    		
		return JSON_RESPUESTA;
    }
    
    
    /**
     * Devuelve la pantalla para añadir información de los envios de burofax ya realizados
     * @param request
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
	@RequestMapping
    public String getPantallaInformacionEnvio(WebRequest request, ModelMap model){
    	
    	String arrayIdEnvios=request.getParameter("arrayIdEnvios");
    	
    	List<DDResultadoBurofaxPCO> listaResultadoBurofax = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDResultadoBurofaxPCO.class);
    	
    	model.put("resultadosBurofax", listaResultadoBurofax);
    	model.put("arrayIdEnvios", arrayIdEnvios);
    	
    	return JSP_AGREGAR_NOTIFICACION;
    	
    }
    
    @RequestMapping
    public String configuraInformacionEnvio(WebRequest request, ModelMap model,Long idResultadoBurofax,String fechaEnvio,String fechaAcuse){
    	
    	String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").replace("&quot;", "").split(",");
    	
    	Date fecAcuse=null;
    	Date fecEnvio=null;
    	try{
	    	SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");
	    	fecAcuse = webDateFormat.parse(fechaAcuse);
	    	fecEnvio = webDateFormat.parse(fechaEnvio);
    	}catch(Exception e){
    		logger.error("configuraInformacionEnvio: " + e);
    	}
    	burofaxManager.guardaInformacionEnvio(arrayIdEnvios, idResultadoBurofax, fecEnvio, fecAcuse);
    
		EnvioBurofaxPCO envio = proxyFactory.proxy(BurofaxApi.class).getEnvioBurofaxById(Long.valueOf(arrayIdEnvios[0]));			
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(envio.getBurofax().getProcedimientoPCO().getProcedimiento().getId());
    	    	
    	return DEFAULT;
    }
    
    @SuppressWarnings("unchecked")
	@RequestMapping
	private String descargarBurofax(WebRequest request, ModelMap model,@RequestParam(value = "idEnvio", required = true) Long idEnvio){
		
    	BurofaxEnvioIntegracionPCO burofaxEnvio=burofaxManager.getBurofaxEnvioIntegracionByIdEnvio(idEnvio);

		if(!Checks.esNulo(burofaxEnvio) && !Checks.esNulo(burofaxEnvio.getContenido())){
			EnvioBurofaxPCO envioBurofax = burofaxManager.getEnvioBurofaxById(idEnvio);
			if(!Checks.esNulo(envioBurofax)){
				FileItem fileitem = burofaxManager.generarDocumentoBurofax(envioBurofax);
				fileitem.setContentType("application/pdf");
				if(!Checks.esNulo(burofaxEnvio.getNombreFichero())){
					fileitem.setFileName(burofaxEnvio.getNombreFichero());
				}
				else{
					fileitem.setFileName("BUROFAX-"+burofaxEnvio.getCliente().replace(",","").trim()+".pdf");
				}
				model.put("fileItem", fileitem);
			}
		}

		return JSP_DOWNLOAD_FILE;
		
	}

	/**
     * Metodo que devuelve los domunetos de un procedimeinto que no esten descartados.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDocuemtosPCONoDescartados(Long idProcedimientoPCO, ModelMap model) {

		List<DocumentoPCO> listDocumentos = documentoPCOApi.getDocumentosPorIdProcedimientoPCONoDescartados(idProcedimientoPCO);
		List<DocumentoPCO> documentos = documentoPCOApi.getDocumentosOrdenadosByUnidadGestion(listDocumentos);
		
		List<SolicitudDocumentoPCODto> solicitudesDoc = new ArrayList<SolicitudDocumentoPCODto>();
		
		for (DocumentoPCO doc : documentos) {
			SolicitudDocumentoPCODto solDto = documentoPCOApi.crearSolicitudDocumentoDto(doc, null, true, false);
			solicitudesDoc.add(solDto);
		}

		model.put("solicitudesDocumento", solicitudesDoc);
		
        return JSON_LISTA_DOCUMENTOS;
    }
    
	/**
	 * Carga el grid de Burofaxes
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getRelacionContratos(ModelMap model,Long idProcedimiento, Long idPersona, Boolean manual) {
		
		//model.put("procedimiento", procedimientoPCODao.get(idProcedimiento).getProcedimiento());
		model.put("procedimiento", burofaxManager.getContratosProcPersona(idProcedimiento, idPersona, manual));
		
		return JSON_LISTA_CONTRATOS_PROCEDIMIENTOS;
	}
	
    /**
     * Devuelve un JSON con los tipos de intervencion
     * @param request
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
	@RequestMapping
    public String getTiposDeIntervencion(WebRequest request, ModelMap model){
    	
    	List<DDTipoIntervencion> listaTiposIntervencion = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDTipoIntervencion.class);
    	
    	model.put("listaTiposIntervencion", listaTiposIntervencion);
    	
    	return JSON_LISTA_TIPOS_INTERVENCION;
    	
    }
    
    
    /**
     * Comprueba si una persona esta dada de alta
     * @param request
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
	@RequestMapping
    public String existePersonaConDni(ModelMap model, String dniPersona){
    	
    	if(personaManager.getPersonasByDni(dniPersona).size()>0){
    		model.put("okko", true);
    	}else{
    		model.put("okko", false);	
    	}
		
		return OK_KO_RESPUESTA_JSON;
    }
    

    @SuppressWarnings("unchecked")
	@RequestMapping
	private String editarVerDireccion(ModelMap model, Long idCliente, Long idProcedimiento, Long idDireccion){
    	
		boolean result = burofaxManager.saberOrigen(idDireccion);
		
		Direccion dir = new Direccion();
		dir=burofaxManager.getDireccion(idDireccion);
		
		List<Dictionary> provincias = dictionaryManager.getList("DDProvincia", DictionaryComparatorFactory.getInstance().create(DictionaryComparatorFactory.COMPARATOR_BY_DESCRIPCION));
		model.put("provincias", provincias);
		List<DDTipoVia> tiposVia = (List<DDTipoVia>) proxyFactory.proxy(DireccionApi.class).getListTiposVia();
		model.put("tiposVia", tiposVia);
		
		model.put("idCliente", idCliente);
		model.put("idProcedimiento", idProcedimiento);
		model.put("idDireccion", idDireccion);
		if(!Checks.esNulo(dir.getProvincia())){
			model.put("valorProvincia", dir.getProvincia().getId());
			model.put("valorProvinciaTexto", dir.getProvincia().getDescripcion());
		}
		if(!Checks.esNulo(dir.getCodigoPostal())){
			model.put("valorCodigoPostal", dir.getCodigoPostal());
		}
		if(!Checks.esNulo(dir.getLocalidad())){
			model.put("valorLocalidad", dir.getLocalidad().getId());
			model.put("valorLocalidadTexto", dir.getLocalidad().getDescripcion());
		}
		if(!Checks.esNulo(dir.getMunicipio())){
			model.put("valorMunicipio", dir.getMunicipio());
		}
		if(!Checks.esNulo(dir.getDomicilio())){
			model.put("valorDomicilio", dir.getDomicilio());
		}
		if(!Checks.esNulo(dir.getDomicilio_n())){
			model.put("valorNumero", dir.getDomicilio_n());
		}
		if(!Checks.esNulo(dir.getPortal())){
			model.put("valorPortal", dir.getPortal());
		}
		if(!Checks.esNulo(dir.getPiso())){
			model.put("valorPiso", dir.getPiso());
		}
		if(!Checks.esNulo(dir.getPuerta())){
			model.put("valorPuerta", dir.getPuerta());
		}
		if(!Checks.esNulo(dir.getEscalera())){
			model.put("valorEscalera", dir.getEscalera());
		}
		if(!Checks.esNulo(dir.getTipoVia())){
			model.put("valorTipoVia", dir.getTipoVia().getId());
		}
		
		if(result){
			//es manual y por tanto tenemos que poder editar
			return JSP_EDITAR_DIRECCION_BUROFAX;
		}else{
			return JSP_VER_DIRECCION_BUROFAX;
		}	
	}
    
    @SuppressWarnings("unchecked")
	@RequestMapping
	private String mostrarBotonDependiente(WebRequest request, ModelMap map,Long idProcedimiento){
    	
    	List<String> codigosTiposGestores = Arrays.asList("PREDOC", "CM_GD_PCO", "SUP_PCO");
    	boolean mostrarBoton = burofaxManager.resultadoMostrarBoton(idProcedimiento, codigosTiposGestores);
    	
		map.put("mostrarBoton", mostrarBoton);
		return "plugin/precontencioso/burofax/json/mostrarDependeCodigoJSON";
		//return mostrarBoton;
    }
    /**
	 * Guarda los datos de la dirección
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String updateDireccion(WebRequest request, ModelMap model,Long idCliente,Long idProcedimiento, Long idDireccion) throws Exception{
		
		DireccionAltaDto dto=new DireccionAltaDto();
		dto.setProvincia(request.getParameter("provincia"));
		dto.setCodigoPostal(request.getParameter("codigoPostal"));
		dto.setLocalidad(request.getParameter("localidad"));
		dto.setMunicipio(request.getParameter("municipio"));
		dto.setTipoVia(request.getParameter("tipoVia"));
		dto.setDomicilio(request.getParameter("domicilio"));
		dto.setNumero(request.getParameter("numero"));
		dto.setPortal(request.getParameter("portal"));
		dto.setPiso(request.getParameter("piso"));
		dto.setEscalera(request.getParameter("escalera"));
		dto.setPuerta(request.getParameter("puerta"));
		dto.setListaIdPersonas(idCliente.toString());
		dto.setOrigen(request.getParameter("origen"));

		burofaxManager.actualizaDireccion(dto, idDireccion);
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	private String existeRelacionPersonaBurofax(WebRequest request, 
			ModelMap model,
			Long idProcedimiento,
			@RequestParam(value = "idPersona", required = true) Long idPersona, 
			@RequestParam(value = "contratos", required = true) Long[] contratos, 
			@RequestParam(value = "tipoIntervencionContratos", required = true) String[] tiposIntervencion){
		
		
		int i = 0;
		boolean existeRelacion = false;
		for(Long idContrato : contratos){
			List<BurofaxPCO> burofaxes = genericDao.getList(BurofaxPCO.class, genericDao.createFilter(FilterType.EQUALS, "demandado.id", idPersona),
																  genericDao.createFilter(FilterType.EQUALS, "procedimientoPCO.id", idProcedimiento),
																  genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato), 
																  genericDao.createFilter(FilterType.EQUALS, "tipoIntervencion.codigo", tiposIntervencion[i]));
			///Comprobamos si alguna relacion contrato-tipointervencion esta relacionado con furofax
			if(!Checks.esNulo(burofaxes) && burofaxes.size()>0){
				existeRelacion = true;
				break;
			}
			
			i++;
		}
		
		if(existeRelacion){
    		model.put("okko", true);	
		}else{
			model.put("okko", false);
		}
		
	return OK_KO_RESPUESTA_JSON;
	}

}

class ProvinciasComparator implements Comparator<DDProvincia> 
{
	private Collator collator;
	 
	public ProvinciasComparator(Collator c) 
	{
		this.collator = c;
	}

	@Override
	public int compare(DDProvincia o1, DDProvincia o2) 
	{
		return collator.compare(o1.getDescripcion(), o2.getDescripcion());
	}
}
