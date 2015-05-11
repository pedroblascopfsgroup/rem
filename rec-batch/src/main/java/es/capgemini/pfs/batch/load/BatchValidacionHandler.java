package es.capgemini.pfs.batch.load;

import java.util.Date;
import java.util.Map;

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
import es.capgemini.pfs.batch.common.FileHandler;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Clase abstracta que ejecuta las validaciones de la carga.
 * @author aesteban
 */
public abstract class BatchValidacionHandler extends FileHandler implements BatchLoadConstants, BatchPCRConstantes {

    @Autowired
    private EventManager eventManager;

    @Autowired
    private BatchManager batchManager;

    @Resource
    private EntidadDao entidadDao;

    private Message<GenericEvent> message;
    
    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Metodo encargado de la ejecucion de las validaciones.
     * @param message Message
     * @throws Exception e
     */
    public void handle(Message<GenericEvent> message) throws Exception {
        this.message = message;
        
        JobInfo jobInfo = new JobInfo(getJobName(), message.getPayload().getPropertyAsString(ENTIDAD), this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.setPriority(JobInfo.PRIORIDAD_ALTA);
        getJobManager().addJob(jobInfo);
    }

    /**
     * Este metodo se encarga de manejar el evento recibido.
     * Se invocar� al BatchManager.
     */
    public void run() {
        GenericEvent event = message.getPayload();
        // Get workingCode from semaphore fileName
        String workingCode = event.getPropertyAsString(ENTIDAD);

        try {
            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Inicio de validaciones [" + workingCode + "]");

            //De ac� saco la fecha contra la que tengo que comparar
            String fileName = event.getPropertyAsString(FILENAME);
            // Get Entity & upload dbId
            Entidad entidad = entidadDao.findByWorkingCode(workingCode);
            DbIdContextHolder.setDbId(entidad.getId());

            Map<String, Object> params = buildParameters(event.getProperties(), fileName, workingCode);

            BatchExitStatus result = batchManager.run(getJobName(), params);

            if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {
                Event event1 = new GenericEvent();
                event1.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));

                event1.setProperty(ENTIDAD, workingCode);
                event1.setProperty(FILENAME, fileName);
                event1.setProperty(EXTRACTTIME, (Date) params.get(EXTRACTTIME));
                eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento de routing [" + workingCode + "]");
                getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, event1);

            } else {
                sendEndChainEvent(workingCode);
            }
        } catch (Exception e) {
            logger.error(e);
            sendEndChainEvent(workingCode);
            //throw e;
        }
    }

    /**
     * Contruye el map con los par�metros necesarios para el job.
     * @param parameters parametros del evento
     * @param fileName string
     * @param workingCode string
     * @return map
     */
    public abstract Map<String, Object> buildParameters(Map<?, ?> parameters, String fileName, String workingCode);

    /**
     * @return get job name.
     */
    public abstract String getJobName();

    /**
     * Sends an END event to the PCR jobs chain.
     * @param workingCode string
     */
    public abstract void sendEndChainEvent(String workingCode);

}
