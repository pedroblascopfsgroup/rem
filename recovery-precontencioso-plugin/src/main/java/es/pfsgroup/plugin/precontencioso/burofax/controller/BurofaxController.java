package es.pfsgroup.plugin.precontencioso.burofax.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Direccion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.burofax.dto.BurofaxDTO;
import es.pfsgroup.plugin.precontencioso.burofax.manager.BurofaxManager;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDEstadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;

@Controller
public class BurofaxController {
	
	private static final String JSON_LIST_BUROFAX  ="plugin/precontencioso/burofax/json/listaBurofaxJSON";
	
	private static final String JSP_TIPO_BUROFAX  ="plugin/precontencioso/burofax/jsp/tipoBurofax";
	
	private static final String JSP_ALTA_DIRECCION  ="plugin/precontencioso/burofax/jsp/altaDireccionPCO";
	
	private static final String JSP_ALTA_PERSONA  ="plugin/precontencioso/burofax/jsp/altaPersonaPCO";
	
	private static final String JSP_EDITAR_BUROFAX  ="plugin/precontencioso/burofax/jsp/editarBurofax";
	
	private static final String JSP_ENVIAR_BUROFAX  ="plugin/precontencioso/burofax/jsp/enviarBurofax";
	
	private static final String JSP_AGREGAR_NOTIFICACION  ="plugin/precontencioso/burofax/jsp/pantallaNotificacion";
	
	private static final String DEFAULT = "default";
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private BurofaxManager burofaxManager;
	
	private List<BurofaxDTO> listadoBurofax=null;
	
	boolean cambioEstado=false;
	
	@Autowired
	private Executor executor;
	
	/**
	 * Carga el grid de Burofaxes
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaBurofax(ModelMap model,Long idProcedimiento) {
		
		listadoBurofax=new ArrayList<BurofaxDTO>();
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
			
			if(burofax.getDemandado().getDirecciones().size()>0){
			    for(Direccion direccion : burofax.getDemandado().getDirecciones()){
			    	
			    		dto.setIdCliente(burofax.getDemandado().getId());
			    		dto.setIdDireccion(direccion.getId());
			    		dto.setIdBurofax(burofax.getId());
			    		dto.setIdEnvio(Long.valueOf(-1));
		    			dto.setDireccion(direccion.getDomicilio().concat(" Nº ").concat(direccion.getDomicilio_n()));
						
		    			if(!Checks.esNulo(burofax.getContrato())){
		    				dto.setTipo(burofaxManager.getTipoBurofaxPorDefecto(idProcedimiento,burofax.getContrato().getId()).getCodigo());
		    				dto.setIdTipoBurofax(burofaxManager.getTipoBurofaxPorDefecto(idProcedimiento,burofax.getContrato().getId()).getId());
	
		    			}
		    			else{
		    				dto.setTipo("");
		    			}
		    			
			    	listadoBurofax.add(dto);
	    			dto=new BurofaxDTO();
	    			dto.setId(direccion.getId());			    	
			    	
			    }
			}
			else{
				listadoBurofax.add(dto);
    			dto=new BurofaxDTO();
			}
			
		    //Envios del burofax
			
			for(EnvioBurofaxPCO envioBurofax : burofax.getEnviosBurofax()){
				dto=new BurofaxDTO();
				dto.setId(envioBurofax.getId());
				dto.setIdBurofax(burofax.getId());
				dto.setIdTipoBurofax(envioBurofax.getTipoBurofax().getId());
				dto.setIdCliente(burofax.getDemandado().getId());
				dto.setIdEnvio(envioBurofax.getId());
				dto.setIdDireccion(envioBurofax.getDireccion().getId());
				dto.setDireccion(envioBurofax.getDireccion().getDomicilio());
				dto.setTipo(envioBurofax.getTipoBurofax().getCodigo());
				dto.setTipo(envioBurofax.getTipoBurofax().getCodigo());
				dto.setFechaSolicitud(envioBurofax.getFechaSolicitud());
				dto.setFechaEnvio(envioBurofax.getFechaEnvio());
				dto.setFechaAcuse(envioBurofax.getFechaAcuse());
				if(!Checks.esNulo(envioBurofax.getResultadoBurofax())){
					dto.setResultado(envioBurofax.getResultadoBurofax().getDescripcion());
				}
				listadoBurofax.add(dto);
				
				
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
		
		//Como se puede preparar en lugar de crear un nuevo registro actualizamos el anterior
		String arrayIdEnvios=request.getParameter("arrayIdEnvios");
		
		
		List<DDTipoBurofaxPCO> listaTipoBurofax=burofaxManager.getTiposBurofaxex();
		
		model.put("tipoBurofax", listaTipoBurofax);
		model.put("arrayIdBurofax",arrayIdBurofax);
		model.put("arrayIdDirecciones", arrayIdDirecciones);
		model.put("arrayIdEnvios", arrayIdEnvios);
		
		return JSP_TIPO_BUROFAX;
		
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
	private String configurarTipoBurofax(WebRequest request, ModelMap map,Long idTipoBurofax,Long idDireccion,Long idBurofax){
		
		
		String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").split(",");
		String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").split(",");
		String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").split(",");
	
		
		burofaxManager.configurarTipoBurofax(idTipoBurofax,arrayIdDirecciones,arrayIdBurofax,arrayIdEnvios);
		
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
	private String editarBurofax(WebRequest request, ModelMap map,String contenidoBurofax){
		
		String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").split(",");
		
		for(int i=0;i<arrayIdEnvios.length;i++){
			burofaxManager.configurarContenidoBurofax(Long.valueOf(arrayIdEnvios[i]), contenidoBurofax);
		}
		
		
		return DEFAULT;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	private String getAltaDireccion(WebRequest request, ModelMap model,Long idProcedimiento,Long idCliente){
		
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute("dictionaryManager.getList", "DDProvincia");
		model.put("provincias", provincias);
		List<DDTipoVia> tiposVia = (List<DDTipoVia>) proxyFactory.proxy(DireccionApi.class).getListTiposVia();
		model.put("tiposVia", tiposVia);
		model.put("idCliente", idCliente);
		model.put("idProcedimiento", idProcedimiento);
		//model.put("idContrato", idContrato);
		
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
	
	
	@RequestMapping
	private String guardaPersona(WebRequest request, ModelMap model,Long idProcedimiento,@RequestParam(value = "arrayIdPersonas", required = true) Long[] arrayIdPersonas){
		
		for(int i=0;i<arrayIdPersonas.length;i++){
			burofaxManager.guardaPersonaCreandoBurofax(arrayIdPersonas[i],idProcedimiento);
		}
		
		
		
		return DEFAULT;
	}
	
	
	public static final String JSON_LISTA_PERSONAS = "direcciones/listaPersonasJSON";

	/**
     * Metodo que devuelve las personas para mostrarlos en el desplegable din�mico del campo asunto.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getPersonasInstant(String query, ModelMap model) {
    	
        model.put("data",burofaxManager.getPersonas(query));
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
    public String guardarEnvioBurofax(WebRequest request, ModelMap model,Boolean certificado,Long idTipoBurofax,Boolean comboEditable){
    	
    	String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").replace("&quot;", "").split(",");
    	
    	//Configuramos el tipo de burofax
    	List<EnvioBurofaxPCO> listaEnvioBurofaxPCO=new ArrayList<EnvioBurofaxPCO>();
    	if(comboEditable){
	    	String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	listaEnvioBurofaxPCO=burofaxManager.configurarTipoBurofax(idTipoBurofax,arrayIdDirecciones,arrayIdBurofax,arrayIdEnvios);
    	}
    	else{
    		for(int i=0;i<arrayIdEnvios.length;i++){
    			listaEnvioBurofaxPCO.add(burofaxManager.getEnvioBurofaxById(Long.valueOf(arrayIdEnvios[i])));
    		}
    	}
    	
		burofaxManager.guardarEnvioBurofax(certificado,listaEnvioBurofaxPCO);

    		
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
    	
    	List<DDEstadoBurofaxPCO> listaEstadoBurofax=burofaxManager.getEstadosBurofax();
    	
    	model.put("estadosBurofax", listaEstadoBurofax);
    	model.put("arrayIdEnvios", arrayIdEnvios);
    	
    	return JSP_AGREGAR_NOTIFICACION;
    	
    }
    
    @RequestMapping
    public String configuraInformacionEnvio(WebRequest request, ModelMap model,Long idEstadoBurofax,String fechaEnvio,String fechaAcuse){
    	
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
    	burofaxManager.guardaInformacionEnvio(arrayIdEnvios, idEstadoBurofax, fecEnvio, fecAcuse);

    	
    	return DEFAULT;
    }

}
