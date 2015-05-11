package es.capgemini.pfs.dsm.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractMasterDao;
import es.capgemini.pfs.dsm.dao.EntidadConfigDao;
import es.capgemini.pfs.dsm.model.EntidadConfig;

/**
 * @author Nicolás Cornaglia
 */
@Repository("EntidadConfigDao")
public class EntidadConfigDaoImpl extends AbstractMasterDao<EntidadConfig, Long> implements EntidadConfigDao {

    //    @Override
    //    public EntidadConfig findByWorkingCode(String workingCode) throws DataAccessException {
    //        return (EntidadConfig) (getHibernateTemplate().find("from EntidadConfig ec where ec.workingCode = ?", workingCode)).iterator().next();
    //    }

}
