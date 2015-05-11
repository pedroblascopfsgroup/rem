package es.capgemini.pfs.itinerario.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.dao.ReglasElevacionDao;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;

/**
 * Dao impl ReglasElevacionDaoImpl.
 * @author pjimene
 *
 */
@Repository("ReglasElevacionDao")
public class ReglasElevacionDaoImpl extends AbstractEntityDao<ReglasElevacion, Long> implements ReglasElevacionDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<ReglasElevacion> findByTipoAndEstado(Long idTipoReglaElevacion, Long idEstadoItinerario) {
        StringBuffer sb = new StringBuffer();
        sb.append("select re from ReglasElevacion re ");
        sb.append(" where re.tipoReglaElevacion.id = ? ");
        sb.append(" and re.estadoItinerario.id = ?");
        return getHibernateTemplate().find(sb.toString(), new Object[] { idTipoReglaElevacion, idEstadoItinerario });

    }

}
