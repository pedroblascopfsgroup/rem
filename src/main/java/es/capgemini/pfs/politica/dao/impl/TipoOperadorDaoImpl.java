package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.TipoOperadorDao;
import es.capgemini.pfs.politica.model.DDTipoOperador;

/**
 * Implementación de TipoOperadorDao.
 * @author aesteban
 *
 */
@Repository("TipoOperadorDao")
public class TipoOperadorDaoImpl extends AbstractEntityDao<DDTipoOperador, Long> implements TipoOperadorDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoOperador findByCodigo(String codigo) {
        List<DDTipoOperador> lista = getHibernateTemplate().find("from DDTipoOperador where codigo = ?", codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }
}
