package es.capgemini.pfs.procesosJudiciales.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.JuzgadoDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;

/**
 * Implementación del dao de juzgado.
 * @author pajimene
 *
 */
@Repository("JuzgadoDao")
public class JuzgadoDaoImpl extends AbstractEntityDao<TipoJuzgado, Long> implements JuzgadoDao {

    /**
     * Devuelve la lista de juzgados de una plaza.
     * @param codigoPlaza String
     * @return la lista de juzgados.
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<TipoJuzgado> getJuzgadosByPlaza(String codigoPlaza) {
        String hql = "from TipoJuzgado where plaza.codigo = ? ORDER BY descripcion";
        return getHibernateTemplate().find(hql, new Object[] { codigoPlaza });
    }

    /**
     * Devuelve un tipo de juzgado según su código.
     * @param codigoJuzgado codigo
     * @return tipo de juzgado.
     */
    @Override
    @SuppressWarnings("unchecked")
    public TipoJuzgado getByCodigo(String codigoJuzgado) {
        String hql = "from TipoJuzgado where codigo = ?";
        List juzgados = getHibernateTemplate().find(hql, new Object[] { codigoJuzgado });

        if (juzgados != null && juzgados.size() == 1) {
            return (TipoJuzgado) juzgados.get(0);
        }

        return null;
    }

}
