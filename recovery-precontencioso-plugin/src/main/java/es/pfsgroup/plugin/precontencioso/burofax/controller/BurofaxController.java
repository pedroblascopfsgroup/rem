package es.pfsgroup.plugin.precontencioso.burofax.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.burofax.dto.BurofaxDTO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;

@Controller
public class BurofaxController {
	
	private static final String JSON_LIST_BUROFAX  ="plugin/precontencioso/burofax/json/listaBurofaxJSON";
	
	private static final String JSP_TIPO_BUROFAX  ="plugin/precontencioso/burofax/jsp/tipoBurofax";
	
	private static final String JSP_ALTA_DIRECCION  ="plugin/precontencioso/burofax/jsp/altaDireccionPCO";
	
	private static final String JSP_ALTA_PERSONA  ="plugin/precontencioso/burofax/jsp/altaPersonaPCO";
	
	private static final String JSP_EDITAR_BUROFAX  ="plugin/precontencioso/burofax/jsp/editarBurofax";
	
	private static final String DEFAULT = "default";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private List<BurofaxDTO> listadoBurofax=null;
	
	boolean cambioEstado=false;
	
	@Autowired
	private Executor executor;
	
	/**
	 * Carga el grid de Burofaxes
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String getListaBurofax(ModelMap model) {

		//Cargamos los tipos de requerimientos
		if(!cambioEstado){
			listadoBurofax=new ArrayList<BurofaxDTO>();
			BurofaxDTO dto=new BurofaxDTO();
			dto.setId(Long.valueOf(1));
			dto.setIdCliente(Long.valueOf(2078041));
			dto.setIdDireccion(Long.valueOf(1));
			dto.setCliente("Cliente 1");
			dto.setEstado("Pendiente");
			dto.setDireccion("Dirección 1");
			//dto.setTipo("tipo 1");
			dto.setFechaSolicitud("12/12/2015");
			dto.setFechaEnvio("12/12/2015");
			dto.setFechaAcuse("12/12/2015");
			dto.setResultado("Resultado");
			listadoBurofax.add(dto);
			dto=new BurofaxDTO();
			dto.setId(Long.valueOf(2));
			dto.setIdCliente(Long.valueOf(2078041));
			dto.setIdDireccion(Long.valueOf(2));
			dto.setDireccion("Dirección 2");
			dto.setEstado("Pendiente");
			//dto.setTipo("tipo 2");
			dto.setFechaEnvio("13/12/2015");
			dto.setFechaAcuse("13/12/2015");
			listadoBurofax.add(dto);
			
			dto=new BurofaxDTO();
			dto.setId(Long.valueOf(3));
			dto.setIdCliente(Long.valueOf(2078042));
			dto.setIdDireccion(Long.valueOf(3));
			dto.setDireccion("Dirección 2");
			dto.setEstado("Pendiente");
			//dto.setTipo("tipo 2");
			dto.setFechaEnvio("13/12/2015");
			dto.setFechaAcuse("13/12/2015");
			listadoBurofax.add(dto);
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
	@RequestMapping
	public String getTipoBurofax(WebRequest request,ModelMap model,Long idProcedimiento) {
		String arrayIdDirecciones=request.getParameter("arrayIdDirecciones");
		String arrayIdClientes=request.getParameter("arrayIdClientes");
		
		List<DDTipoBurofaxPCO> listaTipoBurofax = new ArrayList<DDTipoBurofaxPCO>();
		DDTipoBurofaxPCO tipoBurofax=new DDTipoBurofaxPCO();
		tipoBurofax.setCodigo("1");
		tipoBurofax.setDescripcion("Tipo 1");
		listaTipoBurofax.add(tipoBurofax);
		tipoBurofax=new DDTipoBurofaxPCO();
		tipoBurofax.setCodigo("2");
		tipoBurofax.setDescripcion("Tipo 2");
		listaTipoBurofax.add(tipoBurofax);
		//listaTipoBurofax=(List<DDTipoBurofaxPCO>)proxyFactory.proxy(Dictionary.class).getList("DDTipoBurofaxPCO");
		model.put("tipoBurofax", listaTipoBurofax);
		model.put("idProcedimiento", idProcedimiento);
		model.put("arrayIdClientes",arrayIdClientes);
		model.put("arrayIdDirecciones", arrayIdDirecciones);
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
	private String configurarTipoBurofax(WebRequest request, ModelMap map,Long idTipoBurofax,Long idProcedimiento){
		String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").split(",");
		String[] arrayIdClientes=request.getParameter("arrayIdClientes").replace("[","").replace("]","").split(",");
		
		
		for(BurofaxDTO burofax : listadoBurofax){
		  for(int i=0;i<arrayIdDirecciones.length;i++){
			  if(burofax.getIdDireccion().equals(Long.valueOf(arrayIdDirecciones[i]))){
				  burofax.setEstado("Preparado");
				  burofax.setTipo("Tipo "+idTipoBurofax.toString());
				  burofax.setIdTipoBurofax(Long.valueOf(idTipoBurofax));
				  cambioEstado=true;
			  }
		  }
		}
		
		
		/**
		 * Cuando este creada la capa de acceso a datos , modificaremos el estado de la/s direcciones del burofax a Preparado y asociaremos el tipo de burofax seleccionado
		 */
		
		
		return DEFAULT;
	}
	
	
	@RequestMapping
	public String getEditarBurofax(WebRequest request,ModelMap model,Long idProcedimiento) {
		String arrayIdDirecciones=request.getParameter("arrayIdDirecciones");
		String arrayIdClientes=request.getParameter("arrayIdClientes");
		
		String textoBurofax="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
		
		/**
		 * Cuando este preparada la capa de acceso a datos recuperaremos el texto del burofax segun el tipo de burofax seleccionado
		 */
		
		model.put("textoBurofax",textoBurofax);
		model.put("idProcedimiento", idProcedimiento);
		model.put("arrayIdClientes",arrayIdClientes);
		model.put("arrayIdDirecciones", arrayIdDirecciones);
		return JSP_EDITAR_BUROFAX;
	}
	
	@RequestMapping
	private String editarBurofax(WebRequest request, ModelMap map,Long idProcedimiento,String contenidoBurofax){
		String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").split(",");
		String[] arrayIdClientes=request.getParameter("arrayIdClientes").replace("[","").replace("]","").split(",");
		
		
		
		
		
		/**
		 * Cuando este creada la capa de acceso a datos , guardaremos el nuevo contenido del burofax
		 */
		
		
		return DEFAULT;
	}
	
	
	@RequestMapping
	private String getAltaDireccion(WebRequest request, ModelMap model,Long idCliente){
		
		model.put("idAsunto", 1);
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute("dictionaryManager.getList", "DDProvincia");
		model.put("provincias", provincias);
		List<DDTipoVia> tiposVia = (List<DDTipoVia>) proxyFactory.proxy(DireccionApi.class).getListTiposVia();
		model.put("tiposVia", tiposVia);
		model.put("idCliente", idCliente);
		
		return JSP_ALTA_DIRECCION;
	}
	
	
	/**
	 * Guarda los datos de la dirección
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardaDireccion(WebRequest request, ModelMap model,Long idCliente) throws Exception{
		
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

		String resultado = proxyFactory.proxy(DireccionApi.class).guardarDireccion(dto);
		
		//model.put("resultado", resultado);
		//return JSON_RESULTADO_ALTA;
		/**
		 * Añadimos al grid la nueva direccion
		 */
		BurofaxDTO burofax=new BurofaxDTO();
		//burofax.setId(Long.valueOf(3));
		burofax.setIdCliente(Long.valueOf(idCliente));
		burofax.setIdDireccion(Long.valueOf(3));
		burofax.setEstado("Pendiente");
		burofax.setDireccion(dto.getDomicilio());
		//dto.setTipo("tipo 1");
		burofax.setFechaSolicitud("");
		burofax.setFechaEnvio("");
		burofax.setFechaAcuse("");
		burofax.setResultado("");
		listadoBurofax.add(burofax);
		
		cambioEstado=true;
		return DEFAULT;
		
	}
	
	
	@RequestMapping
	private String getAltaPersona(WebRequest request, ModelMap model,Long idCliente){
		
		
		
		return JSP_ALTA_PERSONA;
	}
	
	
	@RequestMapping
	private String guardaPersona(WebRequest request, ModelMap model,Long idCliente){
		String[] arrayIdPersonas=request.getParameter("arrayIdPersonas").replace("[","").replace("]","").replace("&quot;", "").split(",");
		
		for(int i=0;i<arrayIdPersonas.length;i++){
			BurofaxDTO burofax=new BurofaxDTO();
			//burofax.setId(Long.valueOf(3));
			burofax.setIdCliente(Long.valueOf(arrayIdPersonas[i]));
			burofax.setIdDireccion(Long.valueOf(4));
			burofax.setEstado("Pendiente");
			burofax.setDireccion("C/ La pera");
			burofax.setFechaSolicitud("");
			burofax.setFechaEnvio("");
			burofax.setFechaAcuse("");
			burofax.setResultado("");
			listadoBurofax.add(burofax);
			
			cambioEstado=true;
		}
		
		
		return DEFAULT;
	}

}
