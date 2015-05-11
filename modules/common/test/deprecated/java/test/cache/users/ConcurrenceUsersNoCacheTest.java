package es.capgemini.pfs.test.cache.users;

import static junit.framework.Assert.assertFalse;

import org.junit.Test;

import es.capgemini.devon.test.parallel.ParallelRunnerTests;
import es.capgemini.devon.test.parallel.notifier.DefaultRunNotifier;
import es.capgemini.pfs.test.cache.users.imp.nocache.User1;
import es.capgemini.pfs.test.cache.users.imp.nocache.UserNoCache;

/**
 * 
 * @author lgiavedo
 *
 */

public class ConcurrenceUsersNoCacheTest extends UserNoCache {

    @Test
    public void test() {
        DefaultRunNotifier trn = DefaultRunNotifier.getNewInstance();
        ParallelRunnerTests.runRunnersInParallel(this.getClass(), new Class[] { User1.class /*, User1.class, User2.class, User2.class*/}, trn);
        assertFalse(trn.hasError());
        printStatsInfo("");
    }

}
