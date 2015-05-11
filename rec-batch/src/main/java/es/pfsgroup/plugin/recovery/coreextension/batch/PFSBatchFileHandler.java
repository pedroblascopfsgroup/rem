package es.pfsgroup.plugin.recovery.coreextension.batch;

import es.capgemini.pfs.batch.load.BatchFileHandler;

/**
 * File Handler gen�rico para definir cargas de fihceros en el batch.
 * 
 * @author bruno
 * 
 */
public class PFSBatchFileHandler extends BatchFileHandler {

    private String channelName;
    private String jobLauncherKey;
    private String semaphoreName;
    private String chainChannel;

    @Override
    public String getChannelName() {
        return this.channelName;
    }

    @Override
    public String getJobLauncherKey() {
        return this.jobLauncherKey;
    }

    @Override
    public String getSemaphoreName() {
        return this.semaphoreName;
    }

    @Override
    public String getChainChannel() {
        return this.chainChannel;
    }

    public void setChannelName(String channelName) {
        this.channelName = channelName;
    }

    public void setJobLauncherKey(String jobLauncherKey) {
        this.jobLauncherKey = jobLauncherKey;
    }

    public void setSemaphoreName(String semaphoreName) {
        this.semaphoreName = semaphoreName;
    }

    public void setChainChannel(String chainChannel) {
        this.chainChannel = chainChannel;
    }

}
