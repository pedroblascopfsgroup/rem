package es.capgemini.pfs.batch.scoring;

import java.util.List;

import es.capgemini.pfs.batch.load.alertas.AlertasJobLauncher;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;

public class ProcesarAlertasJEP extends JobExecutionPolicy {

    @Override
    public boolean validateOnRunning(JobInfo newJob) {
        return true;
    }

    /**
     * Politia: No se puede ejecutar el scoring si esta esperando para 
     * ejecucion uno job de tipo:
     *      - Carga de alertas
     */
    @Override
    @SuppressWarnings("unchecked")
    public boolean validatePreRunning() {
        List<JobInfo> jobs = jobManager.getJobsWaitingEntity(jobInfo.getJobEntity());
        for (JobInfo jobInfo : jobs) {
            Class clazz = jobInfo.getJobRunner().getClass();
            if (clazz.equals(AlertasJobLauncher.class)) return false;
        }
        return true;
    }

    /**
     * Metodo para verificar si se debe agregar la revision o no.
     * 
     */
    @Override
    public boolean validatePreLoad() {
        return true;
    }

}
