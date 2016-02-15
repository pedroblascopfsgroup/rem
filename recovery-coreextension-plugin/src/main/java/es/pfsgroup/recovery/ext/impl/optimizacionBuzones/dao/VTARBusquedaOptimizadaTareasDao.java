package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.factory.dao.HQLBuilderReutilizable;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.ResultadoBusquedaTareasBuzonesDto;

public interface VTARBusquedaOptimizadaTareasDao extends AbstractDao<TareaNotificacion, Long> {

    /**
     * B�squeda de tareas pendientes optimizada. Hace uso de las vistas VTAR_*
     * 
     * @param dto
     * @param conCarterizacion
     * @param usuarioLogado
     * @param modelClass
     * @return
     */
    Page buscarTareasPendiente(DtoBuscarTareaNotificacion dto, boolean conCarterizacion, Usuario usuarioLogado, Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass);

    /**
     * B�squeda de tareas pendientes optimizada. Hace uso de las vistas VTAR_*
     * 
     * @param dto
     * @param conCarterizacion
     * @param usuarioLogado
     * @return
     */
    Long obtenerCantidadDeTareasPendientes(DtoBuscarTareaNotificacion dto, boolean conCarterizacion, Usuario usuarioLogado);

    /**
     * Cuenta las tareas o notificaciones para un usuario.
     * 
     * @param dto
     *            dtoparametro
     * @param conCarterizacion
     *            indica si se quiere hacer uso o no de la funcionalidad de
     *            b�squeda carterizada de tareas
     * @param usuarioLogado
     *            Usuario logado actual
     * @param modelClass
     * @return numero de tareas encontradas
     */
    Integer buscarTareasPendienteCount(DtoBuscarTareaNotificacion dto, boolean conCarterizacion, Usuario usuarioLogado, Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass);

    /**
     * Devuelve el usuario responsable de una tarea.
     * 
     * @param idTarea id de la tarea
     * @return Devuelve null si no encuentra tarea o responsable.
     */
    Usuario obtenerResponsableTarea(Long idTarea);
    
    /**
     * Obtiene el HQL de la busqueda de tareas pendientes.
     * 
     * @param dto
     * @param u
     * @param modelClass
     * @return HQLBuilderReutilizable
     */
    public HQLBuilderReutilizable createHQLBbuscarTareasPendiente(DtoBuscarTareaNotificacion dto, Usuario u, final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass);


}
