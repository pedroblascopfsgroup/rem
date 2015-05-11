package es.capgemini.pfs.dsm.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractMasterDao;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;

/**
 * @author Nicolás Cornaglia
 */
@Repository("EntidadDao")
public class EntidadDaoImpl extends AbstractMasterDao<Entidad, Long> implements EntidadDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public Entidad findByWorkingCode(String workingCode) {
        return (Entidad) (getHibernateTemplate().find(
                "select c.entidad from EntidadConfig c where c.dataKey='workingCode' and c.dataValue = ?", workingCode)).iterator().next();
    }

}
