package es.capgemini.pfs.tareaNotificacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Interfaz dao para los subtipos de tareas.
 * @author pamuller
 *
 */
public interface SubtipoTareaDao extends AbstractDao<SubtipoTarea, Long> {

    /**
     * Busca un SubtipoTarea por su código.
     * @param codigoSubtarea el código del subtipo de tarea que se busca.
     * @return el subtipo de tarea si existe.
     */
    SubtipoTarea buscarPorCodigo(String codigoSubtarea);

}
