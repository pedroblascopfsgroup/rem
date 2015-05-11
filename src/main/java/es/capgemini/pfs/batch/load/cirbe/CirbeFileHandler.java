package es.capgemini.pfs.batch.load.cirbe;

import es.capgemini.pfs.batch.load.BatchFileHandler;

/**
 * @author pamuller
 */
public class CirbeFileHandler extends BatchFileHandler implements BatchCirbeConstants {

    public static final String SOURCE_CHANNEL_KEY = "sourceChannel";


  
    public  String getJobLauncherKey() {
        return CirbeJobLauncher.BEAN_KEY;
    }

     /**
     * {@inheritDoc}
     */
    @Override
    public String getSemaphoreName() {
        return BATCH_CIRBE_SEMAPHORE;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getChainChannel() {
        return CIRBE_CHAIN_CHANNEL;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getChannelName() {
        return CHANNEL_NAME;
    }
}
