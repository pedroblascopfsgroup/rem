package es.pfsgroup.plugin.recovery.procuradores.categorias.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;


/**
 * Controlador de las pantallas relativas a las {@link Categorizacion}
 * @author manuel
 *
 */
@Controller
public class CategorizacionesController {

	public static final String JSON_LISTA_CATEGORIZACIONES_JSON = "plugin/procuradores/categorias/categorizacionesJSON";
	public static final String JSP_ABRE_VENTANA_CATEGORIZACIONES  = "plugin/procuradores/categorias/categorizaciones";
	public static final String JSP_ABRE_VENTANA_ALTA_CATEGORIZACIONES  = "plugin/procuradores/categorias/altaCategorizaciones";
	public static final String JSON_LISTA_DESPACHOS_EXTERNOS_JSON = "plugin/procuradores/categorias/despachoExternoJSON";
	public static final String JSON_GET_LISTA_DESPACHOS_EXTERNOS_JSON = "plugin/procuradores/categorias/despachosExternosJSON";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private CategorizacionApi categorizacionApi;
	
	@Autowired
	private CategoriaApi categoriaApi;
	
	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;
	
	
	
	/**
	 * Abre la ventana del buscador y listado de {@link Categorizacion}
	 * @return jsp con la ventana de busqueda y listado de categorizaciones
	 */
	@RequestMapping
	public String abreVentanaCategorizaciones(){
		
		return JSP_ABRE_VENTANA_CATEGORIZACIONES;
	}
	
	
	
	/**
	 * Abre la ventana de alta/edición de {@link Categorizacion}
	 * @param request
	 * @param model
	 * @return jsp con la ventana de alta/edición
	 */
	@RequestMapping
	public String abreVentanaAltaCategorizaciones(WebRequest request, ModelMap model){
		
		//Si es edición vendrán los parametros y habrá que pasarlos al formulario
		if (!Checks.esNulo(request.getParameter("idCategorizacion"))) {
			
			Long id = Long.valueOf(request.getParameter("idCategorizacion"));		
			model.put("Categorizacion", categorizacionApi.getCategorizacion(id));	
			
		}		
		return JSP_ABRE_VENTANA_ALTA_CATEGORIZACIONES;
	}
	
	
	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link Categorizacion}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaCategorizaciones(CategorizacionDto dto, ModelMap map){
		
		Page p = proxyFactory.proxy(CategorizacionApi.class).getListaCategorizaciones(dto);
		map.put("pagina", p);
		return JSON_LISTA_CATEGORIZACIONES_JSON;
	}
	
	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link Categorizacion}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaCategorizacionesDelDespacho(CategorizacionDto dto, ModelMap map, WebRequest request){
		
		if(request.getParameter("idDespacho")!=null && !request.getParameter("idDespacho").equals("")){
			dto.setIdDespExt(Long.parseLong(request.getParameter("idDespacho")));
		}
		
		Page p = proxyFactory.proxy(CategorizacionApi.class).getListaCategorizaciones(dto);
		map.put("pagina", p);
		return JSON_LISTA_CATEGORIZACIONES_JSON;
	}
	
	
	
	/**
	 * Guarda los datos de {@link Categorizacion}
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardarCategorizacion(CategorizacionDto dto, WebRequest request, ModelMap model) throws BusinessOperationException{			
		
		categorizacionApi.setCategorizacion(dto);
		return JSON_LISTA_CATEGORIZACIONES_JSON; 		
	}
	
	
	
	/**
	 * Indica si se puede borrar una {@link Categorizacion}
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String comprobarBorradoCategorizacion(WebRequest request, ModelMap model) throws BusinessOperationException{
		
		if (Checks.esNulo(request.getParameter("idCategorizacion"))) {	
			throw new BusinessOperationException("No se ha pasado el id de la categorización.");
			
		}else{	
			Long idCategorizacion = Long.valueOf(request.getParameter("idCategorizacion"));			
			Boolean ok = categorizacionApi.comprobarBorradoCategorizacion(idCategorizacion);	
			model.put("permitirBorrar", ok);			
		}
		
		return JSON_LISTA_CATEGORIZACIONES_JSON;		
	}
	
	
	/**
	 * Borra la {@link Categorizacion}
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String borrarCategorizacion(WebRequest request, ModelMap model) throws BusinessOperationException{
		
		if (Checks.esNulo(request.getParameter("idCategorizacion"))) {	
			throw new BusinessOperationException("No se ha pasado el id de la categorización.");
			
		}else{
	
			Long idCategorizacion = Long.valueOf(request.getParameter("idCategorizacion"));				
			if(idCategorizacion != null){
				categorizacionApi.borrarCategorizacion(idCategorizacion);	
			}
		}
		
		return JSON_LISTA_CATEGORIZACIONES_JSON;		
	}
	

	
	/**
	 * Obtiene un listado de {@link DespachoExterno}. 
	 * @param dto dto con la información de filtrado 
	 * @param model
	 * @return lista de {@link DespachoExterno}.
	 */
	@RequestMapping
	public String listaDespachosExternos(CategorizacionDto dto, ModelMap model){
		List<DespachoExterno> listaDesExt = categorizacionApi.getListaDespachosExternos(dto);
		model.put("listado", listaDesExt);
		model.put("total", listaDesExt.size());
		
		return JSON_LISTA_DESPACHOS_EXTERNOS_JSON;
	}
	
	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link DespachoExterno}
	 * @param dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaDespachosExternos(CategorizacionDto dto, ModelMap map,WebRequest request){
		
		///Obtenemos los despachos del usuario
		
		List<GestorDespacho> gestorDespacho = new ArrayList<GestorDespacho>(); 
		
		if(request.getParameter("idUsuario")!=null && !request.getParameter("idUsuario").equals("")){
			Long idUsuario = Long.parseLong(request.getParameter("idUsuario"));
			gestorDespacho.addAll(configuracionDespachoExternoApi.buscaDespachosPorUsuarioYTipo(idUsuario, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO));	
		}
		
		if(gestorDespacho.size() > 0){
			///Tiene algun despacho
			List<DespachoExterno> desExts = new ArrayList<DespachoExterno>();
			for(GestorDespacho gd : gestorDespacho){
				desExts.add(gd.getDespachoExterno());
			}
			
			map.put("listado", desExts);
			map.put("total", desExts.size());
			
			return JSON_LISTA_DESPACHOS_EXTERNOS_JSON;
			
		}else{
			
			Page p = proxyFactory.proxy(CategorizacionApi.class).getPageDespachoExterno(dto, request.getParameter("query"));
			map.put("pagina", p);
			return JSON_GET_LISTA_DESPACHOS_EXTERNOS_JSON;
		}
		

	}
	
}
