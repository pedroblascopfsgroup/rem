package es.capgemini.pfs.batch.scoring;

import org.quartz.Job;
import org.quartz.JobExecutionContext;

import es.capgemini.pfs.job.JobRunner;

/**
 * Job de proceso de alertas.
 * @author pamuller
 *
 */
public class ProcesarAlertasJob implements Job, JobRunner {

    
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
    @Override
    public void run() {
       

    }
}
