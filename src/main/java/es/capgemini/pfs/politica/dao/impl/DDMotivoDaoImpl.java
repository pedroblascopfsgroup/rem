package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDMotivoDao;
import es.capgemini.pfs.politica.model.DDMotivo;

/**
 * Implementación de DDMotivoDao.
 * @author aesteban
 *
 */
@Repository("DDMotivoDao")
public class DDMotivoDaoImpl extends AbstractEntityDao<DDMotivo, Long> implements DDMotivoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDMotivo buscarPorCodigo(String codigo) {
        List<DDMotivo> lista = getHibernateTemplate().find("from DDMotivo where codigo = ?",codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }

}
