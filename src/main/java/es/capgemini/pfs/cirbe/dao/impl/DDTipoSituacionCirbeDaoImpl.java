package es.capgemini.pfs.cirbe.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cirbe.dao.DDTipoSituacionCirbeDao;
import es.capgemini.pfs.cirbe.model.DDTipoSituacionCirbe;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Dao de clase DDCodigoOperacionCirbe.
 *  @author: Pablo Müller
 */
@Repository("DDTipoSituacionCirbeDao")
public class DDTipoSituacionCirbeDaoImpl extends AbstractEntityDao<DDTipoSituacionCirbe, Long> implements DDTipoSituacionCirbeDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<String> getDescripciones() {
        String hql = "select distinct descripcion from DDTipoSituacionCirbe";
        return getHibernateTemplate().find(hql);
    }
}
