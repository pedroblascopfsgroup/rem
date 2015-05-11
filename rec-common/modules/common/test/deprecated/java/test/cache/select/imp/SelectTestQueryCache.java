package es.capgemini.pfs.test.cache.select.imp;

import static org.junit.Assert.assertTrue;

import org.springframework.test.context.ContextConfiguration;

@ContextConfiguration
public class SelectTestQueryCache extends SelectAbstractTestCache {

    @Override
    public void checkGetListResults() {
        assertTrue(stats.getQueryExecutionCount() == NUMBER_OF_SELECTS);
        assertTrue(stats.getQueryCacheHitCount() == NUMBER_OF_SELECTS - 1);
        assertTrue(stats.getQueryCacheMissCount() == 1);
        assertTrue(stats.getQueryCachePutCount() == 1);
        assertTrue(stats.getSecondLevelCacheHitCount() == 0);
        assertTrue(stats.getSecondLevelCacheMissCount() == 0);
        assertTrue(stats.getSecondLevelCachePutCount() == 0);

    }

    @Override
    public void checkGetObjectResults(long loadEntityCount) {
        /*
         * Se van a cargar tantas entidades como iteraciones
         */
        assertTrue(loadEntityCount == NUMBER_OF_GETS);
    }
}
