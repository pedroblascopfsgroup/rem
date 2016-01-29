package es.pfsgroup.recovery.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.ComunicacionBPM;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Interfaz con las BO de Recovery relativas a las TareaNotificacion que se usan en éste plugin
 * @author bruno
 *
 */
public interface TareaNotificacionApi {

	public static final String SAN_BO_GENERAR_AUTOPRORROGA = "plugin.santander.tareaNotificacion.generarAutoprorroga";
	public static final String SAN_BO_TAREA_EDITAR_ALERTA="plugin.santander.tareaNotificacion.editarAlerta";
	
	 /**
     * Crea una tarea.
     * @param dtoGenerarTarea dto de tare notificaciones
     * @return el id de la tarea creada
     */
	@BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_COMUNICACION)
	Long crearTareaComunicacion(DtoGenerarTarea dtoGenerarTarea);
	
	 /**
     * Crea una tarea.
     * @param dto DtoGenerarTarea.
     * @return el id de la tarea creada
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA)
    public Long crearTarea(DtoGenerarTarea dto);
    
    /**
     * Crea una notificación para un expediente.
     * @param idEntidadInformacion el id de la entidad que genera la notificación.
     * @param idTipoEntidadInformacion indica a que tipo de entidad corresponde el id anterior.
     * @param codigoSubtipoTarea el código de la notificacion a insertar.
     * @param descripcion descripcion
     * @return el id de la notificación que se creó.
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION)
    public Long crearNotificacion(Long idEntidadInformacion, String idTipoEntidadInformacion, String codigoSubtipoTarea, String descripcion);
    
    /**
     * Obtiene una tareaNotificacion.
     * @param id id de la tarea
     * @return entidad TareaNotificacion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_GET)
    @Transactional
    public TareaNotificacion get(Long id);
    
    
    
    
    /**
     * save de la comunicacion bpm.
     * @param comu comunucaion
     * @return id
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_SAVE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public Long saveComunicacionBPM(ComunicacionBPM comu);
    
    /**
     * Guarda una tarea en la base de datos.
     * @param tareaNotificacion la tarea a guardar.
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(TareaNotificacion tareaNotificacion);
    
    /**
     * save de la comunicacion bpm.
     * @param comu comunucaion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public void saveOrUpdateComunicacionBPM(ComunicacionBPM comu);
    
    /**
     * solicita una cancelacion de un expediente.
     * @param idExpediente id expediente
     * @param detalle el detalle de la solicitud de cancelación.
     * @param esSupervisor indica si el usuario es supervisor, para que no se genere una tarea.
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_SOL_CANCELACION_EXP)
    @Transactional(readOnly = false)
    public void solicitarCancelacionExpediente(Long idExpediente, String detalle, Boolean esSupervisor);
    
    
    /**
     * Crea una notificacion para el gestor indicando que su solicitud de cancelación de un expediente fue rechazada.
     * @param expediente el expediente que se quería cancelar.
     * @param sc la solicitud de cancelación.
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_NOTIFICAR_SOLICITUD_CANCELACION_RECHAZADA)
    public void notificarSolCancelacRechazada(Expediente expediente, SolicitudCancelacion sc);
    
    /**
     *	Borra una tarea.
     * @param idTarea id de la tarea
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID)
    @Transactional(readOnly = false)
    public void borrarNotificacionTarea(Long idTarea);
    
    /**
     * Contesta una prorroga.
     * @param dto dto solicitar prorroga
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CONTESTAR_PRORROGA)
    @Transactional(readOnly = false)
    public void contestarProrroga(DtoSolicitarProrroga dto);
    
    /**
     * Crea una Prorroga.
     * @param dto dto solicitar prorroga
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_PRORROGA)
    public void crearProrroga(DtoSolicitarProrroga dto);
    
    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento y son de un tipo determinado de tareas.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @param subtipoTarea ID del subtipo de tarea
     * @return Un listado de tareasNotificacion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC_SUBTIPO)
    public List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, String subtipoTarea);
    
    /**
     * Crea una tarea a traves del proceso bpm generico.
     * @param idEntidad id de la entidad
     * @param tipoEntidad cdigo de tipo de entidad
     * @param subtipoTarea código del subtipo de tarea.
     * @param codigoPlazo código del plazo default.
     * @return bpm id
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM)
    public Long crearTareaConBPM(Long idEntidad, String tipoEntidad, String subtipoTarea, String codigoPlazo) ;
    
    /**
     * Crea una tarea a traves del proceso bpm generico.
     * @param idEntidad id de la entidad
     * @param tipoEntidad cdigo de tipo de entidad
     * @param subtipoTarea código del subtipo de tarea.
     * @param codigoPlazo código del plazo default.
     * @param enEspera Dice si la tarea se debe crear o no en espera
     * @return bpm id
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA)
    @Transactional(readOnly = false)
    public Long crearTareaConBPMConEspera(Long idEntidad, String tipoEntidad, String subtipoTarea, String codigoPlazo, Boolean enEspera);
    
    
    /**
	 * método para generar autoprórrogas
	 * llama a las operaciones de negocio de solicitar prorroga y de conceder prorroga
	 * @param dto
	 */
	@BusinessOperationDefinition(SAN_BO_GENERAR_AUTOPRORROGA)
	void generarAutoprorroga(DtoSolicitarProrroga dto);
	
	/**
	 * método para marcar una tarea alertada como revisada
	 * @param id de la tarea, marcar como revisada y comentarios
	 */
	@BusinessOperationDefinition(SAN_BO_TAREA_EDITAR_ALERTA)
	void editarAlertaTarea(Long id, Boolean revisada, Long tipoRevision, String comentarios);
	
	/**
     * Buscar las tareas pendientes.
     * @param dto dto
     * @return lista de tareas
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE)
    @Transactional
    public Page buscarTareasPendiente(DtoBuscarTareaNotificacion dto);
    
    /**
     * obtiene el count de todas las tareas pendientes.
     * @param dto dto
     * @return cuenta
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_OBTENER_CANT_TAREAS_PENDIENTES)
    public List<Long> obtenerCantidadDeTareasPendientes(DtoBuscarTareaNotificacion dto);
    
    /**
     * elimina tareas de comunicacion, prorroga y cancelacion antes de enviar al proximo estado.
     * @param idExpediente expediente
     * @param estadoItinerario estado
     */
    @Transactional(readOnly = false)
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_ELIMINAR_TAREAS_INVALIDAS_ELEVACION_EXP)
    public void eliminarTareasInvalidasElevacionExpediente(Long idExpediente, String estadoItinerario);
	
}
