package es.pfsgroup.plugin.recovery.procuradores.categorias.api;

import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;

public interface RelacionCategoriasApi {

	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_PROCEDIMIENTOS = "plugin.procuradores.categorizaciones.getListaProcedimientos";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_PROCEDIMIENTOS_CATEGORIZABLES = "plugin.procuradores.categorizaciones.getListaProcedimientosCategorizables";

	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_TAREAS_PROCEDIMIENTO = "plugin.procuradores.categorizaciones.getTareasProcedimiento";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TAREAS_CON_RELACION_CATEGORIAS = "plugin.procuradores.categorizaciones.getListaTareasConRelacionCategorias";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TAREAS_SIN_RELACION_CATEGORIAS = "plugin.procuradores.categorizaciones.getListaTareasSinRelacionCategorias";
	
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GUARDAR_RELACION_CATEGORIAS = "plugin.procuradores.categorizaciones.guardarRelacionCategorias";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_BORRAR_RELACION_CATEGORIAS = "plugin.procuradores.categorizaciones.borrarRelacionCategorias";

	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_TIPOS_RESOLUCIONES = "plugin.procuradores.categorizaciones.getTiposResoluciones";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TIPOSRESOL_CON_RELACION_CATEGORIAS = "plugin.procuradores.categorizaciones.getListaTiposResolConRelacionCategorias";
	public static final String PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TIPOSRESOL_SIN_RELACION_CATEGORIAS = "plugin.procuradores.categorizaciones.getListaTiposResolSinRelacionCategorias";

	
	/**
	 * Obtiene un listado de {@link TipoProcedimiento}. 
	 * @return lista de {@link TipoProcedimiento}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_PROCEDIMIENTOS)
	public List<TipoProcedimiento>  getListaProcedimientos();
	
	
	/**
	 * Obtiene un listado de {@link TipoProcedimiento}. 
	 * @return lista de {@link TipoProcedimiento}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_PROCEDIMIENTOS_CATEGORIZABLES)
	public List<TipoProcedimiento>  getListaProcedimientosCategorizables();
	
	
	
	/**
	 * Obtiene un listado de {@link TareaProcedimiento} por Tipo de Procedimiento
	 * @param dto dto con los datos de filtado.
	 * @return lista de {@link TareaProcedimiento}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GET_TAREAS_PROCEDIMIENTO)
	public List<TareaProcedimiento>  getTareasProcedimiento(RelacionCategoriasDto dto);
	
	
	
	/**
	 * Obtiene un listado de {@link TareaProcedimiento} que tienen {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @return lista de {@link TareaProcedimiento}.
	 */
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TAREAS_CON_RELACION_CATEGORIAS)
	public List<TareaProcedimiento>  getListaTareasConRelacionCategorias(RelacionCategoriasDto dto);
	
	
	
	/**
	 * Obtiene un listado de {@link TareaProcedimiento} que no tienen {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @return lista de {@link TareaProcedimiento} sin {@link RelacionCategorias}
	 */
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TAREAS_SIN_RELACION_CATEGORIAS)
	public List<TareaProcedimiento> getListaTareasSinRelacionCategorias(RelacionCategoriasDto dto);
	
	
	
	
	/**
	 * Guarda los datos de la {@link RelacionCategorias}
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GUARDAR_RELACION_CATEGORIAS)
	public RelacionCategorias guardarRelacionCategorias(RelacionCategoriasDto dto) throws BusinessOperationException;
	
	
	
	/**
	 * Borrar la {@link RelacionCategorias}
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_BORRAR_RELACION_CATEGORIAS)
	public RelacionCategorias borrarRelacionCategorias(RelacionCategoriasDto dto) throws BusinessOperationException;
	
	
	
	/**
	 * Borrar las {@link RelacionCategorias} asociadas a una {@link Categoria}
	 * @param idcategoria
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_BORRAR_RELACION_CATEGORIAS)
	public void borrarRelacionCategoriasByIdCategoria(Long idcategoria) throws BusinessOperationException;
	
	
	
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_TIPOS_RESOLUCIONES)
	public List<MSVDDTipoResolucion> getTiposResoluciones(RelacionCategoriasDto dto);
	
	
	
	/**
	 * Obtiene un listado de {@link MSVDDTipoResolucion} que tienen {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @return lista de {@link MSVDDTipoResolucion} con {@link RelacionCategorias}
	 */
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TIPOSRESOL_CON_RELACION_CATEGORIAS)
	public List<MSVDDTipoResolucion>  getListaTiposResolConRelacionCategorias(RelacionCategoriasDto dto);
	
	
	
	/**
	 * Obtiene un listado de {@link MSVDDTipoResolucion} que no tienen {@link RelacionCategorias}
	 * @param dto dto con los datos de filtado.
	 * @return lista de {@link TareaProcedimiento} sin {@link RelacionCategorias}
	 */
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TIPOSRESOL_SIN_RELACION_CATEGORIAS)
	public List<MSVDDTipoResolucion> getListaTiposResolSinRelacionCategorias(RelacionCategoriasDto dto);
	
	
}
