package es.capgemini.pfs.test.cache.users;

import static junit.framework.Assert.assertFalse;

import org.junit.Test;

import es.capgemini.devon.test.parallel.ParallelRunnerTests;
import es.capgemini.devon.test.parallel.notifier.DefaultRunNotifier;
import es.capgemini.pfs.test.cache.users.imp.ehcache.User1;
import es.capgemini.pfs.test.cache.users.imp.ehcache.User2;
import es.capgemini.pfs.test.cache.users.imp.ehcache.UserEhCache;

/**
 * 
 * @author lgiavedo
 *
 */

public class ConcurrenceUsersEhCacheTest extends UserEhCache {

    @Test
    public void test() {
        DefaultRunNotifier trn = DefaultRunNotifier.getNewInstance();
        ParallelRunnerTests.runRunnersInParallel(this.getClass(), new Class[] { User1.class, User1.class, User2.class, User2.class }, trn);
        assertFalse(trn.hasError());
        printStatsInfo("");
    }

}
