package es.capgemini.pfs.tareaNotificacion.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;

public interface EXTTareaNotificacionDao extends AbstractDao<TareaNotificacion, Long> {

    /**
     * recupera el número de notificaciones que contengan el mensaje citado.
     * @param txtNotificacion string
     * @param cliId Especifica si es un mensaje de cliente
     * @param expId Especifica si es un mensaje de expediente
     * @param asuId Especifica si es un mensaje de asunto
     * @return El número de notificaciones que cumplen la condición citada
     */
    Integer getNumNotificaciones(String txtNotificacion, Long cliId, Long expId, Long asuId);

    /**
     * Hace el borrado lï¿½gico de una tarea en base a un expediente.
     * @param expediente el expediente
     * @param subtipoTarea el subtipo de tarea
     * @param tipoEntidad el tipo de entidad
     */
    void borradoLogico(Expediente expediente, SubtipoTarea subtipoTarea, DDTipoEntidad tipoEntidad);

    /**
     * Hace el borrado lï¿½gico de una tarea en base a un cliente.
     * @param cliente el cliente
     * @param subtipoTarea el subtipo de tarea
     * @param tipoEntidad el tipo de entidad
     */
    void borradoLogico(Cliente cliente, SubtipoTarea subtipoTarea, DDTipoEntidad tipoEntidad);

    /**
     * Setea el flag de alerta a una tarea determinada.
     * @param idTarea el id de la tarea.
     */
    void crearAlerta(Long idTarea);

    /**
     * Busca el momento en el que termina el estado actual del expediente.
     * @param idExpediente el id del expediente.
     * @return la fecha y hora en que termina el estado.
     */
    Date buscarFechaFinEstadoExpediente(Long idExpediente);

    /**
     * Busca las tareas o notificaciones para la entidad cliente.
     * @param dto dtoparametro
     * @param conCarterizacion indica si se quiere hacer uso o no de la funcionalidad de búsqueda carterizada de tareas
     * @param usuarioLogado Usuario logado actual
     * @return lista de tareas
     */
    List<TareaNotificacion> buscarTareasPendienteClienteDelUsuario(DtoBuscarTareaNotificacion dto, boolean conCarterizacion, Usuario usuarioLogado);

    /**
     * Busca las tareas relacionadas a un cliente.
     * @param idCliente el id del cliente
     * @return la lista de tareas asociadas al cliente
     */
    List<TareaNotificacion> buscarTareasAsociadasACliente(Long idCliente);

    /**
    * Mï¿½todo encargado de buscar todas las tareas para un id de una entidad informaciï¿½n determinada.
    * @param dto DtoBuscarTareaNotificacion
    * @return List lista de tareas.
    */
    List<TareaNotificacion> buscarComunicaciones(DtoBuscarTareaNotificacion dto);

    /**
     * borra todas las tareas asociadas a un expediente cancelado.
     * @param exp id del expediente
     */
    void borradoTareasExpediente(Expediente exp);

    /**
     * obtiene el count de todas las tareas pendientes.
     * @param dto dto
     * @param conCarterizacion indica si se quiere hacer uso o no de la funcionalidad de búsqueda carterizada de tareas
     * @param usuarioLogado Usuario logado actual
     * @return cuenta
     */
    Long obtenerCantidadDeTareasPendientes(DtoBuscarTareaNotificacion dto, boolean conCarterizacion, Usuario usuarioLogado);

    /**
     * obtiene si un expediente tiene una prorroga asociada.
     * @param idExpediente id del expediente
     * @return lista de tareas
     */
    List<TareaNotificacion> obtenerProrrogaExpediente(Long idExpediente);

    /**
     * obtiene si un expediente tiene una solicitud de cancelacion asociada.
     * @param idExpediente id del expediente
     * @return lista de tareas
     */
    List<TareaNotificacion> obtenerSolicitudCancelacionExpediente(Long idExpediente);

    /**
     * obtiene las tareas de prorroga, comunicacion y cancelacion.
     * @param idExpediente expediente
     * @param estadoItinerario estadoItinerario
     * @return lista
     */
    List<TareaNotificacion> obtenerTareasInvalidasElevacionExpediente(Long idExpediente, String estadoItinerario);

    /**
     * Busca las tareas o notificaciones para un usuario.
     * @param dto dtoparametro
     * @param conCarterizacion indica si se quiere hacer uso o no de la funcionalidad de búsqueda carterizada de tareas
     * @param usuarioLogado Usuario logado actual
     * @return lista de tareas
     */
    Page buscarTareasPendiente(DtoBuscarTareaNotificacion dto, boolean conCarterizacion, Usuario usuarioLogado);

    /**
    * Devulve la tarea de acuerdo a la solicitud de cancelaciï¿½n y el expediente.
    * @param idSol el id de la solicitud de cancelaciï¿½n
    * @param idExp el id del expediente
    * @return la tarea o null si no existe.
    */
    TareaNotificacion buscarSolCancExp(Long idSol, Long idExp);

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento y son de un tipo determinado de tareas.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @param subtipoTarea ID del subtipo de tarea
     * @return Un listado de tareasNotificacion
     */
    List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, String subtipoTarea);

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento ordenadas por fecha de creacion.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @return Un listado de tareasNotificacion
     */
    List<TareaNotificacion> getListByProcedimiento(Long idProcedimiento);

    /**
     * Borra todas las tareas asociadas a un cliente.
     * @param idCliente long
     */
    void borrarTareasAsociadasCliente(Long idCliente);

    /**
     * Borra la tarea de justificacion de un objetivo
     * @param idObjetivo
     */
    void borrarTareaJustificacionObjetivo(Long idObjetivo);

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Asunto ordenadas por fecha de creacion.
     * @param idAsunto ID del asunto al que pertenece la tarea
     * @return Un listado de tareasNotificacion
     */
    List<TareaNotificacion> getListByAsunto(Long idAsunto);

    /**
     * Busca las tareas de respuesta de una comunicacion.
     * @param idTarea el id de la tarea asociada
     * @return la lista de tareas asociadas a la tarea
     */
    List<TareaNotificacion> buscarRespuestaAsociadaAComunicacion(TareaNotificacion idTarea);

}
