package es.capgemini.pfs.batch.load.pcr;

import java.util.Date;
import java.util.HashMap;

import javax.annotation.Resource;

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
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Esta clase lanza el proceso de precalculo en la carga para
 * realizar una serie de calculos est�ticos.
 *
 * @author pjimene
 */
public class PrecalculoJobLauncher implements BatchPCRConstantes, JobRunner {

    @Autowired
    private EventManager eventManager;

    @Autowired
    private BatchManager batchManager;

    @Autowired
    private JobController jobManager;

    private long window;
    private String channel;
    private String cronExpression;
    private GenericEvent event;
    private String workingCode;

    @Resource
    private EntidadDao entidadDao;

    /**
     * Inicia el proceso de revisi�n general.
     * @param message Message
     * @throws Exception e
     */
    public void handle(Message<GenericEvent> message) throws Exception {
        this.event = message.getPayload();
        // Get workingCode from semaphore fileName
        workingCode = event.getPropertyAsString(ENTIDAD);
        
        JobInfo jobInfo = new JobInfo(PCR_PRECALCULO_JOBNAME, workingCode, this);
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

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        try {
            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Inicio del proceso de precalculo [" + workingCode + "]");

            Entidad entidad = entidadDao.findByWorkingCode(workingCode);
            DbIdContextHolder.setDbId(entidad.getId());
            HashMap<String, Object> parameters = new HashMap<String, Object>();
            String fileName = event.getPropertyAsString("fileName");

            parameters.put("random", System.currentTimeMillis());
            parameters.put(EXTRACTTIME, event.getProperty(EXTRACTTIME));
            parameters.put(ENTIDAD, workingCode);
            parameters.put(FILENAME, fileName);

            BatchExitStatus result = batchManager.run(PCR_PRECALCULO_JOBNAME, parameters);

            if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {
                Event event1 = new GenericEvent();
                event1.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));

                event1.setProperty("entidad", workingCode);
                event1.setProperty("fileName", fileName);
                event1.setProperty("extractTime", (Date) parameters.get("extractTime"));

                eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento de routing [" + workingCode + "]");
                getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, event1);
            } else {
                getEventManager().fireEvent(PCR_CHAIN_CHANNEL, CHAIN_END);
                sendEndChainEvent(workingCode);
            }
        } catch (Exception e) {
            sendEndChainEvent(workingCode);
            throw new RuntimeException();
        }
    }
}
