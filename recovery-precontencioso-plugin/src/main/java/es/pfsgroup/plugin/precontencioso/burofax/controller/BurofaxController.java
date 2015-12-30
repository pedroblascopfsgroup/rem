package es.pfsgroup.plugin.precontencioso.burofax.controller;

import java.text.Collator;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.annotations.Check;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.diccionarios.comparator.DictionaryComparatorFactory;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.dto.DtoPersonaManual;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;
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
	
	public static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	
	public static final String JSON_LISTA_DOCUMENTOS = "plugin/precontencioso/documento/json/solicitudesDocumentoJSON";
	
	public static final String JSON_LISTA_CONTRATOS_PROCEDIMIENTOS = "plugin/precontencioso/burofax/json/listadoContratosProcedimientoIntevJSON";
	
	protected final Log logger = LogFactory.getLog(getClass());
	
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
				dto.setIdCliente(burofax.getDemandado().getId());
				dto.setCliente(burofax.getDemandado().getApellidoNombre());
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
				
				if(burofax.isEsPersonaManual()){
					dto.setEsPersonaManual("SI");
				}else{
					dto.setEsPersonaManual("NO");
				}
				
				if(burofax.getDemandado().getDirecciones().size()>0){
				    for(Direccion direccion : burofax.getDemandado().getDirecciones()){
				    		if(!Checks.esNulo(burofax.getContrato())){
				    			dto.setId(burofax.getId()+burofax.getContrato().getId()+direccion.getId());
				    		}
				    		else{
				    			dto.setId(burofax.getId()+burofax.getDemandado().getId()+direccion.getId());
				    		}
				    		dto.setIdCliente(burofax.getDemandado().getId());
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
	 */
	@RequestMapping
	private String configurarTipoBurofax(WebRequest request, ModelMap map,Long idTipoBurofax,Long idDireccion,Long idBurofax, Long idDocumento){

		String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").split(",");
		String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").split(",");

		burofaxManager.configurarTipoBurofax(idTipoBurofax,arrayIdDirecciones,arrayIdBurofax,null,idDocumento);
		
		return DEFAULT;
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
		
		while(contenidoBurofaxAux.length()>0 && contenidoBurofaxAux.indexOf("$") != -1){
			int inicioVariable=contenidoBurofaxAux.indexOf("$");
			int finalVariable=contenidoBurofaxAux.indexOf("}");
			
			String variable=contenidoBurofaxAux.substring(inicioVariable,finalVariable+1);
			
			if(variable.contains("<") || variable.contains("</")){
				throw new Exception("La definición de las variables es incorrecta. Compruebe el estilo de las variables");
			}
			else if(!precontenciosoContext.getVariablesBurofax().contains(StringUtils.substring(variable, variable.indexOf("{") + +1, variable.lastIndexOf("}")))) {
				throw new Exception("¡Atenci&oacute;n! se han encontrado variables err&oacute;neas en el texto");
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
	private String getAltaDireccion(WebRequest request, ModelMap model,Long idProcedimiento,Long idCliente){
		
		List<Dictionary> provincias = dictionaryManager.getList("DDProvincia", DictionaryComparatorFactory.getInstance().create(DictionaryComparatorFactory.COMPARATOR_BY_DESCRIPCION));
		model.put("provincias", provincias);

		List<DDTipoVia> tiposVia = (List<DDTipoVia>) proxyFactory.proxy(DireccionApi.class).getListTiposVia();
		model.put("tiposVia", tiposVia);
		model.put("idCliente", idCliente);
		model.put("idProcedimiento", idProcedimiento);
		
		return JSP_ALTA_DIRECCION;
	}	
	
	/**
	 * Guarda los datos de la dirección
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardaDireccion(WebRequest request, ModelMap model,Long idCliente,Long idProcedimiento) throws Exception{
		
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

	    
		burofaxManager.guardaDireccion(dto);
	    
		
	
		return DEFAULT;
		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	private String getAltaPersona(WebRequest request, ModelMap model,Long idProcedimiento){
		
		model.put("idProcedimiento", idProcedimiento);
		
		return JSP_ALTA_PERSONA;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	private String getAltaPersonaManual(WebRequest request, ModelMap model,Long idProcedimiento){
		
		model.put("idProcedimiento", idProcedimiento);
		
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
     */
    @RequestMapping
    public String guardarEnvioBurofax(WebRequest request, ModelMap model,Boolean certificado,Long idTipoBurofax,Boolean comboEditable, Long idDocumento){
    	
    	String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").replace("&quot;", "").split(",");
    	
    	//Configuramos el tipo de burofax
    	List<EnvioBurofaxPCO> listaEnvioBurofaxPCO=new ArrayList<EnvioBurofaxPCO>();
    	if(comboEditable){
	    	String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	listaEnvioBurofaxPCO=burofaxManager.configurarTipoBurofax(idTipoBurofax,arrayIdDirecciones,arrayIdBurofax,arrayIdEnvios,idDocumento);
    	}
    	else{
    		for(int i=0;i<arrayIdEnvios.length;i++){
    			listaEnvioBurofaxPCO.add(burofaxManager.getEnvioBurofaxById(Long.valueOf(arrayIdEnvios[i])));
    		}
    	}
    	
		burofaxManager.guardarEnvioBurofax(certificado,listaEnvioBurofaxPCO);
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(listaEnvioBurofaxPCO.get(0).getBurofax().getProcedimientoPCO().getProcedimiento().getId());			
    		
    	return DEFAULT;
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
    		logger.error(e);
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
				fileitem.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
				fileitem.setFileName("BUROFAX-"+burofaxEnvio.getCliente().replace(",","").trim()+".docx");
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
		
		int idIdentificativo = 1;	
		boolean esDocumento;	
		boolean tieneSolicitud;
		boolean isGestoria = esUsuarioTipoDespachoGestoria();
		
		for (DocumentoPCO doc : documentos) {
			List<SolicitudDocumentoPCO> solicitudes = doc.getSolicitudes();
			esDocumento = true;

			// Si hay solicitudes
			if (solicitudes != null && solicitudes.size() > 0) {
				for (SolicitudDocumentoPCO sol : solicitudes) {
					tieneSolicitud = true;
					// se añade el registro, si no es una gestoria o si es una gestoria y es una solicitud asignada a ella
					if (!isGestoria || (isGestoria && usuarioManager.getUsuarioLogado().getId().equals(sol.getActor().getUsuario().getId()))) {
						SolicitudDocumentoPCODto solDto = documentoPCOApi.crearSolicitudDocumentoDto(doc, sol, esDocumento, tieneSolicitud, idIdentificativo);
						if(!Checks.esNulo(solDto.getContrato()) && !Checks.esNulo(solDto.getTipoDocumento())){
							solicitudesDoc.add(solDto);	
						}
					}

					if (esDocumento) esDocumento = false;
					idIdentificativo++;
				}
			}

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
