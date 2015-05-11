package es.pfsgroup.procedimientos.requisitoTarea.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.procedimientos.requisitoTarea.model.RequisitoTarea;

public interface RequisitoTareaApi {

	public static final String BO_EXISTE_REQUISITO_TAREA_TAREA_PROCEDIMIENTO ="es.pfsgroup.procedimientos.requisitoTarea.existeRequisito";
	public static final String BO_COMPROBAR_REQUISITO_TAREA_TAREA_PROCEDIMIENTO ="es.pfsgroup.procedimientos.requisitoTarea.comprobarRequisito";
	
	/***
	 * Busca en la tabla RET_REQUISITO_TAREA si existe algun requisito (dependencia con algun campo de una tarea anterior) 
	 * a la hora de calcular el plazo de vencimiento para esta tarea de procedimiento
	 * 
	 * @param idTareaProcedimiento TareaProcedimeinto a buscar
	 * @return Instancia de RequisitoTarea si existe, null en caso contrario
	 * 
	 * */
	@BusinessOperationDefinition(BO_EXISTE_REQUISITO_TAREA_TAREA_PROCEDIMIENTO)
	public RequisitoTarea existeRequisito(Long idTareaProcedimiento);
	
	
	/***
	 * Comprueba que se cumple el requisito {@link RequisitoTarea} para un determinado procedimiento
	 * 
	 * @param requisito RequisitoTarea que se debe cumplir
	 * @param idProcedimiento Id del procedimiento que debe cumplir el requisito
	 * 
	 * @return True en caso de que se cumpla el requisito, false en caso contrario
	 * 
	 * */
	@BusinessOperationDefinition(BO_COMPROBAR_REQUISITO_TAREA_TAREA_PROCEDIMIENTO)
	public boolean comprobarRequisito(RequisitoTarea requisito,Long idProcedimiento);
}
