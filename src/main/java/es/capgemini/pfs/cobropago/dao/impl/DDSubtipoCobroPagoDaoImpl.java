package es.capgemini.pfs.cobropago.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cobropago.dao.DDSubtipoCobroPagoDao;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.cobropago.model.DDTipoCobroPago;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.diccionarios.DictionaryManager;

/**
 * Implementacion de DDSubtipoCobroPagoDao.
 * @author: Lisandro Medrano
 */
@Repository("DDSubtipoCobroPagoDao")
public class DDSubtipoCobroPagoDaoImpl extends AbstractEntityDao<DDSubtipoCobroPago, Long> implements DDSubtipoCobroPagoDao {

    @Autowired
    private DictionaryManager dictionaryManager;

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDSubtipoCobroPago> getByTipo(String codigoTipo) {
        DetachedCriteria crit = DetachedCriteria.forClass(DDSubtipoCobroPago.class);
        DDTipoCobroPago tipo = (DDTipoCobroPago) dictionaryManager.getByCode(DDTipoCobroPago.class, codigoTipo);
        crit.add(Expression.like("tipoCobroPago", tipo));
        return getHibernateTemplate().findByCriteria(crit);
    }
}
