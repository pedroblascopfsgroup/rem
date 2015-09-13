package es.pfgroup.monioring.bach.test.load.logic.CheckStatusLogicImpl;

import static org.mockito.Mockito.mock;

import java.util.Date;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;

import es.pfgroup.monioring.bach.load.dao.CheckStatusDao;
import es.pfgroup.monioring.bach.load.logic.CheckStatusLogicImpl;

public abstract class AbstractCheckStatusLogicImplTests {

    protected CheckStatusLogicImpl manager;
    protected CheckStatusDao dao;
    protected String jobName;
    protected Integer entity;
    protected Date lastTime;

    @Before
    public void before() {
        final Random random = new Random();
        dao = mock(CheckStatusDao.class);
        manager = new CheckStatusLogicImpl(dao);
        jobName = RandomStringUtils.randomAlphabetic(100);
        entity = random.nextInt();
        lastTime = new Date(random.nextLong());
    }

    @After
    public void after() {
        dao = null;
        manager = null;
        jobName = null;
        entity = null;
        lastTime = null;
    }
    

}
