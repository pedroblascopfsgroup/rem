package es.capgemini.pfs.batch.load.alertas;

import es.capgemini.pfs.batch.load.BatchFileHandler;

/**
 * Clase encargada de manejar la carga de archivos de alertas.
 * @author aesteban
 *
 */
public class AlertasFileHandler extends BatchFileHandler implements BatchAlertasConstants {

    /**
     * {@inheritDoc}
     */
    @Override
    public String getSemaphoreName() {
        return ALE_SEMAPHORE;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getChainChannel() {
        return ALE_CHAIN_CHANNEL;
    }

   public  String getJobLauncherKey() {
       return AlertasJobLauncher.BEAN_KEY;
   }
        

     /**
     * {@inheritDoc}
     */
    @Override
    public String getChannelName() {
        return ALE_CHANNEL_NAME;
    }
}
