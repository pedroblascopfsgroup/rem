package es.capgemini.pfs.batch.load.gcl;

import es.capgemini.pfs.batch.load.BatchLoadConstants;


/**
 * Interface que contiene las constantes para la carga de cirbe.
 * @author pamuller
 *
 */
public interface BatchGruposClientesConstants extends BatchLoadConstants{

    String GCL = "GCL";
    String PROP_GCL_GRUPOS_ROWCOUNT = "grupos.rowcount";
    String PROP_GCL_RELACIONES_ROWCOUNT = "relaciones.rowcount";
    String GCL_TXT_GRUPOS = "txtFileGclGrupos";
    String GCL_TXT_RL = "txtFileGclRL";
    String GCL_CSV_GRUPOS = "csvFileGclGrupos";
    String GCL_CSV_RL = "csvFileGclRL";

    String GCL_RL = "GCL-RL";

    String GCL_CHAIN_CHANNEL = "gclChainChannel";

    String BATCH_GCL_SEMAPHORE = "batch.gcl.semaphore";
    String CHANNEL_NAME = "GCL";
    String GCL_JOBNAME = "loadGruposClientesStarterJob";
    String GCL_VALIDACION_JOBNAME = "validacionesGruposClientesJob";
    String GCL_PASAJE_JOBNAME = "pasajeGruposClientesProduccionJob";

}
