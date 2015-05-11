package es.capgemini.pfs.core.api.tareaNotificacion;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
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
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.ResultadoBusquedaTareasBuzonesDto;

public interface TareaNotificacionApi {
	
	public static final String EXT_BO_TAREA_EDITAR_ALERTA="plugin.coreextension.tareaNotificacion.editarAlertaTarea";
	public static final String BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL_COUNT = "tareaNotificacionManager.buscarTareasParaExcelCount";
	public static final String BO_TAREA_MGR_EXPORTAR_TAREAS_PARA_EXCEL = "tareaNotificacionManager.exportarTareasExcel";
		
	/**
     * Obtiene una tareaNotificacion.
     * @param id id de la tarea
     * @return entidad TareaNotificacion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_GET)
    @Transactional
    public TareaNotificacion get(Long id);
    
    /**
     * Contesta una prorroga.
     * @param dto dto solicitar prorroga
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CONTESTAR_PRORROGA)
    @Transactional(readOnly = false)
    public void contestarProrroga(DtoSolicitarProrroga dto);
    
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
     * Guarda una tarea en la base de datos.
     * @param tareaNotificacion la tarea a guardar.
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(TareaNotificacion tareaNotificacion);
    
    /**
     * Crea una tarea.
     * @param dto DtoGenerarTarea.
     * @return el id de la tarea creada
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA)
    public Long crearTarea(DtoGenerarTarea dto);
    
    /**
     * Crea una notificacion para el gestor indicando que su solicitud de cancelación de un expediente fue rechazada.
     * @param expediente el expediente que se quería cancelar.
     * @param sc la solicitud de cancelación.
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_NOTIFICAR_SOLICITUD_CANCELACION_RECHAZADA)
    public void notificarSolCancelacRechazada(Expediente expediente, SolicitudCancelacion sc);
    
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
     * Crea una tarea.
     * @param dtoGenerarTarea dto de tare notificaciones
     * @return el id de la tarea creada
     */
	@BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_COMUNICACION)
	Long crearTareaComunicacion(DtoGenerarTarea dtoGenerarTarea);
	
	 /**
     * save de la comunicacion bpm.
     * @param comu comunucaion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public void saveOrUpdateComunicacionBPM(ComunicacionBPM comu);
    
    /**
     * save de la comunicacion bpm.
     * @param comu comunucaion
     * @return id
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_SAVE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public Long saveComunicacionBPM(ComunicacionBPM comu);
    
    /**
     * Buscar las tareas pendientes.
     * @param dto dto
     * @return lista de tareas
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE)
    @Transactional
    public Page buscarTareasPendiente(DtoBuscarTareaNotificacion dto);
    
    /**
     *	Borra una tarea.
     * @param idTarea id de la tarea
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID)
    @Transactional(readOnly = false)
    public void borrarNotificacionTarea(Long idTarea);
    
    /**
     * Crea una Prorroga.
     * @param dto dto solicitar prorroga
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_PRORROGA)
    public void crearProrroga(DtoSolicitarProrroga dto) ;
    
    /**
     * Crea una tarea a traves del proceso bpm generico.
     * @param idEntidad id de la entidad
     * @param tipoEntidad cdigo de tipo de entidad
     * @param subtipoTarea código del subtipo de tarea.
     * @param codigoPlazo código del plazo default.
     * @return bpm id
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM)
    public Long crearTareaConBPM(Long idEntidad, String tipoEntidad, String subtipoTarea, String codigoPlazo);
    

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento y son de un tipo determinado de tareas.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @param subtipoTarea ID del subtipo de tarea
     * @return Un listado de tareasNotificacion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC_SUBTIPO)
    public List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, String subtipoTarea);

    /**
	 * método para marcar una tarea alertada como revisada
	 * @param id de la tarea, marcar como revisada y comentarios
	 */
	@BusinessOperationDefinition(EXT_BO_TAREA_EDITAR_ALERTA)
	void editarAlertaTarea(Long id, Boolean revisada, Long tipoRevision, String comentarios);
	
	/**
     * obtiene el count de todas las tareas pendientes.
     * @param dto dto
     * @return cuenta
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_OBTENER_CANT_TAREAS_PENDIENTES)
    public List<Long> obtenerCantidadDeTareasPendientes(DtoBuscarTareaNotificacion dto);
    
    /**
     * Realiza la búsqueda de Tareas NOtificaciones para reporte Excel.
     * @param dto DtoBuscarTareaNotificacion
     * @return lista de tareas
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL)
    public List<ResultadoBusquedaTareasBuzonesDto> buscarTareasParaExcel(DtoBuscarTareaNotificacion dto);
    
    /**
     * Realiza la búsqueda de Tareas NOtificaciones para reporte Excel.
     * @param dto DtoBuscarTareaNotificacion
     * @return lista de tareas
     */
    @BusinessOperationDefinition(BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL_COUNT)
    public Integer buscarTareasParaExcelCount(DtoBuscarTareaNotificacion dto);
    
    /**
     * Realiza la exportacion de tareas a fichero excel
     * @param dto
     * @return
     */
    @BusinessOperationDefinition(TareaNotificacionApi.BO_TAREA_MGR_EXPORTAR_TAREAS_PARA_EXCEL)
	public FileItem exportaTareasExcel(DtoBuscarTareaNotificacion dto);

    @Transactional(readOnly = false)
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_FINALIZAR_NOTIF)
	void finalizarNotificacion(Long idTarea); 
	
}
