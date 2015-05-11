package es.capgemini.pfs.batch.mail;

import java.util.List;

/**
 * Dao de tareas pendientes.
 *
 */
public interface TareasPendientesDao {

    /**
     * Recupera las tareas pendientes.
     * @return lista
     */
    @SuppressWarnings("unchecked")
    List obtenerTareasPendientes();
}
