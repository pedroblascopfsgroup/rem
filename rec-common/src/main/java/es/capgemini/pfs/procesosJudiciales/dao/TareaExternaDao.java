package es.capgemini.pfs.procesosJudiciales.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

/**
 * Interfaz dao para las tareas TareaExterna.
 *
 */
public interface TareaExternaDao extends AbstractDao<TareaExterna, Long> {
    /**
     * TODO DOCUMENTAR FO.
     * @param id long
     * @return TareaExterna
     */
    TareaExterna getByIdTareaNotificacion(Long id);

    /**
     * Obtiene las tareas de un procedimiento a partir de su id.
     * @param idProcedimiento long
     * @return List TareaExterna
     */
    List<TareaExterna> obtenerTareasGestorPorProcedimiento(Long idProcedimiento);

    /**
     * Obtiene las tareas de un procedimiento a partir de su id.
     * @param idProcedimiento Long
     * @return  List TareaExterna
     */
    List<TareaExterna> obtenerTareasSupervisorPorProcedimiento(Long idProcedimiento);

    /**
     * Obtiene las tareas de un procedimiento a partir de su id.
     * @param idProcedimiento Long
     * @return List TareaExterna
     */
    List<TareaExterna> obtenerTareasPorProcedimiento(Long idProcedimiento);

    /**
     *  TODO DOCUMENTAR FO.
     * @param idToken Long
     * @return TareaExterna
     */
    TareaExterna obtenerTareaPorToken(Long idToken);

    /**
     *  TODO DOCUMENTAR FO.
     * @param idProcedimiento Long
     * @param idTareaProcedimiento Long
     * @return List TareaExterna
     */
    List<TareaExterna> getByIdTareaProcedimientoIdProcedimiento(Long idProcedimiento, Long idTareaProcedimiento);

    /**
     *  TODO DOCUMENTAR FO.
     * @param idProcedimiento Long
     * @return List TareaExterna
     */
    List<TareaExterna> getActivasByIdProcedimiento(Long idProcedimiento);

}
