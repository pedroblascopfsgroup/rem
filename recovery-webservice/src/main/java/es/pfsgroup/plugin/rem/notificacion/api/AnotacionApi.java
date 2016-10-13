package es.pfsgroup.plugin.rem.notificacion.api;

import java.text.ParseException;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.rem.notificacion.dto.CrearAnotacionDto;

/**
 * Api de la entidad Anotacion.
 * 
 * @author anahuac
 * 
 */
public interface AnotacionApi {

	public static final String PLUGIN_REM_ANOTACION_CAMBIAR_DESTINATARIO_TAREA = "es.pfsgroup.plugin.rem.notificacion.api.cambiarDestinatarioTarea";
	public static final String PLUGIN_REM_ANOTACION_CAMBIAR_FECHA_TAREA = "es.pfsgroup.plugin.rem.notificacion.api.cambiarFechaTarea";
	public static final String PLUGIN_REM_ANOTACION_SAVE_ANNOTATION= "es.pfsgroup.plugin.rem.notificacion.api.saveAnotacion";
	public static final String PLUGIN_REM_ANOTACION_CREATE_ANOTATION = "es.pfsgroup.plugin.rem.notificacion.api.createAnotacion";
	
	
	public static final String SUBTIPO_ANOTACION_AUTOTAREA = "700";
	public static final String SUBTIPO_ANOTACION_TAREA = "700";
	public static final String SUBTIPO_ANOTACION_NOTIFICACION = "701";

	
	
	
	
	/**
	 * Metodo para crear una anotacion
	 * @param dto con la informacion necesaria para crear la anotacion
	 * @return
	 */
	@BusinessOperation(PLUGIN_REM_ANOTACION_SAVE_ANNOTATION)
	public Notificacion saveNotificacion(Notificacion notificacion) throws ParseException;
	
	
	/**
	 * Método para crear una anotación
	 * @param dto con la información necesaria para crear la anotación
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_REM_ANOTACION_CREATE_ANOTATION)
	public List<Long> createAnotacion(CrearAnotacionDto dto);
	
	
	/**
	 * Cambiar destinatario de una Tarea
	 * @param idTarea identificador de la tarea a modificar
	 * @param idUsuario identificador del nuevo usuario que tendrá la tarea
	 * @param idTraza identificador del registro asociado a la tarea para actualizar el registro
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_ANOTACION_CAMBIAR_DESTINATARIO_TAREA)
	void cambiarDestinatarioTarea(Long idTarea, Long idUsuario, Long idTraza) throws BusinessOperationException;
	
	/**
	 * Cambiar la fecha de vencimiento real de una tarea
	 * @param idTarea identificador de la tarea a modificar
	 * @param nuevaFecha nueva fecha de vencimiento de la tarea
	 * @param idTraza identificador del registro asociado a la tarea para actualizar el registro
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_ANOTACION_CAMBIAR_FECHA_TAREA)
	void cambiarFechaTarea(Long idTarea, String nuevaFecha, Long idTraza) throws BusinessOperationException;
	
	
	
}
