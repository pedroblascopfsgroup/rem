package es.capgemini.pfs.utils.hibernate;

import es.capgemini.pfs.APPConstants;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedoni
 */
public class HibernateEntitySqlInterceptor extends HibernateSqlInterceptor {

    private static final long serialVersionUID = 9185999207735635719L;

    /**
     * @return "E"
     */
    @Override
    public String getDescription() {
        return "E";
    }

    /**
     * @return APPConstants.ENTITY_SESSION_FACTORY
     */
    @Override
    public String getSessionFactoryName() {
        return APPConstants.ENTITY_SESSION_FACTORY;
    }

}
