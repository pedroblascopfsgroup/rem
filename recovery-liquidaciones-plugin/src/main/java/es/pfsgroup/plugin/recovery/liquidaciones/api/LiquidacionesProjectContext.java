package es.pfsgroup.plugin.recovery.liquidaciones.api;

import java.util.Map;

/**
 * API con operaciones para liquidaciones.
 * @author kevin
 *
 */
public interface LiquidacionesProjectContext {

	/**
	 * Devuelve los codigos de las subtareas (DD_STA_CODIGO).
	 * @return String
	 */
	public Map<String, String> getCodigosSubTarea();
	
	public void setCodigosSubTarea(Map<String, String> codigosSubTarea);
	
	/**
	 * Devuelve el plazo de tiempo que tiene la tarea desde su creación.
	 * @return Long
	 */
	public Map<String, Long> getPlazoTarea();
	
	public void setPlazoTarea(Map<String, Long> plazoTarea);
	
}