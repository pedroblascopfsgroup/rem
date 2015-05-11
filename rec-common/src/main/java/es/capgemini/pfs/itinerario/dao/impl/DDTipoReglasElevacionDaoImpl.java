package es.capgemini.pfs.itinerario.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.dao.DDTipoReglasElevacionDao;
import es.capgemini.pfs.itinerario.model.DDTipoReglasElevacion;

/**
 * Dao impl DDTipoReglasElevacionDaoImpl.
 * @author pjimene
 *
 */
@Repository("DDTipoReglasElevacionDao")
public class DDTipoReglasElevacionDaoImpl extends AbstractEntityDao<DDTipoReglasElevacion, Long> implements DDTipoReglasElevacionDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDTipoReglasElevacion> findByCodigo(String codigo) {
        String hsql = "from DDTipoReglasElevacion where codigo = ?";
        return getHibernateTemplate().find(hsql, new Object[] { codigo });
    }
}
