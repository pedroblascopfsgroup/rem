package es.capgemini.pfs.batch.scoring;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.batch.revisar.ProcesoRevisionJobLauncher;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;
import es.capgemini.pfs.utils.FormatUtils;

/**
 * Job de proceso de alertas.
 * @author pamuller
 *
 */
public class ProcesarAlertasJob implements Job, JobRunner {

    private final Log logger = LogFactory.getLog(getClass());
    private JobExecutionContext context;
    private String workingCode;

    /**
    * Método que ejecuta el job.
    * @param context el contexto de ejecución.
    */
    @Override
    public void execute(JobExecutionContext context) {
        this.context = context;
        workingCode = ((Entidad) context.getMergedJobDataMap().get("entidad")).getConfiguracion().get(Entidad.WORKING_CODE_KEY).getDataValue();

        JobController jobManager = (JobController) ApplicationContextUtil.getApplicationContext().getBean(JobController.BEAN_KEY);
        
        JobInfo jobInfo=new JobInfo("SCORING", workingCode, this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.addExecutionPolicies(new ProcesarAlertasJEP());
        jobInfo.setPriority(JobInfo.PRIORIDAD_BAJA);
        jobManager.addJob(jobInfo);
        
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
        ScoringBatchManager scoringBatchManager = (ScoringBatchManager) ApplicationContextUtil.getApplicationContext().getBean("scoringBatchManager");
        logger.info("-- INICIANDO PROCESO DE ALERTAS SCORING ["+workingCode+"] --");

        if (scoringBatchManager.validar()) {
            scoringBatchManager.crearTablasDeTotales();
            scoringBatchManager.crearTablasDeParciales();
            scoringBatchManager.completarTablaDeTotales();
            logger.info("-- FINALIZADO PROCESO DE ALERTAS SCORING ["+workingCode+"] --");
            
          //Agregamos el proceso de revision para que se ejecute al finalizar el proceso
            ProcesoRevisionJobLauncher revisionJobLauncher = (ProcesoRevisionJobLauncher)ApplicationContextUtil.getApplicationContext().getBean("procesoRevisionHandler");
            revisionJobLauncher.handle(workingCode,FormatUtils.fechaSinHora(new Date()));
        } else {
            logger.error("-- FALLARON VALIDACIONES PROCESO DE ALERTAS SCORING ["+workingCode+"] --");
        }

    }
}
