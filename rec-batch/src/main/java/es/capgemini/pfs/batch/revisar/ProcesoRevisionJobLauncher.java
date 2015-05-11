package es.capgemini.pfs.batch.revisar;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.BatchExitStatus;
import es.capgemini.devon.batch.BatchManager;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Esta clase lanza el proceso de revisi�n.
 * @author jbosnjak
 */
public class ProcesoRevisionJobLauncher implements BatchPCRConstantes, JobRunner {

    @Autowired
    private BatchManager batchManager;

    @Autowired
    private JobController jobManager;

    @Resource
    private EntidadDao entidadDao;

    private String workingCode;
    private Date extractTime;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Inicia el proceso de revisi�n general.
     * @param message Message
     */

    public void handle(String workingCode, Date extractTime) {
        this.workingCode = workingCode;
        this.extractTime = extractTime;

        JobInfo jobInfo = new JobInfo(PCR_REVISION_JOBNAME, workingCode, this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.addExecutionPolicies(new ProcesoRevisionJEP(workingCode, extractTime));

        //Prioridad baja para dar tiempo a que terminen el resto de tareas
        jobInfo.setPriority(JobInfo.PRIORIDAD_BAJA);
        jobManager.addJob(jobInfo);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        logger.info("Inicio de revisi�n de nuevos clientes [" + workingCode + "]");

        Entidad entidad = entidadDao.findByWorkingCode(workingCode);
        DbIdContextHolder.setDbId(entidad.getId());
        HashMap<String, Object> parameters = new HashMap<String, Object>();
        //FIXME sacar cuando vaya a produccion
        parameters.put("random", new Random(System.currentTimeMillis()).toString());
        parameters.put(EXTRACTTIME, extractTime);
        parameters.put(ENTIDAD, workingCode);
        BatchExitStatus result = batchManager.run(PCR_REVISION_JOBNAME, parameters);

        if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {
            logger.info("El proceso de revision para la entidad [" + workingCode + "] ha finalizado");
        }

        if (BatchExitStatus.FAILED.equals(result)) {
            logger.error("El proceso de revision para la entidad [" + workingCode + "] ha fallado");
        }

    }

    public final Date getExtractTime() {
        return extractTime;
    }

}
