package es.capgemini.pfs.test.cache;

import java.util.Date;

import org.hibernate.SessionFactory;
import org.hibernate.stat.Statistics;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;

import es.capgemini.devon.test.AbstractLauncherTests;
import es.capgemini.devon.utils.DbIdContextHolder;

public abstract class CacheAbstractTest extends AbstractLauncherTests {

    public Statistics stats;

    @BeforeClass
    public static void beforeClass() {
        DbIdContextHolder.setDbId(1L);
    }

    @Before
    public void enableStatistics() {
        enableHibernateLazyMode();
        if (stats == null) stats = ((SessionFactory) applicationContext.getBean(ENTITY_SESSION_FACTORY)).getStatistics();
        if (!stats.isStatisticsEnabled()) {
            stats.setStatisticsEnabled(true);
            //stats.logSummary();
        }
    }

    @After
    public void flush() {
        flushHibernateSession();
    }

    public void printStatsInfo(String method) {
        System.out.println("************** " + getClass().getName() + "." + method + " ************");
        System.out.println("QueryExecutionTime: " + (new Date().getTime() - stats.getStartTime()) + " mseg.");
        System.out.println("QueryExecution: " + stats.getQueryExecutionCount());
        System.out.println("ConnectCount: " + stats.getConnectCount());
        System.out.println("TransactionCount: " + stats.getTransactionCount());
        System.out.println("PrepareStatementCount: " + stats.getPrepareStatementCount());
        System.out.println("EntityLoadCount: " + stats.getEntityLoadCount());
        System.out.println("Entity[Persona]LoadCount: " + stats.getEntityStatistics("es.capgemini.pfs.persona.model.Persona").getLoadCount());
        System.out.println("Entity[Cliente]LoadCount: " + stats.getEntityStatistics("es.capgemini.pfs.cliente.model.Cliente").getLoadCount());

        System.out.println("Query Cache");
        System.out.println("         QueryCacheHit: " + stats.getQueryCacheHitCount());
        System.out.println("         QueryCacheMiss: " + stats.getQueryCacheMissCount());
        System.out.println("         QueryCachePut: " + stats.getQueryCachePutCount());

        System.out.println("Second Level Cache");
        System.out.println("         SecondLevelCacheHit: " + stats.getSecondLevelCacheHitCount());
        System.out.println("         SecondLevelCacheMiss: " + stats.getSecondLevelCacheMissCount());
        System.out.println("         SecondLevelCachePut: " + stats.getSecondLevelCachePutCount());

        System.out.println("********************************************");

    }

}
