package es.capgemini.pfs.batch.analisisexterna;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.batch.analisis.ResumenBatchManager;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;


/**
 * Job de proceso de analisis externa.
 * @author pajimene
 *
 */
public class ProcesarAnalisisExternaJob implements Job, JobRunner {

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

        JobInfo jobInfo = new JobInfo("ANALISIS_EXTERNA", workingCode, this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.setPriority(JobInfo.PRIORIDAD_BAJA);
        jobManager.addJob(jobInfo);

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        determinarBBDD(context);
        logger.info("-- INICIANDO PROCESO DE ANALISIS DE EXTERNA --");

        ResumenBatchManager resumenManager = (ResumenBatchManager) ApplicationContextUtil.getApplicationContext().getBean("resumenBatchManager");
        resumenManager.realizaAnalisisExterna();

        logger.info("-- FIN PROCESO DE ANALISIS DE EXTERNA --");

    }

    private void determinarBBDD(JobExecutionContext context) {
        Entidad entidad = (Entidad) context.getMergedJobDataMap().get("entidad");
        DbIdContextHolder.setDbId(entidad.getId());
    }
}
