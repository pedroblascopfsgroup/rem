package es.pfsgroup.plugin.rem.api;

import java.util.Map;

import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;

public interface ActivoGenericFormManagerApi {

//	public List<GenericForm> getByCodigoTipoProcedimiento(String codigo);

	/**
	 * Genera un vector de valores de las tareas del procedimiento
	 * @param idTramite El tramite del cual se quiere extraer sus valores de tareas
	 * @return Vector con los valores de los items de las tareas -> valores['TramiteIntereses']['fecha']
	 */
	public  Map<String, Map<String, String>> getValoresTareas(Long idTramite);

	/**
	 * Obtiene un formulario dinamico a partir del id de una tarea Externa
	 *
	 * @param id
	 * @return GenericForm
	 */
	public GenericForm getForm(Long id);

	/**
	 * Guarda los valores de la pantalla genérica en bbdd
	 *
	 * @param dto
	 */
	public void saveValues(DtoGenericForm dto);

}