package es.capgemini.pfs.autologin.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.autologin.model.Token;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementacion de TokenDao.
 */
@Repository("TokenDao")
public class TokenDaoImpl extends AbstractEntityDao<Token, Long> implements TokenDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Token getByToken(String token) {
        String hsql = "from Token where token='" + token + "' and auditoria.borrado = false";
        List<Token> lista = getHibernateTemplate().find(hsql);
        if (lista != null && lista.size() > 0) { return lista.get(0); }
        return null;
    }

}
