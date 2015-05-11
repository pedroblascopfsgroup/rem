package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.TipoObjetivoDao;
import es.capgemini.pfs.politica.model.DDTipoObjetivo;

/**
 * Implementación de TipoObjetivoDao.
 * @author aesteban
 *
 */
@Repository("TipoObjetivoDao")
public class TipoObjetivoDaoImpl extends AbstractEntityDao<DDTipoObjetivo, Long> implements TipoObjetivoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoObjetivo findByCodigo(String codigo) {
        List<DDTipoObjetivo> lista = getHibernateTemplate().find("from DDTipoObjetivo where codigo = ?", codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }
}
