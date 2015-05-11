package es.capgemini.pfs.batch.politicas;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.springframework.context.ApplicationContext;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Job de proceso de alertas.
 * @author pamuller
 *
 */
public class ProcesarObjetivosJob implements Job, JobRunner {


    /**
    * Método que ejecuta el job.
    * @param context el contexto de ejecución.
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
