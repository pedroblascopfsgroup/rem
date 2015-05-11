package es.capgemini.pfs.batch.load;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

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
 * Si finaliza Ok, Se lanza un evento para la ejecuciÃ³n de las revisiones.
 * @author aesteban
 *
 */
public abstract class BatchAnalizeProduccionHandler extends FileHandler implements BatchLoadConstants, BatchPCRConstantes {

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

    private Message<GenericEvent> message;

    /**
     * Metodo encargado de la ejecucion de las validaciones.
     * @param message GenericEvent
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
     * Se invocará al BatchManager.
     */
    public void run() {
        GenericEvent event = message.getPayload();
        // Get workingCode from semaphore fileName
        String workingCode = event.getPropertyAsString(ENTIDAD);

        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Inicio de generación de análisis [" + workingCode + "]");

        try {
            // De acá saco la fecha contra la que tengo que comparar
            String fileName = event.getPropertyAsString("fileName");
            // Get Entity & upload dbId
            Entidad entidad = entidadDao.findByWorkingCode(workingCode);
            DbIdContextHolder.setDbId(entidad.getId());
            HashMap<String, Object> parameters = new HashMap<String, Object>();
            //FIXME sacar cuando vaya a produccion
            parameters.put("random", new Random(System.currentTimeMillis()).toString());
            parameters.put(EXTRACTTIME, event.getProperty(EXTRACTTIME));
            parameters.put(ENTIDAD, workingCode);
            parameters.put(FILENAME, fileName);

            BatchExitStatus result = batchManager.run(getJobName(), parameters);

            if (BatchExitStatus.COMPLETED.equals(result)
            		|| BatchExitStatus.NOOP.equals(result)) {
                Event event1 = new GenericEvent();
                event1.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));

                event1.setProperty(ENTIDAD, workingCode);
                event1.setProperty(FILENAME, fileName);
                event1.setProperty(EXTRACTTIME, (Date) parameters.get(EXTRACTTIME));
                eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento de routing [" + workingCode + "]");
                getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, event1);
            } else {
                sendEndChainEvent(workingCode);
            }
        } catch (Exception e) {
            sendEndChainEvent(workingCode);
            //throw e;
        }

    }

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
