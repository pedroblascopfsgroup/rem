package es.capgemini.pfs.autologin.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.autologin.dao.TokenDao;

/**
 * Manager para los token.
 *
 */
@Service
public class TokenManager {

    @Autowired
    private TokenDao tokenDao;

    /**
     * Recupera un token.
     * @param token String
     * @return Token
     */
    public Token getToken(String token) {
        return tokenDao.getByToken(token);
    }
}
