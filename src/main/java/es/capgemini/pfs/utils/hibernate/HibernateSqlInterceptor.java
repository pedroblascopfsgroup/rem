package es.capgemini.pfs.utils.hibernate;

import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.EmptyInterceptor;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.classic.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;

import es.capgemini.devon.hibernate.dao.AbstractHibernateDao;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.PropertyPlaceholderUtils;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.security.model.UsuarioSecurity;

/**
 * TODO DOCUMENTAR FO.
 * @author Nicolás Cornaglia
 */
public abstract class HibernateSqlInterceptor extends EmptyInterceptor {

    private static final long serialVersionUID = 1L;

    private final Log logger = LogFactory.getLog(getClass());

    private Properties properties;

    @Autowired
    private ApplicationContext applicationContext;

    /**
     * @return String
     */
    public abstract String getSessionFactoryName();

    /**
     * @return String
     */
    public abstract String getDescription();

    private String getFristClass() {
        StackTraceElement[] st = Thread.currentThread().getStackTrace();
        if (st != null && st.length > 3) {
            for (int i = 3; i < st.length; i++) {
                if (st[i].getClassName().startsWith(APPConstants.APP_PREFIX)
                        && st[i].getClassName().indexOf(AbstractHibernateDao.class.getName()) == -1) {
                    return st[i].toString();
                }
            }
        }
        return "";
    }

    private String getSession() {
        try {
            Session s = ((SessionFactory) applicationContext.getBean(getSessionFactoryName())).getCurrentSession();
            String res = "S" + s.hashCode();
            if (s.getTransaction() != null) {
                return res + "_T" + s.getTransaction().hashCode();
            }
            return res;
        } catch (Exception ex) {
            return "SN";
        }

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void afterTransactionBegin(Transaction tx) {
        if (logger.isDebugEnabled()) {
            logger.debug(getDescription() + "[H" + Thread.currentThread().getId() + ", " + getSession() + " - " + getFristClass()
                    + " ] ------------   Iniciando TX " + tx.toString() + " ----------------");
        }
        super.afterTransactionBegin(tx);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void afterTransactionCompletion(Transaction tx) {
        if (logger.isDebugEnabled()) {
            logger.debug(getDescription() + "[H" + Thread.currentThread().getId() + ", " + getSession() + " - " + getFristClass()
                    + " ]  ------------   FIN TX " + tx.toString() + " ----------------");
        }
        super.afterTransactionCompletion(tx);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String onPrepareStatement(String sql) {
        String prepedStatement = super.onPrepareStatement(sql);

        Long dbId = DataSourceManager.NO_DATASOURCE_ID;
        
        UsuarioSecurity usuario = null;
        try{usuario=(UsuarioSecurity) SecurityUtils.getCurrentUser();}catch (Exception e) {}
        String entityDBSchema = "";
        if (usuario == null) {
            if (DbIdContextHolder.getDbId() == null) {
                dbId = DataSourceManager.NO_DATASOURCE_ID;
            } else {
                dbId = DbIdContextHolder.getDbId();
                if (dbId != -1) {
                    entityDBSchema = DbIdContextHolder.getDbSchema() + ".";
                }
            }
        } else {
            if (usuario.getEntidad() != null) {
                dbId = usuario.getEntidad().getId();
                entityDBSchema = usuario.getEntidad().getConfiguracion().get(DataSourceManager.SCHEMA_KEY).getDataValue() + ".";
            } else {
                dbId = DataSourceManager.MASTER_DATASOURCE_ID;
            }
        }

        //las tablas de hibernate están en el master,
        //como accedemos mediante el datasource de la entidad, necesitamos el nombre del esquema
        //antes del nombre de las tablas de JBPM (JBPM_***)
        //prepedStatement = prepedStatement.replaceAll(" JBPM_", " pfsmaster.JBPM_");
        prepedStatement = prepedStatement.replaceAll(" JBPM_", " \\${master.schema}.JBPM_");

        prepedStatement = prepedStatement.replaceAll("hibernate_sequence", " \\${master.schema}.hibernate_sequence");
        prepedStatement = prepedStatement.replaceAll("\\$\\{entity\\.schema\\}\\.", entityDBSchema);

        prepedStatement = PropertyPlaceholderUtils.resolve(prepedStatement, properties);
        if (logger.isDebugEnabled()) {
            logger.debug(getDescription() + "[H" + Thread.currentThread().getId() + ", " + getSession() + " - " + getFristClass() + " ] - "
                    + prepedStatement);
        }
        return prepedStatement;
    }

    /**
     * @param properties the properties to set
     */
    public void setProperties(Properties properties) {
        this.properties = properties;
    }

}
