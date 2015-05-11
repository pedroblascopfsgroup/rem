package es.capgemini.pfs.utils.hibernate;

import es.capgemini.pfs.APPConstants;

/**
 *  TODO DOCUMENTAR FO.
 * @author lgiavedoni
 */
public class HibernateMasterSqlInterceptor extends HibernateSqlInterceptor {

    private static final long serialVersionUID = -3572836169092363425L;

    /**
     * @return "M"
     */
    @Override
    public String getDescription() {
        return "M";
    }

    /**
     * @return APPConstants.MASTER_SESSION_FACTORY
     */
    @Override
    public String getSessionFactoryName() {
        return APPConstants.MASTER_SESSION_FACTORY;
    }
}
