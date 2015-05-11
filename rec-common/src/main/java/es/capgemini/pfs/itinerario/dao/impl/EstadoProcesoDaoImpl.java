package es.capgemini.pfs.itinerario.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.dao.EstadoProcesoDao;
import es.capgemini.pfs.itinerario.model.EstadoProceso;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Implementación del dao de estados proceso.
 * @author pamuller
 *
 */
@Repository("EstadoProcesoDao")
public class EstadoProcesoDaoImpl extends AbstractEntityDao<EstadoProceso, Long> implements EstadoProcesoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public EstadoProceso buscarEstadoActivo(Long entidad, String codigoTipoEntidad) {
        String hql = " from EstadoProceso ep where ep.auditoria.borrado = false and ";
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codigoTipoEntidad)) {
            hql += "ep.asunto.id = ?";
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(codigoTipoEntidad)) {
            hql += "ep.expediente.id = ?";
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(codigoTipoEntidad)) {
            hql += "ep.cliente.id = ?";
        }

        List<EstadoProceso> estados = getHibernateTemplate().find(hql, entidad);
        if (estados.size() > 1) {
            throw new BusinessOperationException("Hay mas de un estado activo para la entidad " + codigoTipoEntidad + " con el id "
                    + entidad);
        }
        if (estados.size() == 1) {
            return estados.get(0);
        }
        return null;
    }

}
