package es.capgemini.pfs.test.cache.select.imp;

import org.hibernate.stat.Statistics;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.persona.PersonaManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.test.cache.CacheAbstractTest;

public abstract class SelectAbstractTestCache extends CacheAbstractTest {

    public final int NUMBER_OF_SELECTS = 100;
    public final int NUMBER_OF_GETS = 100;

    @Autowired
    private PersonaManager personaManager;

    public Statistics stats;

    @BeforeClass
    public static void beforeClass() {
        DbIdContextHolder.setDbId(1L);
    }

    //@Test
    public void getListTest() {
        for (int i = 0; i < NUMBER_OF_SELECTS; i++)
            personaManager.getList();

        printStatsInfo("getListTest");
        checkGetListResults();
    }

    @Test
    public void getObjectTest() {
        Persona p = null;
        for (int i = 0; i < NUMBER_OF_GETS; i++)
            p = personaManager.get(1L);

        printStatsInfo("getObjectTest");
        checkGetObjectResults(stats.getEntityStatistics("es.capgemini.pfs.persona.model.Persona").getLoadCount());
    }

    public abstract void checkGetListResults();

    public abstract void checkGetObjectResults(long loadEntityCount);

}
