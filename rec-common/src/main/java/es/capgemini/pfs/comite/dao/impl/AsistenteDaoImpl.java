package es.capgemini.pfs.comite.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.dao.AsistenteDao;
import es.capgemini.pfs.comite.model.Asistente;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Andrés Esteban
 *
 */
@Repository("AsistenteDao")
public class AsistenteDaoImpl extends AbstractEntityDao<Asistente, Long> implements AsistenteDao {

    /**
     * {@inheritDoc}
     */
    public void saveAndFlush(Asistente t) {
        super.save(t);
        getHibernateTemplate().flush();
    }
}
