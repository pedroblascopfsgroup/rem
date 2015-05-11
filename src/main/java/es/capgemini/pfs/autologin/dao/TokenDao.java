package es.capgemini.pfs.autologin.dao;

import es.capgemini.pfs.autologin.model.Token;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * TODO COMENTAR FO.
 */
public interface TokenDao extends AbstractDao<Token, Long> {

    /**
     * TODO COMENTAR FO.
     * @param token String
     * @return Token
     */
    Token getByToken(String token);
}
