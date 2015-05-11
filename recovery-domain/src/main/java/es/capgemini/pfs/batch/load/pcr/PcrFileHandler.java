package es.capgemini.pfs.batch.load.pcr;

import es.capgemini.pfs.batch.load.BatchFileHandler;

/**
 * @author pamuller / aesteban
 */
public class PcrFileHandler extends BatchFileHandler implements BatchPCRConstantes {


    
    public  String getJobLauncherKey() {
        return PcrJobLauncher.BEAN_KEY;
    }
    
    /**
     * {@inheritDoc}
     */
    @Override
    public String getSemaphoreName() {
        return PCR_SEMAPHORE;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getChainChannel() {
        return PCR_CHAIN_CHANNEL;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getChannelName() {
        return PCR_CHANNEL_NAME;
    }
}
