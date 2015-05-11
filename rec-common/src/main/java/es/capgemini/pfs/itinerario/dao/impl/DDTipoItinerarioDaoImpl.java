package es.capgemini.pfs.itinerario.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.dao.DDTipoItinerarioDao;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;

/**
 * Dao impl DDTipoItinerarioDaoImpl.
 * @author pjimene
 *
 */
@Repository("DDTipoItinerarioDao")
public class DDTipoItinerarioDaoImpl extends AbstractEntityDao<DDTipoItinerario, Long> implements DDTipoItinerarioDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDTipoItinerario> findByCodigo(String codigo) {
        String hsql = "from DDTipoItinerario where codigo = ?";
        return getHibernateTemplate().find(hsql, new Object[] { codigo });
    }
}
