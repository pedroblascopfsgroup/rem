package es.capgemini.pfs.test.cache.select;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

import es.capgemini.devon.test.AbstractLauncherTests;
import es.capgemini.pfs.test.cache.select.imp.SelectTestEHCache;
import es.capgemini.pfs.test.cache.select.imp.SelectTestHashtableCache;
import es.capgemini.pfs.test.cache.select.imp.SelectTestNoCache;
import es.capgemini.pfs.test.cache.select.imp.SelectTestQueryCache;

//@ContextConfiguration
@RunWith(Suite.class)
@Suite.SuiteClasses( { SelectTestNoCache.class, SelectTestQueryCache.class, SelectTestHashtableCache.class, SelectTestEHCache.class })
public class CacheTestSelectSuite extends AbstractLauncherTests {

}
