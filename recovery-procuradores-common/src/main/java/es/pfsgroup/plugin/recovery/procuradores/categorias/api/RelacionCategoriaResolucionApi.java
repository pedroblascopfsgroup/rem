package es.pfsgroup.plugin.recovery.procuradores.categorias.api;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriaResolucionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategoriaResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;

public interface RelacionCategoriaResolucionApi {
	
	public static final String PLUGIN_PROCURADORES_CATEGORIAS_GUARDAR_RELACION_CATEGORIAS_RESOLUCION = "plugin.procuradores.categorizaciones.guardarRelacionCategoriaResolucion";
	public static final String PLUGIN_PROCURADORES_CATEGORIAS_BORRAR_RELACION_CATEGORIAS_RESOLUCION = "plugin.procuradores.categorizaciones.borrarRelacionCategoriaResolucion";
	
	
	/**
	 * Guarda los datos de la {@link RelacionCategorias}
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIAS_GUARDAR_RELACION_CATEGORIAS_RESOLUCION)
	public RelacionCategoriaResolucion guardarRelacionCategoriaResolucion(RelacionCategoriaResolucionDto dto) throws BusinessOperationException;
	
	/**
	 * Borrar la {@link RelacionCategorias}
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIAS_BORRAR_RELACION_CATEGORIAS_RESOLUCION)
	public RelacionCategoriaResolucion borrarRelacionCategoriaResolucion(RelacionCategoriaResolucionDto dto) throws BusinessOperationException;
	
	
}
