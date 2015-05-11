package es.capgemini.pfs.batch.revisar;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.batch.load.BatchPasajeProduccionHandler;
import es.capgemini.pfs.batch.load.gcl.GruposClientesFileHandler;
import es.capgemini.pfs.batch.prepoliticas.ProcesarPrepoliticasJob;
import es.capgemini.pfs.batch.scoring.ProcesarAlertasJob;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.capgemini.pfs.utils.FormatUtils;

public class ProcesoRevisionJEP extends JobExecutionPolicy {

    private String workingCode;
    private Date extractTime;

    public ProcesoRevisionJEP(String workingCode, Date extractTime) {
        super();
        this.workingCode = workingCode;
        this.extractTime = extractTime;
    }

    
    /**
     * Politia: No se puede ejecutar una revision si esta esperando para 
     * ejecucion uno job de tipo:
     *      - PCR
     *      - Scoring
     *      - Prepolitica
     *      - Carga Grupos
     * 
     */
    @SuppressWarnings("unchecked")
    @Override
    public boolean validatePreRunning() {
        List<JobInfo> jobs = jobManager.getJobsWaitingEntity(jobInfo.getJobEntity());
        for (JobInfo jobInfo : jobs) {
            Class clazz = jobInfo.getJobRunner().getClass();
            if (clazz.equals(BatchPasajeProduccionHandler.class) || clazz.equals(ProcesarAlertasJob.class)
                    || clazz.equals(ProcesarPrepoliticasJob.class) || clazz.equals(GruposClientesFileHandler.class)) return false;
        }
        return true;
    }

    /**
     * Metodo para verificar si se debe agregar la revision o no.
     * Politica: Si ya ha una revision para la misma fecha de extracción NO
     * debemos generar una nueva.
     */
    @Override
    public boolean validatePreLoad() {
        List<JobInfo> jobs = jobManager.getJobsWaitingEntity(workingCode);
        for (JobInfo jobInfo : jobs) {
            if (ProcesoRevisionJobLauncher.class.equals(jobInfo.getJobRunner().getClass())) {
                //Es un proceso de revision
                Date extractTimeJI = ((ProcesoRevisionJobLauncher) jobInfo.getJobRunner()).getExtractTime();
                //Para la misma fecha de extraccion
                if (FormatUtils.fechaSinHora(extractTime).equals(FormatUtils.fechaSinHora(extractTimeJI))) {
                    //Es la misma fecha, no puedo agregar la revision 
                    return false;
                }
            }
        }
        //Si se puede agregar
        return true;
    }

}
