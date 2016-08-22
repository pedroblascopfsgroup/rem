package es.capgemini.pfs.web.genericForm.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.capgemini.pfs.web.genericForm.dao.GenericFormDao;

@Repository("GenericFormDaoImpl")
public class GenericFormDaoImpl extends AbstractEntityDao<GenericForm, Long> implements GenericFormDao {
    @Autowired
    private TipoProcedimientoDao tipoProcedimientoDao;

    @Override
    public GenericForm getByTipoProcedimiento(Long idTipoProcedimiento) {

        TipoProcedimiento tipoProcedimiento = tipoProcedimientoDao.get(idTipoProcedimiento);

        return (GenericForm) getHibernateTemplate().findByCriteria(
                DetachedCriteria.forClass(GenericForm.class).add(Expression.eq("tipoProcedimiento", tipoProcedimiento)));
        //return null;
    };

    @Override
    public GenericForm getByCodigoTipoProcedimiento(String codigoTipoProcedimiento) {

        TipoProcedimiento tipoProcedimiento = tipoProcedimientoDao.getByCodigo(codigoTipoProcedimiento);

        return (GenericForm) getHibernateTemplate().findByCriteria(
                DetachedCriteria.forClass(GenericForm.class).add(Expression.eq("tipoProcedimiento", tipoProcedimiento)));
        //return null;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<GenericForm> getByTipoProcedimiento(String codigoTipoProcedimiento) {
        String hql = "from GenericForm where tipoProcedimiento.codigo = ?";
        List<GenericForm> lista = getHibernateTemplate().find(hql, new Object[] { codigoTipoProcedimiento });
        if (lista.size() > 0) {
            return lista;
        }
        return null;
    }

}
