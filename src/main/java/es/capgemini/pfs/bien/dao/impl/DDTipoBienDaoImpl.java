package es.capgemini.pfs.bien.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.dao.DDTipoBienDao;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementacion del dao DDTipoBienDao.
 *
 */
@Repository("DDTipoBienDao")
public class DDTipoBienDaoImpl extends AbstractEntityDao<DDTipoBien, Long> implements DDTipoBienDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoBien getByCodigo(String codigo) {
        String hql = "from DDTipoBien tipoBien where tipoBien.codigo = ? and tipoBien.auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDTipoBien> tipoBien = getHibernateTemplate().find(hql, new Object[] { codigo });
        if(tipoBien.size()==0) {
            return null;
        } else if(tipoBien.size()==1) {
            return tipoBien.get(0);
        } else {
            throw new BusinessOperationException("tipoBien.error.duplicado");
        }
    }

}
