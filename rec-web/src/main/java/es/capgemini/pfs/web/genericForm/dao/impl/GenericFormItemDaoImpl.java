package es.capgemini.pfs.web.genericForm.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.web.genericForm.dao.GenericFormItemDao;

@Repository("GenericFormItemDaoImpl")
public class GenericFormItemDaoImpl extends AbstractEntityDao<GenericFormItem, Long> implements GenericFormItemDao {

    @SuppressWarnings("unchecked")
    @Override
    public List<GenericFormItem> getByIdTareaProcedimiento(Long id) {
        DetachedCriteria criteria = DetachedCriteria.forClass(GenericFormItem.class);
        criteria.add(Restrictions.eq("tareaProcedimiento.id", id)).addOrder(Order.asc("order"));
        return getHibernateTemplate().findByCriteria(criteria);
    }

}
