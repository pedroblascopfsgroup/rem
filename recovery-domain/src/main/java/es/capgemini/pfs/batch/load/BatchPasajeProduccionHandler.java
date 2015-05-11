package es.capgemini.pfs.batch.load;

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
import es.capgemini.pfs.batch.common.FileHandler;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Clase encargada de Invocar el proceso de pasaje a produccion.
 * Si finaliza Ok, Se lanza un evento para la ejecución de las revisiones.
 * @author aesteban
 *
 */
public abstract class BatchPasajeProduccionHandler extends FileHandler implements BatchPCRConstantes {

    /**
     * Se hace un autowired del eventManager.
     */
    @Autowired
    private EventManager eventManager;

    /**
     * Se hace un autowired del batchManager.
     */
    @Autowired
    private BatchManager batchManager;

    /**
     * Se hace un autowired del entidadDao.
     */
    @Resource
    private EntidadDao entidadDao;

    /**
     * Variable static que referencia el canal al que se enviará el evento.
     */
    private static final String SOURCE_CHANNEL_KEY = "sourceChannel";

    protected Date extractTime;
    protected String workingCode;
    protected String fileName;

    /**
     * Metodo encargado de la ejecucion de las validaciones.
     * @param message Message
     * @throws Exception e
     */
    public void handle(Message<GenericEvent> message) throws Exception {
        JobInfo jobInfo = new JobInfo(getJobName(), message.getPayload().getPropertyAsString(ENTIDAD), this);
        jobInfo.addExecutionPolicies(new JEPRunAloneEntity());
        jobInfo.setPriority(JobInfo.PRIORIDAD_ALTA);
        getJobManager().addJob(jobInfo);

        GenericEvent event = message.getPayload();
        extractTime = (Date) event.getProperty("extractTime");
        workingCode = event.getPropertyAsString("entidad");
        fileName = event.getPropertyAsString("fileName");
    }

    /**
     * Este metodo se encarga de manejar el evento recibido.
     * Se invocará al BatchManager.
     */
    public void run() {

        try {
            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Inicio de pasaje de datos temporales a producción [" + workingCode + "]");

            // Get Entity & upload dbId
            Entidad entidad = entidadDao.findByWorkingCode(workingCode);
            DbIdContextHolder.setDbId(entidad.getId());
            HashMap<String, Object> parameters = new HashMap<String, Object>();
            //FIXME sacar cuando vaya a produccion
            parameters.put("random", System.currentTimeMillis());
            parameters.put("extractTime", extractTime);
            parameters.put("entidad", workingCode);
            parameters.put("fileName", fileName);

            BatchExitStatus result = batchManager.run(getJobName(), parameters);

            if (BatchExitStatus.COMPLETED.equals(result)) {
                Event event1 = new GenericEvent();
                event1.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));

                event1.setProperty("entidad", workingCode);
                event1.setProperty("fileName", fileName);
                event1.setProperty("extractTime", extractTime);
                eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento de routing [" + workingCode + "]");
                getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, event1);
            } else {
                fireEndEvent();
                sendEndChainEvent();
            }
        } catch (Exception e) {
            sendEndChainEvent();
            //throw e;
        }

    }

    /**
     * @return get job name.
     */
    public abstract String getJobName();

    /**
     * Lanza el veneto de que terminó en el canal que corresponde.
     */
    public abstract void fireEndEvent();

    /**
     * Sends an END event to the PCR jobs chain.
     * @param workingCode string
     */
    public abstract void sendEndChainEvent();

}
