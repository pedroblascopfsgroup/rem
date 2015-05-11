package es.capgemini.pfs.users.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.dao.PerfilDao;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * implementacion del dao perfil.
 * @author jbosnjak
 *
 */
@Repository("PerfilDao")
public class PerfilDaoImpl extends AbstractEntityDao<Perfil, Long> implements PerfilDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Perfil buscarPorCodigo(String codigo) {
        List<Perfil> lista = getHibernateTemplate().find("from Perfil where codigo = ?", codigo);
        if (lista.size() > 0) { return lista.get(0); }
        return null;
    }
}
