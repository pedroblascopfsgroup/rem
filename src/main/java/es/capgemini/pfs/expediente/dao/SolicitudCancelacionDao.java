package es.capgemini.pfs.expediente.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;

/**
 * Interfaz dao para las solicitudes de cancelación de expediente.
 *
 * @author pamuller
 *
 */
public interface SolicitudCancelacionDao extends AbstractDao<SolicitudCancelacion, Long> {

    /**
     * Devuelve una solicitud de cancelación a partir del id de la tarea que genera.
     * @param idTarea el id de la tarea
     * @return la solicitud de cancelación o null si no existe.
     */
    SolicitudCancelacion buscarSolicitudPorTarea(Long idTarea);
}
