package es.capgemini.pfs.test.cache.entity;

import static junit.framework.Assert.assertFalse;

import org.junit.Test;

import es.capgemini.devon.test.parallel.ParallelRunnerTests;
import es.capgemini.devon.test.parallel.notifier.DefaultRunNotifier;
import es.capgemini.pfs.test.cache.users.imp.ehcache.UserEhCache;

/**
 * 
 * @author lgiavedo
 *
 */

public class ConcurrenceEntityCacheTest extends UserEhCache {

    @Test
    public void test() {
        DefaultRunNotifier trn = DefaultRunNotifier.getNewInstance();
        ParallelRunnerTests.runRunnersInParallel(this.getClass(), new Class[] { Entity1.class, Entity2.class }, trn);
        assertFalse(trn.hasError());
        printStatsInfo("");
    }

}
