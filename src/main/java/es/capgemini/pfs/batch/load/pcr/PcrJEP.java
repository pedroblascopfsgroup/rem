package es.capgemini.pfs.batch.load.pcr;

import java.util.List;

import es.capgemini.pfs.batch.revisar.ProcesoRevisionJobLauncher;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;

public class PcrJEP extends JobExecutionPolicy {

    /**
     * Politia: No se puede ejecutar una carga PCR si esta esperando para 
     * ejecucion uno job de tipo:
     *      - Revision
     */
    @SuppressWarnings("unchecked")
    @Override
    public boolean validatePreRunning() {
        return true;
    }

}
