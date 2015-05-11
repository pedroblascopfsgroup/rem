package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchFileHandler;

import static org.junit.Assert.*;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchFileHandler;

public class PFSBatchFileHandlerPropertiesTest {

    private PFSBatchFileHandler handler;
    private String channelName;
    private String jobLauncherKey;
    private String semaphoreName;
    private String chainChannel;
    private String channel;

    @Before
    public void before() {
        channelName = RandomStringUtils.random(100);
        jobLauncherKey = RandomStringUtils.random(100);
        semaphoreName = RandomStringUtils.random(100);
        chainChannel = RandomStringUtils.random(100);
        channel = RandomStringUtils.random(100);

        handler = new PFSBatchFileHandler();
        handler.setChannelName(channelName);
        handler.setJobLauncherKey(jobLauncherKey);
        handler.setSemaphoreName(semaphoreName);
        handler.setChainChannel(chainChannel);
        handler.setChannel(channel);
    }

    @After
    public void after() {
        handler = null;
        channelName = null;
        jobLauncherKey = null;
        semaphoreName = null;
        chainChannel = null;
        channel = null;
    }

    @Test
    public void testSettersAndGetters() {
        assertEquals(channelName, handler.getChannelName());
        assertEquals(jobLauncherKey, handler.getJobLauncherKey());
        assertEquals(semaphoreName, handler.getSemaphoreName());
        assertEquals(chainChannel, handler.getChainChannel());
        assertEquals(channel, handler.getChannel());
    }
}
