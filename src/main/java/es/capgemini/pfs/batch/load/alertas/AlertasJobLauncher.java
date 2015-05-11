package es.capgemini.pfs.batch.load.alertas;

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
 * @author aesteban
 */
@Component(AlertasJobLauncher.BEAN_KEY)
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class AlertasJobLauncher extends BatchJobLauncher implements BatchAlertasConstants {

    public static final String BEAN_KEY="alertasJobLauncher";
    private static final String PROP_ALERTAS_ROWCOUNT = "Alertas.rowcount";
    private String workingCode;

    /**
     * {@inheritDoc}
     */
    @Override
    public void handle(File file) {
        setFile(file);
        workingCode = getWorkingCodeFromFileName(getFile().getName(), getAppProperty(ALE_SEMAPHORE));
        getJobManager().addJob(ALE_LOAD_JOBNAME, workingCode, this, new JobExecutionPolicy[] { new JEPRunAloneEntity() });

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        getEventManager().fireEvent(EventManager.GENERIC_CHANNEL,
                "Nuevo fichero [ALE:" + getFile().getAbsolutePath() + "] lanzando job [" + ALE_LOAD_JOBNAME + "]");

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
            String alertasRowCount = p.getProperty(PROP_ALERTAS_ROWCOUNT);
            boolean errores = false;
            if (alertasRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("alertasRowCount.nulo", "FATAL", false);
            }

            if (!errores) {
                //return BatchExitStatus.FAILED;

                alertasRowCount = alertasRowCount.replaceAll("\n", "").trim();
                params.put(ENTIDAD, workingCode);
                params.put(ALERTAS_PARAM_ROWCOUNT, alertasRowCount);

                //Confirmamos que el fichero pcr se ha copiado completamente
                waitEndOfFile(new File(params.get(ZIPFILE).toString()));
                // Launch Job
                result = getBatchManager().run(ALE_LOAD_JOBNAME, params);

                // Backup files
                backupFile((String) params.get(ZIPFILE), (String) params.get(PATHTOEXTRACT));
                backupFile(getFile().getAbsolutePath(), (String) params.get(PATHTOEXTRACT));

                // Delete files
                deleteFile((String) params.get(ALERTAS_TXT));
                deleteFile((String) params.get(ALERTAS_CSV));

                // Lanzar el evento "he terminado"
                if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {

                    Event event = new GenericEvent();
                    event.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));
                    event.setProperty(ALERTAS_TXT, (String) params.get(ALERTAS_TXT));
                    event.setProperty(ALERTAS_CSV, (String) params.get(ALERTAS_CSV));

                    event.setProperty(ALERTAS_PARAM_ROWCOUNT, alertasRowCount);

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
            EventBatchUtil.getInstance().throwEventErrorChannel("Fichero [ALE:" + getFile().getAbsolutePath() + "] inexistente.", "FATAL");
        }

        //return result;

    }

    /**
     * Sends an END event to the PCR jobs chain.
     *
     * @param wc
     */
    private void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(ALE_CHAIN_CHANNEL, workingCode), CHAIN_END);
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
        String connectionInfo = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.CONNECTION_INFO);
        if (connectionInfo != null) {
            params.put(CONNECTIONINFO, connectionInfo);
        }
        String sqlLoaderParameters = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.SQLLDR_PARAMS);
        if (sqlLoaderParameters != null) {
            params.put(SQLLOADERPARAM, sqlLoaderParameters);
        }
        String alertas = semaphore.getAbsolutePath();
        params.put(ALERTAS_TXT, FileUtils.replaceExtension(alertas, TXT));
        params.put(ALERTAS_CSV, FileUtils.replaceExtension(alertas, CSV));

        return params;
    }

}
