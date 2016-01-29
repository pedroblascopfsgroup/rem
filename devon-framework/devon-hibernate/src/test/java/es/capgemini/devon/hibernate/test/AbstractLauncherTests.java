package es.capgemini.devon.hibernate.test;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.apache.commons.lang.ClassUtils;
import org.hibernate.FlushMode;
import org.hibernate.SessionFactory;
import org.junit.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.SessionHolder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import es.capgemini.devon.utils.DatabaseUtils;

/**
 * @author Nicolás Cornaglia
 */
@ContextConfiguration(locations = { "classpath:ac-devon-test.xml" })
public abstract class AbstractLauncherTests extends AbstractJUnit4SpringContextTests {

    protected static final String ENTITY_SESSION_FACTORY = "entitySessionFactory";
    protected static final String MASTER_SESSION_FACTORY = "masterSessionFactory";
    protected SessionFactory sessionFactory = null;

    @Autowired(required = false)
    protected ApplicationContext applicationContext;

    @Autowired(required = false)
    @Qualifier("dataSource")
    private DataSource dataSource;

    @Resource
    private Properties appProperties;

    // private static final Log logger =
    // LogFactory.getLog(SpringJUnit4ClassRunner.class);

    private static boolean runScript = true;
    private static String scriptPath = null;

    @Before
    public void onSetUpParent() {
        if (runScript && dataSource != null) {
            try {
                scriptPath = this.getClass().getResource("").toURI().getPath() + ClassUtils.getShortClassName(this.getClass());
                File script = new File(scriptPath + "-before.sql");
                if (script.exists()) DatabaseUtils.executeScript(dataSource, new FileInputStream(script), null, false, appProperties);
            } catch (Exception ex) {
                System.out.println(ex);
            }
            runScript = false;
        }
    }

    /**
     * Metodo encargado de modificar el flushMode de Hibernate para que se mantenga una unica sesion
     * y se pueda realizar referencia a objetos definidos como lazy.
     */
    public void enableHibernateLazyMode() {
        sessionFactory = (SessionFactory) applicationContext.getBean(ENTITY_SESSION_FACTORY);
        org.hibernate.Session session = SessionFactoryUtils.getSession(sessionFactory, true);
        if (session.getFlushMode() != FlushMode.COMMIT) {
            session.setFlushMode(FlushMode.COMMIT);
            TransactionSynchronizationManager.bindResource(sessionFactory, new SessionHolder(session));
        }

        sessionFactory = (SessionFactory) applicationContext.getBean(MASTER_SESSION_FACTORY);
        session = SessionFactoryUtils.getSession(sessionFactory, true);
        if (session.getFlushMode() != FlushMode.COMMIT) {
            session.setFlushMode(FlushMode.COMMIT);
            TransactionSynchronizationManager.bindResource(sessionFactory, new SessionHolder(session));
        }
    }

    /**
     * Metodo encargado de realizar un flush en la sesion de hibernate.
     */
    public void flushHibernateSession() {
        sessionFactory = (SessionFactory) applicationContext.getBean(MASTER_SESSION_FACTORY);
        org.hibernate.Session session = SessionFactoryUtils.getSession(sessionFactory, true);
        session.flush();

        sessionFactory = (SessionFactory) applicationContext.getBean(ENTITY_SESSION_FACTORY);
        session = SessionFactoryUtils.getSession(sessionFactory, true);
        session.flush();
    }

    /**
     * Metodo encargado de realizar un clear de la sesion de hibernate.
     */
    public void clearHibernateSession() {
        sessionFactory = (SessionFactory) applicationContext.getBean(MASTER_SESSION_FACTORY);
        org.hibernate.Session session = SessionFactoryUtils.getSession(sessionFactory, true);
        session.clear();

        sessionFactory = (SessionFactory) applicationContext.getBean(ENTITY_SESSION_FACTORY);
        session = SessionFactoryUtils.getSession(sessionFactory, true);
        session.clear();
    }

}
