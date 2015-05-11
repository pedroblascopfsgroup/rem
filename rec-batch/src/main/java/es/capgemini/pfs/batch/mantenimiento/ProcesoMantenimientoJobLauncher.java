package es.capgemini.pfs.batch.mantenimiento;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;

import es.capgemini.devon.batch.BatchExitStatus;
import es.capgemini.devon.batch.BatchManager;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.events.GenericEvent;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.capgemini.pfs.batch.load.pcr.PcrFileHandler;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoArquetipado;
import es.capgemini.pfs.batch.revisar.ProcesoRevisionJobLauncher;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Esta clase lanza el proceso de mantenimiento.
 *
 * @author lgiavedoni
 */
public class ProcesoMantenimientoJobLauncher implements BatchPCRConstantes, JobRunner {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private JobController jobManager;
    @Autowired
    private EventManager eventManager;
    @Autowired
    private BatchManager batchManager;
    @Resource
    private EntidadDao entidadDao;

    private Message<GenericEvent> message;
    
    private String workingCode;
	private Date extractTime;       
    
    /**
     * Inicia el proceso de revisi�n general.
     * @param message Message
     */
    public void handle(Message<GenericEvent> message) {
        handle(message.getPayload().getPropertyAsString(ENTIDAD), new Date());
    }    
    
	/**
	 * Inicia el proceso de Arquetipado
	 * @param workingCode
	 * @param extractTime
	 */
    public void handle(String workingCode, Date extractTime) {
        this.workingCode = workingCode;
        this.extractTime = extractTime;    
        JobInfo jobInfo = new JobInfo(PCR_MANTENIMIENTO_JOBNAME, workingCode, this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.setPriority(JobInfo.PRIORIDAD_ALTA);
        jobManager.addJob(jobInfo);
    }
    

    /**
     * Sends an END event to the PCR jobs chain.
     *
     * @param wc
     */
    private void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(PCR_CHAIN_CHANNEL, workingCode), PcrFileHandler.CHAIN_END);
    }

    /**
     * @return the eventManager
     */
    public EventManager getEventManager() {
        return eventManager;
    }

    /**
     * @param eventManager
     *            the eventManager to set
     */
    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        /*GenericEvent event = message.getPayload();
        // Get workingCode from semaphore fileName
        String workingCode = event.getPropertyAsString(ENTIDAD);*/
        try {
            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Inicio del proceso de mantenimiento [" + workingCode + "]");
            Entidad entidad = entidadDao.findByWorkingCode(workingCode);
            DbIdContextHolder.setDbId(entidad.getId());
            HashMap<String, Object> parameters = new HashMap<String, Object>();
            //FIXME sacar cuando vaya a produccion
            parameters.put("random", new Random(System.currentTimeMillis()).toString());
            parameters.put(EXTRACTTIME, extractTime);
            parameters.put(ENTIDAD, workingCode);
            BatchExitStatus exitStatus = batchManager.run(PCR_MANTENIMIENTO_JOBNAME, parameters);
            if (BatchExitStatus.COMPLETED.equals(exitStatus) || BatchExitStatus.NOOP.equals(exitStatus)) {
                logger.info("El proceso de mantenimiento se ha completado exitosamente. [" + workingCode + "]");
                //Agregamos el proceso de revision para que se ejecute al finalizar el proceso de revision 
                ProcesoRevisionJobLauncher revisionJobLauncher = (ProcesoRevisionJobLauncher) ApplicationContextUtil.getApplicationContext().getBean(
                        "procesoRevisionHandler");
                revisionJobLauncher.handle(workingCode, extractTime);
            } else {
                logger.error("El proceso de mantenimiento NO se ha completado exitosamente. [" + workingCode + "]");
            }
        } finally {
            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END para el proceso de mantenimiento [" + workingCode + "]");
            sendEndChainEvent(workingCode);
        }

    }
}
