package es.capgemini.pfs.batch.recobro.simulacion.jobs;

import java.util.Date;
import java.util.HashMap;

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
import es.capgemini.devon.utils.TimeUtils;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.capgemini.pfs.batch.load.pcr.PcrFileHandler;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.Genericas;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.GeneracionYPersistenciaInformeSimulacion;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Clase que implementa el Job Launcher para el proceso de Generación y Persistencia del informe de Simulación correspondiente a las Agencias de Recobro
 * @author Guillem
 *
 */
public class ProcesoGeneracionYPersistenciaInformeSimulacionJobLauncher implements BatchPCRConstantes, JobRunner {

	private final Log logger = LogFactory.getLog(getClass());
	
    @Autowired
    private EventManager eventManager;

    @Autowired
    private BatchManager batchManager;

    @Autowired
    private JobController jobManager;
	
	@Resource
	private EntidadDao entidadDao;
	
    private long window;
    private String channel;
    private String cronExpression;
    private String workingCode;
	private Date extractTime;   
	
    /**
     * Inicia el proceso de revisión general.
     * @param message Message
     */
    public void handle(Message<GenericEvent> message) {
        handle(message.getPayload().getPropertyAsString(ENTIDAD), new Date());
    }  
	
	/**
	 * Inicia el proceso de Generación y Persistencia del informe de la simulación
	 * @param workingCode
	 * @param extractTime
	 */
	public void handle(String workingCode, Date extractTime) {
		this.workingCode = workingCode;
		this.extractTime = extractTime;
		JobInfo jobInfo = new JobInfo(GeneracionYPersistenciaInformeSimulacion.PROCESO_PREPARACION_GENERACION_PERSISTENCIA_INFORME_SIMULACION_RECOBRO_JOBNAME, workingCode, this);
		jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
		jobInfo.setPriority(JobInfo.PRIORIDAD_ALTA);
		jobManager.addJob(jobInfo);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void run() {
		try{
			logger.info(GeneracionYPersistenciaInformeSimulacion.INICIO_MSG + Genericas.CORCHETE_IZQ + workingCode + Genericas.CORCHETE_DER);
			Entidad entidad = entidadDao.findByWorkingCode(workingCode);
			DbIdContextHolder.setDbId(entidad.getId());
			HashMap<String, Object> parameters = new HashMap<String, Object>();
			parameters.put(EXTRACTTIME, extractTime);
			parameters.put(ENTIDAD, workingCode);
			BatchExitStatus result = batchManager.run(GeneracionYPersistenciaInformeSimulacion.PROCESO_PREPARACION_GENERACION_PERSISTENCIA_INFORME_SIMULACION_RECOBRO_JOBNAME, parameters);
			if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {
				logger.info(GeneracionYPersistenciaInformeSimulacion.FIN_MSG + Genericas.CORCHETE_IZQ + workingCode + Genericas.CORCHETE_DER + Genericas.FINALIZADO_MSG);
	            Event evento = new GenericEvent();
	            evento.setProperty(Genericas.SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));
	            evento.setProperty(Genericas.ENTIDAD, workingCode);
	            evento.setProperty(Genericas.EXTRACT_TIME, (Date) parameters.get(Genericas.EXTRACT_TIME));
	            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento de routing [" + workingCode + "]");
	            getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, evento);
			}
			if (BatchExitStatus.FAILED.equals(result)) {
				logger.error(GeneracionYPersistenciaInformeSimulacion.FIN_MSG + Genericas.CORCHETE_IZQ + workingCode + Genericas.CORCHETE_DER + Genericas.FALLO_MSG);
			}
	    } catch (Exception e) {
	    	logger.error(GeneracionYPersistenciaInformeSimulacion.FIN_MSG + Genericas.CORCHETE_IZQ + workingCode + Genericas.CORCHETE_DER + Genericas.FALLO_MSG);
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
	 * @return the window
	 */
	public long getWindow() {
	    return window;
	}
	
	/**
	 * @param window
	 *            the window to set
	 */
	public void setWindow(long window) {
	    this.window = window;
	}
	
	/**
	 * @return the channel
	 */
	public String getChannel() {
	    return channel;
	}
	
	/**
	 * @param channel
	 *            the channel to set
	 */
	public void setChannel(String channel) {
	    this.channel = channel;
	}
	
	/**
	 * @return the cronExpression
	 */
	public String getCronExpression() {
	    return cronExpression;
	}
	
	/**
	 * @param cronExpression
	 *            the cronExpression to set
	 */
	public void setCronExpression(String cronExpression) {
	    this.cronExpression = cronExpression;
	}
	
	/**
	 * shouldProcessOn.
	 * @param date Date
	 * @return Date
	 */
	public Date shouldProcessOn(Date date) {
	    return TimeUtils.shouldProcessOn(date, getWindow(), getCronExpression());
	}	

}
