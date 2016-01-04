package es.pfsgroup.plugin.recovery.procuradores.categorias.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;


/**
 * Controlador de las pantallas relativas a las {@link RelacionCategorias}
 * @author anahuac
 *
 */
@Controller
public class RelacionCategoriasController {

	public static final String JSP_ABRE_VENTANA_RELACION_CATEGORIAS  = "plugin/procuradores/categorias/relacionCategorias";
	public static final String JSON_LISTA_PROCEDIMIENTOS_JSON  = "plugin/procuradores/categorias/tiposProcedimientoJSON";
	public static final String JSON_LISTA_TIPOS_TAREAS_JSON  = "plugin/procuradores/categorias/tiposTareasJSON";
	public static final String JSON_LISTA_TIPO_RESOLUCION_JSON  = "plugin/procuradores/categorias/tiposResolJSON";

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private RelacionCategoriasApi relacionCategoriasApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	/**
	 * Abre la ventana del formulario para asociar {@link Categoria} con {@link Tareas} o {@link MSVDDTipoResolucion}
	 * @param request
	 * @param model
	 * @return jsp con la ventana para asociar {@link Categoria} con {@link Tareas} o {@link MSVDDTipoResolucion}
	 */
	@RequestMapping
	public String abreVentanaRelacionCategorias(WebRequest request, ModelMap model){
		
		if (!Checks.esNulo(request.getParameter("idcategorizacion"))) {
			Long id = Long.valueOf(request.getParameter("idcategorizacion"));		
			model.put("idcategorizacion", id);		
		}
		
		if (!Checks.esNulo(request.getParameter("tipoRelacion"))) {
			model.put("tipoRelacion", request.getParameter("tipoRelacion"));		
		}
		return JSP_ABRE_VENTANA_RELACION_CATEGORIAS;
	}
	
	
	/**
	 * Obtiene un listado de {@link TipoProcedimiento}. 
	 * @param request
	 * @param model
	 * @return lista de {@link TipoProcedimiento}.
	 */
	@RequestMapping
	public String listaProcedimientos(WebRequest request, ModelMap map) {
		List<TipoProcedimiento> listaProc = relacionCategoriasApi.getListaProcedimientos();
		map.put("listado", listaProc);
		
		return JSON_LISTA_PROCEDIMIENTOS_JSON;
	}
	

	/**
	 * Obtiene un listado de {@link TipoProcedimiento}. 
	 * @param request
	 * @param model
	 * @return lista de {@link TipoProcedimiento}.
	 */
	@RequestMapping
	public String listaProcedimientosCategorizables(WebRequest request, ModelMap map) {
		List<TipoProcedimiento> listaProc = relacionCategoriasApi.getListaProcedimientosCategorizables();
		map.put("listado", listaProc);
		
		return JSON_LISTA_PROCEDIMIENTOS_JSON;
	}
	
	
	
	/**
	 * Obtiene un listado de {@link TareaProcedimiento} que tienen {@link RelacionCategorias}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return lista de {@link TareaProcedimiento} con {@link RelacionCategorias}
	 */
	@RequestMapping
	public String listaTareasConRelacionCategorias(RelacionCategoriasDto dto, ModelMap map) {		
		
		List<TareaProcedimiento> listaTareas = relacionCategoriasApi.getListaTareasConRelacionCategorias(dto);
		map.put("lista", listaTareas);
		
		return JSON_LISTA_TIPOS_TAREAS_JSON;
	}
	
	
	
	/**
	 * Obtiene un listado de {@link TareaProcedimiento} que no tienen {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @param map 
	 * @return lista de {@link TareaProcedimiento} sin {@link RelacionCategorias}
	 */
	@RequestMapping
	public String listaTareasSinRelacionCategorias(RelacionCategoriasDto dto, ModelMap map) {		
		
		List<TareaProcedimiento> listatareas = relacionCategoriasApi.getListaTareasSinRelacionCategorias(dto);
		map.put("lista", listatareas);
		
		return JSON_LISTA_TIPOS_TAREAS_JSON;
	}
	
	
	
	/**
	 * Guarda los datos de {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardarRelacionCategorias(RelacionCategoriasDto dto) throws BusinessOperationException{		
		
		relacionCategoriasApi.guardarRelacionCategorias(dto);
			
		return JSON_LISTA_TIPOS_TAREAS_JSON; 		
	}
	
		
	
	/**
	 * Borra la {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @throws Exception 
	 */
	@RequestMapping
	public String borrarRelacionCategoria(RelacionCategoriasDto dto) throws BusinessOperationException{	
			
		relacionCategoriasApi.borrarRelacionCategorias(dto);
		
		return JSON_LISTA_TIPOS_TAREAS_JSON;
	}

	
	
	
	
	/**
	 * Obtiene un listado de {@link MSVDDTipoResolucion} que tienen {@link RelacionCategorias}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return lista de {@link MSVDDTipoResolucion} con {@link RelacionCategorias}
	 */
	@RequestMapping
	public String listaTiposResolConRelacionCategorias(RelacionCategoriasDto dto, ModelMap map) {		
		
		List<MSVDDTipoResolucion> listadoTiposResol = relacionCategoriasApi.getListaTiposResolConRelacionCategorias(dto);
		map.put("lista", listadoTiposResol);
		
		return JSON_LISTA_TIPO_RESOLUCION_JSON;
	}
	
	
	
	/**
	 * Obtiene un listado de {@link MSVDDTipoResolucion} que no tienen {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @param map 
	 * @return lista de {@link MSVDDTipoResolucion} sin {@link RelacionCategorias}
	 */
	@RequestMapping
	public String listaTiposResolSinRelacionCategorias(RelacionCategoriasDto dto, ModelMap map) {		
		
		List<MSVDDTipoResolucion> listadoTiposResol = relacionCategoriasApi.getListaTiposResolSinRelacionCategorias(dto);
		map.put("lista", listadoTiposResol);
		
		return JSON_LISTA_TIPO_RESOLUCION_JSON;
	}
	
	
}
