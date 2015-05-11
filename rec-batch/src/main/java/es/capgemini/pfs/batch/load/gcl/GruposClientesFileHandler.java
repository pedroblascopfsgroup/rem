package es.capgemini.pfs.batch.load.gcl;

import es.capgemini.pfs.batch.load.BatchFileHandler;

/**
 * @author pamuller
 */
public class GruposClientesFileHandler extends BatchFileHandler implements BatchGruposClientesConstants {

    public static final String SOURCE_CHANNEL_KEY = "sourceChannel";

    
    public  String getJobLauncherKey() {
        return GruposClientesJobLauncher.BEAN_KEY;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getSemaphoreName() {
        return BATCH_GCL_SEMAPHORE;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getChainChannel() {
        return GCL_CHAIN_CHANNEL;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getChannelName() {
        return CHANNEL_NAME;
    }
}
