package es.capgemini.pfs.batch.load.gcl;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

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
@Component(GruposClientesJobLauncher.BEAN_KEY)
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class GruposClientesJobLauncher extends BatchJobLauncher implements BatchGruposClientesConstants {

    private String workingCode;
    public static final String BEAN_KEY="gruposClientesJobLauncher";

    /**
     * {@inheritDoc}
     */
    @Override
    public void handle(File file) {
        setFile(file);
        // Get workingCode from semaphore fileName
        workingCode = getWorkingCodeFromFileName(getFile().getName(), getAppProperty(BATCH_GCL_SEMAPHORE));
        getJobManager().addJob(GCL_JOBNAME, workingCode, this, new JobExecutionPolicy[] { new JEPRunAloneEntity() });
    }

    /**
     * Sends an END event to the PCR jobs chain.
     *
     * @param wc
     */
    private void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(GCL_CHAIN_CHANNEL, workingCode), GruposClientesFileHandler.CHAIN_END);
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
        params.put("random", new Random(System.currentTimeMillis()).toString());
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
        String gcl = semaphore.getAbsolutePath();
        //Los archivos txt y csv se llaman igual pero cambia la extensi�n:
        params.put(GCL_TXT_GRUPOS, FileUtils.replaceExtension(gcl, TXT));
        params.put(GCL_CSV_GRUPOS, FileUtils.replaceExtension(gcl, CSV));
        params.put(GCL_TXT_RL, FileUtils.replaceExtension(gcl.replaceAll(GCL, GCL_RL), TXT));
        params.put(GCL_CSV_RL, FileUtils.replaceExtension(gcl.replaceAll(GCL, GCL_RL), CSV));

        return params;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        getEventManager().fireEvent(EventManager.GENERIC_CHANNEL,
                "Nuevo fichero [GCL:" + getFile().getAbsolutePath() + "] lanzando job [" + GCL_JOBNAME + "]");

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
            String gruposRowCount = p.getProperty(PROP_GCL_GRUPOS_ROWCOUNT);
            String relacionesRowCount = p.getProperty(PROP_GCL_RELACIONES_ROWCOUNT);

            boolean errores = false;
            if (gruposRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("GclCount.grupos.nulo", "FATAL", false);
            }
            if (relacionesRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("GclCount.relaciones.nulo", "FATAL", false);
            }

            if (!errores) {

                /*if (contratosRowCount == null || personasRowCount == null || relacionesRowCount == null || contratosSunPosVencida == null) {
                    throw new BatchException(BATCH_PCR_SEMAPHOR_ERROR, "No hay datos en el semaforo");
                }*/

                gruposRowCount = gruposRowCount.replaceAll("\n", "").trim();
                relacionesRowCount = relacionesRowCount.replaceAll("\n", "").trim();

                params.put(ENTIDAD, workingCode);
                params.put(PROP_GCL_GRUPOS_ROWCOUNT, gruposRowCount);
                params.put(PROP_GCL_RELACIONES_ROWCOUNT, relacionesRowCount);

                //Confirmamos que el fichero GCL se ha copiado completamente
                waitEndOfFile(new File(params.get(ZIPFILE).toString()));
                // Launch Job
                try {
                    result = getBatchManager().run(GCL_JOBNAME, params);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                // Backup files
                backupFile((String) params.get(ZIPFILE), (String) params.get(PATHTOEXTRACT));
                backupFile(getFile().getAbsolutePath(), (String) params.get(PATHTOEXTRACT));

                // Delete files
                deleteFile((String) params.get(GCL_TXT_GRUPOS));
                deleteFile((String) params.get(GCL_CSV_GRUPOS));
                deleteFile((String) params.get(GCL_TXT_RL));
                deleteFile((String) params.get(GCL_CSV_RL));

                // Lanzar el evento "he terminado"
                if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {

                    Event event = new GenericEvent();
                    event.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));
                    event.setProperty(GCL_TXT_GRUPOS, (String) params.get(GCL_TXT_GRUPOS));
                    event.setProperty(GCL_CSV_GRUPOS, (String) params.get(GCL_CSV_GRUPOS));
                    event.setProperty(GCL_TXT_RL, (String) params.get(GCL_TXT_RL));
                    event.setProperty(GCL_CSV_RL, (String) params.get(GCL_CSV_RL));

                    event.setProperty(PROP_GCL_GRUPOS_ROWCOUNT, gruposRowCount);
                    event.setProperty(PROP_GCL_RELACIONES_ROWCOUNT, relacionesRowCount);
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
            EventBatchUtil.getInstance().throwEventErrorChannel("Fichero [GCL:" + getFile().getAbsolutePath() + "] inexistente.", "FATAL");
        }

        //return result;

    }

}
