package es.capgemini.pfs.batch.load.cirbe;

import es.capgemini.pfs.batch.load.BatchLoadConstants;


/**
 * Interface que contiene las constantes para la carga de cirbe.
 * @author pamuller
 *
 */
public interface BatchCirbeConstants extends BatchLoadConstants{

    String CIRBE = "CIRBE";
    String PROP_CIRBE_ROWCOUNT = "Cirbe.rowcount";
    String CIRBE_TXT = "txtFileCirbe";
    String CIRBE_CSV = "csvFileCirbe";

    String CIRBE_CHAIN_CHANNEL = "cirbeChainChannel";

    String BATCH_CIRBE_SEMAPHORE = "batch.cirbe.semaphore";
    String CHANNEL_NAME = "CIRBE";
    String CIRBE_JOBNAME = "loadCirbeStarterJob";
    String CIRBE_VALIDACION_JOBNAME = "validacionesCirbeJob";
    String CIRBE_PASAJE_JOBNAME = "pasajeCirbeProduccionJob";

}
