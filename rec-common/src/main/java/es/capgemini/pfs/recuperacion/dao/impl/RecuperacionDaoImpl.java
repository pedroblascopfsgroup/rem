package es.capgemini.pfs.recuperacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.recuperacion.dao.RecuperacionDao;
import es.capgemini.pfs.recuperacion.model.Recuperacion;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("RecuperacionDao")
public class RecuperacionDaoImpl extends AbstractEntityDao<Recuperacion, Long> implements RecuperacionDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Recuperacion getUltimaRecuperacionByContrato(Long idContrato) {
        String hql = "FROM Recuperacion WHERE contrato.id= ? AND fechaEntrega IS NOT NULL ORDER BY fechaEntrega DESC";

        List<Recuperacion> list = getHibernateTemplate().find(hql, new Object[] { idContrato });
        if (list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

}
