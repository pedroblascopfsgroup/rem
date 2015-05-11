package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.List;
import java.util.Set;

/**
 * API con las operaciones de negocio para el coreextension.
 * @author carlos
 *
 */
public interface CoreProjectContext {
	
	public static final String CONST_TAREA_TIPO_DECISION = "DECISION";	
	
	/**
	 * Devuelve los codigos (DD_STA_CODIGO) de las tareas que se consideran de tipo decisión
	 * @return Set<String>
	 */
	Set<String> getTareasTipoDecision();	
	
	List<String> getTiposProcedimientosAdjudicados();

}
