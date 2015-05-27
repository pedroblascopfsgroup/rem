package es.pfsgroup.plugin.recovery.procuradores.categorias.controller;

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
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriaResolucionApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriaDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriaResolucionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.api.ResolucionesCategoriasApi;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.model.ResolucionesCategorias;


/**
 * Controlador de las pantallas relativas a las {@link Categorias}
 * @author anahuac
 *
 */
@Controller
public class CategoriasController {

	public static final String JSON_LISTA_CATEGORIAS_JSON = "plugin/procuradores/categorias/categoriasJSON";
	public static final String JSON_LISTA_TOTAL_CATEGORIAS_JSON = "plugin/procuradores/categorias/listaTotalCategoriasJSON";
	public static final String JSP_ABRE_VENTANA_CATEGORIAS  = "plugin/procuradores/categorias/categorias";
	public static final String JSP_ABRE_VENTANA_REASIGNAR_CATEGORIA_TAREA  = "plugin/procuradores/categorias/reasignarCategoriaTarea";
	
	

	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private CategoriaApi categoriaApi;
	
	@Autowired
	private MSVResolucionApi MSVResolucionApi;
	
	@Autowired
	private RelacionCategoriaResolucionApi relacionCategoriaResolucionApi;
	
	
	/**
	 * Abre la ventana del listado de {@link Categoria}
	 * @param request
	 * @param model
	 * @return jsp con la ventana del listado de {@link Categoria}
	 */
	@RequestMapping
	public String abreVentanaCategorias(WebRequest request, ModelMap model){
		
		if (!Checks.esNulo(request.getParameter("idcategorizacion"))) {
			Long id = Long.valueOf(request.getParameter("idcategorizacion"));		
			model.put("idcategorizacion", id);		
		}
		
		return JSP_ABRE_VENTANA_CATEGORIAS;
	}	
	
	
	
	/**
	 * Abre la ventana del listado de {@link Categoria}
	 * @param request
	 * @param model
	 * @return jsp con la ventana del listado de {@link Categoria}
	 */
	@RequestMapping
	public String abreVentanaReasignarCategoriasTarea(WebRequest request, ModelMap model){
		
		if (!Checks.esNulo(request.getParameter("idResolucion"))) {
			Long id = Long.valueOf(request.getParameter("idResolucion"));		
			model.put("idResolucion", id);		
		}
		
		return JSP_ABRE_VENTANA_REASIGNAR_CATEGORIA_TAREA;
	}	

	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link Categoria}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	@RequestMapping
	public String getListaCategorias(CategoriaDto dto, ModelMap map){
		
		Page p = proxyFactory.proxy(CategoriaApi.class).getListaCategorias(dto);
		map.put("pagina", p);
		return JSON_LISTA_CATEGORIAS_JSON;
	}
	
	/**
	 * Devuelve un JSON con el resultado de {@link Categoria} de usuario logado.
	 * @param id idUsuario
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	@RequestMapping
	public String getListaCategoriasByUsuario(Long idUsuario, ModelMap map){
		
		List<Categoria> lista = proxyFactory.proxy(CategoriaApi.class).getListaTotalCategorias(idUsuario);
		map.put("lista", lista);
		
		List<ResolucionesCategorias> vistaCount = proxyFactory.proxy(ResolucionesCategoriasApi.class).getResolucionesPendientes(idUsuario);
		map.put("vistaCount", vistaCount);
		
		
		map.put("despachoIntegral", false);
		map.put("idDespacho", 0);
		
		
		if (!Checks.esNulo(idUsuario)){
			List<GestorDespacho> gestorDespacho = configuracionDespachoExternoApi.buscaDespachosPorUsuarioYTipo(idUsuario, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
			
			if((!Checks.esNulo(gestorDespacho) && gestorDespacho.size()>0)){
				DespachoExterno despacho = gestorDespacho.get(0).getDespachoExterno();	
				map.put("despachoIntegral",configuracionDespachoExternoApi.isDespachoIntegral(despacho.getId()));
				map.put("idDespacho", despacho.getId());
			}			
		}
		
		return JSON_LISTA_TOTAL_CATEGORIAS_JSON;
	}
	
	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link Categoria}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	@RequestMapping
	public String getListaCategoriasDeLaCategorizacionActivaDelUsuario(CategoriaDto dto, ModelMap map){
		
		Long categorizacionActivaDelUser = configuracionDespachoExternoApi.activoCategorizacion();
		
		if(categorizacionActivaDelUser!=null){
			dto.setIdcategorizacion(categorizacionActivaDelUser);
		}
		
		Page p = proxyFactory.proxy(CategoriaApi.class).getListaCategorias(dto);
		map.put("pagina", p);
		
		return JSON_LISTA_CATEGORIAS_JSON;
	}
	
	/**
	 * Guarda los datos de {@link Categoria}
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardarCategoria(CategoriaDto dto, WebRequest request, ModelMap model) throws BusinessOperationException{			
		
		categoriaApi.setCategoria(dto);
		model.put("categoria.totalCount", 0);
		return JSON_LISTA_CATEGORIAS_JSON; 		
	}
	
	
	
	
	/**
	 * Indica si tiene si se puede borrar una {@link Categoria}
	 * @param request
	 * @param model
	 */
	@RequestMapping
	public String comprobarBorradoCategoria(WebRequest request, ModelMap model) throws BusinessOperationException{

		if(Checks.esNulo(request.getParameter("id"))){		
			throw new BusinessOperationException("No se ha pasado el id de la categoría.");
			
		}else{	
			
			Long idcategoria = Long.valueOf(request.getParameter("id"));
			Boolean ok = categoriaApi.comprobarBorradoCategoria(idcategoria);	
			model.put("permitirBorrar", ok);
		}
		return JSON_LISTA_CATEGORIAS_JSON;		
	}
	
	
	
	
	/**
	 * Borra una {@link Categoria} de una {@link Categorizacion}
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String borrarCategoria(WebRequest request, ModelMap model) throws BusinessOperationException{

		if(Checks.esNulo(request.getParameter("id"))){		
			throw new BusinessOperationException("No se ha pasado el id de la categoría.");
			
		}else{	
			
			Long idcategoria = Long.valueOf(request.getParameter("id"));
			categoriaApi.borrarCategoria(idcategoria);	
			
		}
		return JSON_LISTA_CATEGORIAS_JSON;		
	}
	
	
	/**
	 * Actualiza una {@link Categoria} de una {@link Resolucion}
	 * @param request
	 * @param model
	 * @throws NumberFormatException 
	 * @throws Exception 
	 */
	@RequestMapping
	public String actualizaCategoriaDeLaResolucion(WebRequest request, ModelMap model) throws NumberFormatException, Exception{

		if(Checks.esNulo(request.getParameter("idResolucion"))){		
			throw new BusinessOperationException("No se ha pasado el id de la resolución.");
			
		}else{	
			
			
			if(Checks.esNulo(request.getParameter("selectCategorias"))){
				
				RelacionCategoriaResolucionDto dto = new RelacionCategoriaResolucionDto();
				MSVResolucion resolucion = MSVResolucionApi.getResolucion(Long.parseLong(request.getParameter("idResolucion")));
				dto.setResolucion(resolucion);
				relacionCategoriaResolucionApi.borrarRelacionCategoriaResolucion(dto);
				
			}else{
				
				RelacionCategoriaResolucionDto dto = new RelacionCategoriaResolucionDto();
				MSVResolucion resolucion = MSVResolucionApi.getResolucion(Long.parseLong(request.getParameter("idResolucion")));
				Categoria categoria = categoriaApi.getCategoria(Long.parseLong(request.getParameter("selectCategorias")));
				
				dto.setCategoria(categoria);
				dto.setResolucion(resolucion);
				
				relacionCategoriaResolucionApi.guardarRelacionCategoriaResolucion(dto);
				
			}
			
		}
		
		return JSON_LISTA_CATEGORIAS_JSON;		
	}
	
	
	
}
