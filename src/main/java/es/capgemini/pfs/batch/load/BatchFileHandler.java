package es.capgemini.pfs.batch.load;

import java.io.File;
import java.util.Date;

import org.springframework.integration.channel.PollableChannel;
import org.springframework.integration.core.Message;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.common.FileHandler;

/**
 * Clase con el código genérico para los file handlers.
 * Se fuerza la generación de varios métodos que son necesarios para que Spring asocie las clases correctas en el momento de la ejecución.
 * @author aesteban
 *
 */
public abstract class BatchFileHandler extends FileHandler {

    /**
     * Obtiene un fichero de semáforo, genera parámetros para el job y lo lanza.
     * Si no se peude procesar ahora el evento, lo difiere.
     * @param message Message
     */
    @SuppressWarnings("unchecked")
    public void handle(Message message) {
        File file;
        if (message.getPayload() instanceof File) {
            file = (File) message.getPayload();
        } else {
            file = new File((String) message.getPayload());
        }

        // Get workingCode from semaphore fileName
        String workingCode = getWorkingCodeFromFileName(file.getName(), getAppProperty(getSemaphoreName()));
        // Debería ejecutar el proceso ahora?
        Date now = new Date();
        Date next = shouldProcessOn(now);

        // Si es un evento relanzado o la fecha es nula, ejecuto ahora
        boolean reThrowed =(Long)message.getHeaders().get(EventManager.RETHROWED_KEY) != null;
        if (reThrowed || next == null) {

            // Actualizar aquí el evento relanzado para prevenir pérdidas de mensajes y relanzados
            if (reThrowed) {
                Long id = new Long(message.getHeaders().get(EventManager.DEFERED_EVENT_KEY).toString());
                getEventManager().updateProcessDate(id, now);
            }
            setChannel(getChannel());

            PollableChannel messageChannel = getEventManager().createPollableChannel(QueueUtils.getQueueNameForEntity(getChainChannel(), workingCode));

            // Lanzar el Job
            handle(file);

            messageChannel.receive();

        } else {
            getEventManager().fireEvent(EventManager.GENERIC_CHANNEL,
                    "Nuevo fichero [" + getChannelName() + ":" + file.getAbsolutePath() + "] posterga. Será procesada en  " + next);

            getEventManager().createDeferedEvent(QueueUtils.getQueueNameForEntity(getChannel(), workingCode), file.getAbsolutePath(),
                    message.getHeaders().getTimestamp(), next);
        }
    }

    /**
     * @return el nombre del canal. Ej PCR, ALE.
     */
    public abstract String getChannelName();
    
    public abstract String getJobLauncherKey();

  
    public void handle(File file) {
        //Para obtener una nueva instacia del bean
        BatchJobLauncher jobLauncher = (BatchJobLauncher)ApplicationContextUtil.getBean(getJobLauncherKey());
        jobLauncher.setChannel(getChannel());
        jobLauncher.handle(file);
    }

    /**
     * @return SemaphoreName
     */
    public abstract String getSemaphoreName();

    /**
     * @return ChainChannel
     */
    public abstract String getChainChannel();

    /**
     * Este metodo se encarga de manejar el evento recibido.
     */
    public void run() {
    }

}
