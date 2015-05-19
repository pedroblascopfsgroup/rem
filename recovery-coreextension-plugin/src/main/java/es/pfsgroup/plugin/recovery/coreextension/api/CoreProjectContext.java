package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.Map;
import java.util.List;
import java.util.Set;

/**
 * API con las operaciones de negocio para el coreextension.
 * @author carlos
 *
 */
public interface CoreProjectContext {
	
	public static final String CATEGORIA_SUBTAREA_TOMA_DECISION = "TOMA_DE_DECISION";	
	
	/**
	 * Devuelve los codigos (DD_STA_CODIGO) agrupadas por categorias (DECISION, ....)
	 * @return Set<String>
	 */
	public Map<String, Set<String>> getCategoriasSubTareas();	

	List<String> getTiposProcedimientosAdjudicados();
}
