package es.capgemini.pfs.batch.prepoliticas;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.batch.revisar.ProcesoRevisionJobLauncher;
import es.capgemini.pfs.batch.revisar.personas.PersonasBatchManager;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;
import es.capgemini.pfs.politica.dao.DDTipoPoliticaDao;
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleResultUtil;
import es.capgemini.pfs.utils.FormatUtils;

/**
 * Job de proceso de prepoliticas.
 * @author lgiavedo
 *
 */
public class ProcesarPrepoliticasJob implements Job, JobRunner {

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

        JobInfo jobInfo = new JobInfo("PREPOLITICAS", workingCode, this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.setPriority(JobInfo.PRIORIDAD_BAJA);
        jobManager.addJob(jobInfo);

    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public void run() {
        determinarBBDD(context);
        logger.info("-- INICIANDO PROCESO DE PRE-POLITICAS [" + workingCode + "] --");

        //Historificamos las prepolíticas viejas
        PersonasBatchManager personaManager = (PersonasBatchManager) ApplicationContextUtil.getApplicationContext().getBean("personasBatchManager");
        personaManager.historificaPrepoliticas();

        DDTipoPoliticaDao dao = (DDTipoPoliticaDao) ApplicationContextUtil.getApplicationContext().getBean("DDTipoPoliticaDao");
        RuleExecutor ruleExecutor = (RuleExecutor) ApplicationContextUtil.getApplicationContext().getBean("prepoliticaRuleExecutor");

        boolean finishOK = RuleResultUtil.allResultsOK(ruleExecutor.execRules((List) dao.getList()));
        if (finishOK) {
            //Sin errores
            logger.info("-- FIN PROCESO DE PRE-POLITICAS [" + workingCode + "] --");
            // Agregamos el proceso de revision para su ejecucion
            ProcesoRevisionJobLauncher revisionJobLauncher = (ProcesoRevisionJobLauncher) ApplicationContextUtil.getApplicationContext().getBean(
                    "procesoRevisionHandler");
            revisionJobLauncher.handle(workingCode, FormatUtils.fechaSinHora(new Date()));
        } else {
            //Hay errores
            logger.error("-- FALLO EN PROCESO DE PRE-POLITICAS [" + workingCode + "] --");
            // No se lanza el proceso de revision
        }
    }

    private void determinarBBDD(JobExecutionContext context) {
        Entidad entidad = (Entidad) context.getMergedJobDataMap().get("entidad");
        DbIdContextHolder.setDbId(entidad.getId());
    }
}
