package es.pfsgroup.recovery.batch.recuperaciones.launcher;

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
import es.capgemini.devon.events.Event;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.events.GenericEvent;
import es.capgemini.devon.events.router.GenericRouter;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.capgemini.pfs.batch.load.pcr.PcrFileHandler;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.Genericas;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoArquetipadoRecuperaciones;

public class ProcesoArquetipadoRecuperacionesJobLauncher implements JobRunner,BatchPCRConstantes{
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private String channel;
	private String workingCode;
	private Date extractTime;
	
	@Resource
	private EntidadDao entidadDao;
	
	@Autowired
    private BatchManager batchManager;
	
	@Autowired
    private JobController jobManager;
	
	@Autowired
    private EventManager eventManager;

	@Override
	public void run() {
		try{
	    	logger.info(ProcesoArquetipadoRecuperaciones.INICIO_MSG + Genericas.CORCHETE_IZQ + workingCode + Genericas.CORCHETE_DER);    	
	    	Entidad entidad = entidadDao.findByWorkingCode(workingCode);
	        DbIdContextHolder.setDbId(entidad.getId());
	        HashMap<String, Object> parameters = new HashMap<String, Object>();
	        parameters.put(Genericas.RANDOM, new Random(System.currentTimeMillis()).toString());
	        parameters.put(EXTRACTTIME, extractTime);
	        parameters.put(ENTIDAD, workingCode);
	        BatchExitStatus result = batchManager.run(ProcesoArquetipadoRecuperaciones.PROCESO_ARQUETIPADO_RECUPERACIONES_JOBNAME, parameters);        
	        if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {
				logger.info(ProcesoArquetipadoRecuperaciones.FIN_MSG + Genericas.CORCHETE_IZQ + workingCode + Genericas.CORCHETE_DER + Genericas.FINALIZADO_MSG);
	            Event evento = new GenericEvent();
	            evento.setProperty(Genericas.SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));
	            evento.setProperty(Genericas.ENTIDAD, workingCode);
	            evento.setProperty(Genericas.EXTRACT_TIME, (Date) parameters.get(Genericas.EXTRACT_TIME));
	            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento de routing [" + workingCode + "]");
	            getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, evento);
	        }
	        if (BatchExitStatus.FAILED.equals(result)) {
	            logger.error(ProcesoArquetipadoRecuperaciones.FIN_MSG + Genericas.CORCHETE_IZQ  + workingCode + 
	            		Genericas.CORCHETE_DER + Genericas.FALLO_MSG);
	        }
        } catch (Exception e) {
        	logger.error(ProcesoArquetipadoRecuperaciones.FIN_MSG + Genericas.CORCHETE_IZQ + workingCode + Genericas.CORCHETE_DER + Genericas.FALLO_MSG);
            sendEndChainEvent(workingCode);
            throw new RuntimeException();
        }
	}
	
    /**
     * Sends an END event to the PCR jobs chain.
     *
     * @param wc
     */
    private void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(Genericas.PCR_CHAIN_CHANNEL, workingCode), PcrFileHandler.CHAIN_END);
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
     * Inicia el proceso de arquetipado vinendo de otro proceso anterior.
     * @param message Message
     */
    public void handle(Message<GenericEvent> message) {
        handle(message.getPayload().getPropertyAsString(ENTIDAD), new Date());
    }
    
	/**
	 * Inicia el proceso de arquetipado directamente
	 * @param workingCode
	 * @param extractTime
	 */
    public void handle(String workingCode, Date extractTime) {
    	logger.debug("inicio método");
        this.setWorkingCode(workingCode);
        this.setExtractTime(extractTime);
        JobInfo jobInfo = new JobInfo(ProcesoArquetipadoRecuperaciones.PROCESO_ARQUETIPADO_RECUPERACIONES_JOBNAME, workingCode, this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.setPriority(JobInfo.PRIORIDAD_ALTA);
        jobManager.addJob(jobInfo);
        logger.debug("fin método");
    }

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public String getWorkingCode() {
		return workingCode;
	}

	public void setWorkingCode(String workingCode) {
		this.workingCode = workingCode;
	}

	public Date getExtractTime() {
		return extractTime;
	}

	public void setExtractTime(Date extractTime) {
		this.extractTime = extractTime;
	}

}
