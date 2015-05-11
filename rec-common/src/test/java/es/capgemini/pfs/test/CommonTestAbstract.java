package es.capgemini.pfs.test;

import static org.junit.Assert.fail;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Properties;

import org.hibernate.FlushMode;
import org.hibernate.SessionFactory;
import org.junit.Before;
import org.junit.BeforeClass;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
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
@ContextConfiguration(locations = { "classpath:CommonTestAbstract-context.xml", "classpath:CommonTestAbstract-sqlContext.xml" })
public abstract class CommonTestAbstract extends AbstractJUnit4SpringContextTests {

    @javax.annotation.Resource
    private Properties appProperties;
    @Autowired
    private EntityDataSource entityDataSource;

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

    //-------------------------------------------------------------------------------------
    //    Manejo de archivos
    //-------------------------------------------------------------------------------------

    /**
     * Calcula el directorio de la clase indicada.
     * @param clazz clase
     * @return paquete
     */
    @SuppressWarnings("unchecked")
    protected static String getPackage(Class clazz) {
        return clazz.getPackage().toString().replaceAll("package ", "").replace('.', '/') + "/";
    }

    /**
     * Crea el archivo para el nombre completo indicado.
     * @param clazz el paquete donde se encuentra el archivo.
     * @param fileName String
     * @return File
     */
    @SuppressWarnings("unchecked")
    protected File getTestFile(Class clazz, String fileName) {
        String fullName = getPackage(clazz) + fileName;
        try {
            return (new ClassPathResource(fullName)).getFile();
        } catch (IOException e) {
            fail("No existe el archivo para el test: " + fullName);
        }
        return null;
    }
    
    public void sleep(long msTime){
        try {
            Thread.sleep(msTime);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

}
