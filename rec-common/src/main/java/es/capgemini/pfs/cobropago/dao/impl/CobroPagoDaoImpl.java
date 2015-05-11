package es.capgemini.pfs.cobropago.dao.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cobropago.dao.CobroPagoDao;
import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementacion de CobroPagoDao.
 * @author: Lisandro Medrano
 */
@Repository("CobroPagoDao")
public class CobroPagoDaoImpl extends AbstractEntityDao<CobroPago, Long> implements CobroPagoDao {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<CobroPago> getByIdAsunto(Long idAsunto) {
        List<CobroPago> ls = null;
        DetachedCriteria crit = DetachedCriteria.forClass(CobroPago.class);
        crit.add(Expression.eq("asunto.id", idAsunto));
        crit.add(Expression.eq("auditoria.borrado", false));

        try {
            ls = getHibernateTemplate().findByCriteria(crit);
        } catch (Exception e) {
            logger.error(e);
        }
        return ls;
    }
}
