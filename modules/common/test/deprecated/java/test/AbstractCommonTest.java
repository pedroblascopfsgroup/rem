package es.capgemini.pfs.test;

import java.text.SimpleDateFormat;
import java.util.Properties;

import org.hibernate.FlushMode;
import org.hibernate.SessionFactory;
import org.junit.Before;
import org.junit.BeforeClass;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.SessionHolder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import es.capgemini.devon.utils.DatabaseUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.EntityDataSource;

/**
 * Clase que agrupa la configuración y métodos comunes.
 *
 */
@ContextConfiguration
public abstract class AbstractCommonTest extends AbstractJUnit4SpringContextTests {

    @javax.annotation.Resource
    private Properties appProperties;
    @Autowired
    private EntityDataSource entityDataSource;

    @javax.annotation.Resource
    private Resource cleanAll;
    @javax.annotation.Resource
    private Resource entityDataLoadScriptTest;
    @javax.annotation.Resource
    private Resource deleteJobs;

    protected static final SimpleDateFormat DF = new SimpleDateFormat("dd/MM/yyyy");
    /**
     * Código a ejecutar antes de todos los tests de esta clase (Se ejecuta una sola vez).
     * Ejemplo: La generación de la base de datos se hace mediante configuracion en
     * "jdbc.test.properties" pero podría hacerse aquí.
     */
    @BeforeClass
    public static void beforeClass() {
        DbIdContextHolder.setDbId(1L);
    }

    //-------------------------------------------------------------------------------------
    //    M�todos que ejecutan scripts
    //-------------------------------------------------------------------------------------
    /**
     * Limpia la bbdd de la entidad y los jobs del master.
     */
    protected void cleanDDBB() {
        executeScript(cleanAll);
    }

    /**
     * Limpia los jobs.
     */
    protected void cleanJobs() {
        executeScript(deleteJobs);
    }

    /**
     * Carga todos los itinerarios, arquetipos, estados, tipo de productos, etc, etc. que es comun para todos.
     * Ejecuta el script entityDataLoadScriptTest.sql
     */
    protected void cargarDatosComunes() {
        executeScript(entityDataLoadScriptTest);
    }

    /**
     * Ejecuta un script.
     * @param script Resource
     */
    protected void executeScript(Resource script) {
        DatabaseUtils.executeScript(entityDataSource, script, null, true, appProperties);
    }

    //-------------------------------------------------------------------------------------
    //    M�todos de hibernate
    //-------------------------------------------------------------------------------------
    protected static final String SESSION_FACTORY = "entitySessionFactory";
    private SessionFactory sessionFactory = null;

    /**
     * Metodo encargado de modificar el flushMode de Hibernate para que se mantenga una unica sesion
     * y se pueda realizar referencia a objetos definidos como lazy.
     */
    @Before
    public void enableHibernateLazyMode() {
        sessionFactory = (SessionFactory) applicationContext.getBean(SESSION_FACTORY);
        org.hibernate.Session session = SessionFactoryUtils.getSession(sessionFactory, true);
        if (session.getFlushMode() != FlushMode.COMMIT) {
            session.setFlushMode(FlushMode.COMMIT);
            TransactionSynchronizationManager.bindResource(sessionFactory, new SessionHolder(session));
        }
    }

    /**
     * Metodo encargado de realizar un flush en la sesion de hibernate.
     */
    public void flushHibernateSession() {
        sessionFactory = (SessionFactory) applicationContext.getBean(SESSION_FACTORY);
        org.hibernate.Session session = SessionFactoryUtils.getSession(sessionFactory, true);
        session.flush();
    }

    /**
     * Metodo encargado de realizar un clear de la sesion de hibernate.
     */
    public void clearHibernateSession() {
        sessionFactory = (SessionFactory) applicationContext.getBean(SESSION_FACTORY);
        org.hibernate.Session session = SessionFactoryUtils.getSession(sessionFactory, true);
        session.clear();
    }
}
