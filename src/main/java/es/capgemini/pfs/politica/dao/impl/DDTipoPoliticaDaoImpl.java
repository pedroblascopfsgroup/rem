package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDTipoPoliticaDao;
import es.capgemini.pfs.politica.model.DDTipoPolitica;

/**
 * Implementación de DDTipoPoliticaDao.
 * @author aesteban
 *
 */
@Repository("DDTipoPoliticaDao")
public class DDTipoPoliticaDaoImpl extends AbstractEntityDao<DDTipoPolitica, Long> implements DDTipoPoliticaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoPolitica buscarPorCodigo(String codigo) {
        List<DDTipoPolitica> lista = getHibernateTemplate().find("from DDTipoPolitica where codigo = ?", codigo);
        if (lista.size() > 0) { return lista.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoPolitica buscarTipoPoliticaAsociadaAEntidad(String codigoPoliticaEntidad) {
        List<DDTipoPolitica> lista = getHibernateTemplate().find("from DDTipoPolitica where politicaEntidad.codigo = ?", codigoPoliticaEntidad);
        if (lista.size() > 0) { return lista.get(0); }
        return null;
    }

}
