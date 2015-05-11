package es.capgemini.pfs.procesosJudiciales.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaProcedimientoDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

/**
 * Implementacion del dao de TareaProcedimientoDao para Hibenate.
 *
 * @author pamuller
 *
 */
@Repository("TareaProcedimientoDao")
public class TareaProcedimientoDaoImpl extends AbstractEntityDao<TareaProcedimiento, Long> implements TareaProcedimientoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public TareaProcedimiento buscarPorTipoProcedimientoPorCodigo(String codigoTarea) {
        String hql = " select t from TareaProcedimiento t where ";
        hql += " t.codigo = ?";
        hql += " and t.auditoria.borrado = false ";

        List result = getHibernateTemplate().find(hql, codigoTarea);
        if (result.size() > 0) {
            return (TareaProcedimiento) result.get(0);
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<TareaProcedimiento> getByTipoProcedimiento(String codigoTipoProcedimiento) {
        String hql = "from TareaProcedimiento where tipoProcedimiento.codigo = ?";
        List<TareaProcedimiento> lista = getHibernateTemplate().find(hql, new Object[] { codigoTipoProcedimiento });
        if (lista.size() > 0) {
            return lista;
        }
        return null;
    }

    /**
    * {@inheritDoc}
    */
    @SuppressWarnings("unchecked")
    @Override
    public TareaProcedimiento getByCodigoTareaIdTipoProcedimiento(Long idTipoProcedimiento, String codigoTarea) {
        TareaProcedimiento tp = null;
        String hql = "from TareaProcedimiento where tipoProcedimiento.id = ? and codigo = ?";
        List<TareaProcedimiento> ls = getHibernateTemplate().find(hql, new Object[] { idTipoProcedimiento, codigoTarea });
        if (ls.size() > 0) {
            tp = ls.get(0);
        }
        return tp;
    }
}
