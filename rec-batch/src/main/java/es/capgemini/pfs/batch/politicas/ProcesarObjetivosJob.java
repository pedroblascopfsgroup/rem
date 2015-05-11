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
import es.capgemini.pfs.politica.ObjetivoManager;

/**
 * Job de proceso de alertas.
 * @author pamuller
 *
 */
public class ProcesarObjetivosJob implements Job, JobRunner {

    private final Log logger = LogFactory.getLog(getClass());
    private JobExecutionContext context;

    /**
    * Método que ejecuta el job.
    * @param context el contexto de ejecución.
    */
    @Override
    public void execute(JobExecutionContext context) {
        this.context = context;
        String workingCode = ((Entidad) context.getMergedJobDataMap().get("entidad")).getConfiguracion().get(Entidad.WORKING_CODE_KEY).getDataValue();

        JobController jobManager = (JobController) ApplicationContextUtil.getApplicationContext().getBean(JobController.BEAN_KEY);

        JobInfo jobInfo = new JobInfo("OBJETIVOS", workingCode, this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.setPriority(JobInfo.PRIORIDAD_BAJA);
        jobManager.addJob(jobInfo);

    }

    private ApplicationContext getAplicationContext(JobExecutionContext context) {
        return (ApplicationContext) context.getMergedJobDataMap().get("applicationContext");
    }

    private void determinarBBDD(JobExecutionContext context) {
        Entidad entidad = (Entidad) context.getMergedJobDataMap().get("entidad");
        DbIdContextHolder.setDbId(entidad.getId());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        determinarBBDD(context);
        ObjetivoManager objetivosBatchManager = (ObjetivoManager) getAplicationContext(context).getBean("objetivoManager");
        logger.info("-- INICIANDO PROCESO DE ALERTAS OBJETIVOS --");
        try {
            objetivosBatchManager.revisarObjetivosPendientes();
            logger.info("-- FINALIZADO PROCESO DE ALERTAS OBJETIVOS --");
        } catch (Exception e) {
            logger.debug("ERROR: ", e);
            logger.info("-- FALLO PROCESO OBJETIVOS --");
        }

    }
}
