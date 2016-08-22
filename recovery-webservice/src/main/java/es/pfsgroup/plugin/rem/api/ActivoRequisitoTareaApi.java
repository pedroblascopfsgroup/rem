package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.ActivoRequisitoTarea;

public interface ActivoRequisitoTareaApi {
	
	/***
	 * Busca en la tabla RET_REQUISITO_TAREA si existe algun requisito (dependencia con algun campo de una tarea anterior) 
	 * a la hora de calcular el plazo de vencimiento para esta tarea de procedimiento
	 * 
	 * @param idTareaProcedimiento TareaProcedimeinto a buscar
	 * @return Instancia de RequisitoTarea si existe, null en caso contrario
	 * 
	 * */
	public ActivoRequisitoTarea existeRequisito(Long idTareaProcedimiento);
	
	
	/***
	 * Comprueba que se cumple el requisito {@link RequisitoTarea} para un determinado trámite
	 * 
	 * @param requisito RequisitoTarea que se debe cumplir
	 * @param idActivoTramite Id del trámite que debe cumplir el requisito
	 * 
	 * @return True en caso de que se cumpla el requisito, false en caso contrario
	 * 
	 * */
	public boolean comprobarRequisito(ActivoRequisitoTarea requisito,Long idActivoTramite);

}
