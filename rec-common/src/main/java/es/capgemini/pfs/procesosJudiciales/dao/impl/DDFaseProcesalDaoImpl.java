package es.capgemini.pfs.procesosJudiciales.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.DDFaseProcesalDao;
import es.capgemini.pfs.procesosJudiciales.model.DDFaseProcesal;

/**
 * Implementación del dao de juzgado.
 * @author pajimene
 *
 */
@Repository("DDFaseProcesalDao")
public class DDFaseProcesalDaoImpl extends AbstractEntityDao<DDFaseProcesal, Long> implements DDFaseProcesalDao {

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public DDFaseProcesal getByCodigo(String codigoFase) {
        String hql = "from DDFaseProcesal where codigo = ?";
        List fases = getHibernateTemplate().find(hql, new Object[] { codigoFase });

        if (fases != null && fases.size() == 1) { return (DDFaseProcesal) fases.get(0); }

        return null;
    }

}
