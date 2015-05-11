package es.capgemini.pfs.batch.load.cirbe;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import es.capgemini.devon.batch.BatchExitStatus;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.events.Event;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.events.GenericEvent;
import es.capgemini.devon.events.router.GenericRouter;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchJobLauncher;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * @author pamuller
 */
@Component(CirbeJobLauncher.BEAN_KEY)
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class CirbeJobLauncher extends BatchJobLauncher implements BatchCirbeConstants {
    
    public static final String BEAN_KEY="cirbeJobLauncher";

    private String workingCode;

    /**
     * {@inheritDoc}
     */
    @Override
    public void handle(File file) {
        setFile(file);
        // Get workingCode from semaphore fileName
        workingCode = getWorkingCodeFromFileName(getFile().getName(), getAppProperty(BATCH_CIRBE_SEMAPHORE));
        getJobManager().addJob(CIRBE_JOBNAME, workingCode, this, new JobExecutionPolicy[] { new JEPRunAloneEntity() });

    }

    /**
     * Sends an END event to the PCR jobs chain.
     *
     * @param wc
     */
    private void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(CirbeFileHandler.CIRBE_CHAIN_CHANNEL, workingCode), CirbeFileHandler.CHAIN_END);
    }

    /**
     * Contruye los parametros.
     * @param semaphore File
     * @return Map
     */
    private Map<String, Object> buildParameters(File semaphore) {
        // Build parameters
        Map<String, Object> params = new HashMap<String, Object>();
        //Numero random para que SpringBatch no interprete que es el mismo batch y no permita
        //ejecutar dos veces el mismo fichero
        params.put("random", System.currentTimeMillis());
        params.put(EXTRACTTIME, getDateFromFile(semaphore.getAbsolutePath()));
        params.put(PATHTOEXTRACT, semaphore.getParent());
        params.put(ZIPFILE, FileUtils.replaceExtension(semaphore.getAbsolutePath(), ZIP));
        params.put(ZIPFILETOEXTRACT, ".*");
        String pathToSqlLoader = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.PATH_TO_SQLLOADER);
        if (pathToSqlLoader != null) {
            params.put(PATHTOSQLLOADER, pathToSqlLoader);
        }
        /* String controlFile = entidadDao.get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.CONTROL_FILE);
         if (controlFile!=null){
         	params.put("controlFile", controlFile);
         }
         */
        String connectionInfo = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.CONNECTION_INFO);
        if (connectionInfo != null) {
            params.put(CONNECTIONINFO, connectionInfo);
        }
        String sqlLoaderParameters = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.SQLLDR_PARAMS);
        if (sqlLoaderParameters != null) {
            params.put(SQLLOADERPARAM, sqlLoaderParameters);
        }
        //Tomo el archivo de semaforo
        String cirbe = semaphore.getAbsolutePath();
        //Los archivos txt y csv se llaman igual pero cambia la extensi�n:
        params.put(CIRBE_TXT, FileUtils.replaceExtension(cirbe, TXT));
        params.put(CIRBE_CSV, FileUtils.replaceExtension(cirbe, CSV));

        return params;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        getEventManager().fireEvent(EventManager.GENERIC_CHANNEL,
                "Nuevo fichero [CIRBE:" + getFile().getAbsolutePath() + "] lanzando job [" + CIRBE_JOBNAME + "]");

        // Get Entity & upload dbId
        Entidad e = getEntidadDao().findByWorkingCode(workingCode);
        DbIdContextHolder.setDbId(e.getId());

        // Build parameters
        Map<String, Object> params = buildParameters(getFile());

        // Extract semaphore data & launch
        BatchExitStatus result = null;
        if (getFile().isFile() && getFile().exists()) {
            //Confirmamos que el semaforo se ha copiado completamente
            waitEndOfFile(getFile());
            Properties p = FileUtils.readProperties(getFile());
            String cirbeRowCount = p.getProperty(PROP_CIRBE_ROWCOUNT);

            boolean errores = false;
            if (cirbeRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("cirbeRowCount.nulo", "FATAL", false);
            }

            if (!errores) {
                //Saco saltos de l�nea y espacios de m�s
                cirbeRowCount = cirbeRowCount.replaceAll("\n", "").trim();
                /*if (contratosRowCount == null || personasRowCount == null || relacionesRowCount == null || contratosSunPosVencida == null) {
                    throw new BatchException(BATCH_PCR_SEMAPHOR_ERROR, "No hay datos en el semaforo");
                }*/

                params.put(ENTIDAD, workingCode);
                params.put(PROP_CIRBE_ROWCOUNT, cirbeRowCount);

                //Confirmamos que el fichero pcr se ha copiado completamente
                waitEndOfFile(new File(params.get(ZIPFILE).toString()));
                // Launch Job
                result = getBatchManager().run(CIRBE_JOBNAME, params);

                // Backup files
                backupFile((String) params.get(ZIPFILE), (String) params.get(PATHTOEXTRACT));
                backupFile(getFile().getAbsolutePath(), (String) params.get(PATHTOEXTRACT));

                // Delete files
                deleteFile((String) params.get(CIRBE_TXT));
                deleteFile((String) params.get(CIRBE_CSV));

                // Lanzar el evento "he terminado"
                if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {

                    Event event = new GenericEvent();
                    event.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));
                    event.setProperty(CIRBE_TXT, (String) params.get(CIRBE_TXT));
                    event.setProperty(CIRBE_CSV, (String) params.get(CIRBE_CSV));

                    event.setProperty(PROP_CIRBE_ROWCOUNT, cirbeRowCount);
                    event.setProperty(EXTRACTTIME, (Date) params.get(EXTRACTTIME));

                    event.setProperty(ENTIDAD, workingCode);
                    event.setProperty(FILENAME, getFile().getName());
                    getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, event);
                } else {
                    sendEndChainEvent(workingCode);
                }
            }

        } else {
            // Fire warning...
            sendEndChainEvent(workingCode);
            EventBatchUtil.getInstance().throwEventErrorChannel("Fichero [CIRBE:" + getFile().getAbsolutePath() + "] inexistente.", "FATAL");
        }

        //return result;

    }

}
