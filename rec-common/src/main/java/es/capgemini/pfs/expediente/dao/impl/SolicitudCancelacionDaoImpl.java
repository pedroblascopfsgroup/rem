package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.SolicitudCancelacionDao;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;

/**
 * Implementación del dao de solicitudes de cancelación de expediente.
 *
 * @author pamuller
 */
@Repository("SolicitudCancelacionDao")
public class SolicitudCancelacionDaoImpl extends AbstractEntityDao<SolicitudCancelacion, Long> implements SolicitudCancelacionDao {

    /**
     * Devuelve una solicitud de cancelación a partir del id de la tarea que genera.
     * @param idTarea el id de la tarea
     * @return la solicitud de cancelación o null si no existe.
     */
    @SuppressWarnings("unchecked")
    public SolicitudCancelacion buscarSolicitudPorTarea(Long idTarea) {
        String hql = "select sc from SolicitudCancelacion sc, TareaNotificacion tn where sc = tn.solicitudCancelacion and tn.id = ?";
        List<SolicitudCancelacion> lista = getHibernateTemplate().find(hql, idTarea);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }
}
