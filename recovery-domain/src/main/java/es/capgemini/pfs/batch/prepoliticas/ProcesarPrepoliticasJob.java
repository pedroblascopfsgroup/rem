package es.capgemini.pfs.batch.prepoliticas;

import org.quartz.Job;
import org.quartz.JobExecutionContext;

import es.capgemini.pfs.job.JobRunner;

/**
 * Job de proceso de prepoliticas.
 * @author lgiavedo
 *
 */
public class ProcesarPrepoliticasJob implements Job, JobRunner {


    /**
    * M�todo que ejecuta el job.
    * @param context el contexto de ejecuci�n.
    */
    @Override
    public void execute(JobExecutionContext context) {

    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public void run() {
    }

    private void determinarBBDD(JobExecutionContext context) {
    }
}
