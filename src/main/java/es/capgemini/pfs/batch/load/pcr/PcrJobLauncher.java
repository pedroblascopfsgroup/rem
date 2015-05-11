package es.capgemini.pfs.batch.load.pcr;

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
 * @author pamuller / aesteban
 */
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Component(PcrJobLauncher.BEAN_KEY)
public class PcrJobLauncher extends BatchJobLauncher implements BatchPCRConstantes {
    
    public static final String BEAN_KEY="pcrJobLauncher";

    private static final String PCR = "PCR";
    private static final String CONTRATOS = "CONTRATOS";
    private static final String PERSONAS = "PERSONAS";
    private static final String RELACION = "RELACION";
    private static final String DIRECCIONES = "DIRECCIONES";

    private static final String PROP_CONTRATOS_ROWCOUNT = "Contratos.rowcount";
    private static final String PROP_PERSONAS_ROWCOUNT = "Personas.rowcount";
    private static final String PROP_RELACIONES_ROWCOUNT = "Relaciones.rowcount";
    private static final String PROP_CONTRATOS_SUM_POS_VENCIDA = "Contratos.sumPosVencida";
    private static final String PROP_DIRECCIONES_ROWCOUNT = "Direcciones.rowcount";

    private String workingCode;
    private Date extractTime;

    /**
     * {@inheritDoc}
     */
    @Override
    public void handle(File file) {
        setFile(file);
        workingCode = getWorkingCodeFromFileName(getFile().getName(), getAppProperty(PCR_SEMAPHORE));
        extractTime = getDateFromFile(file.getAbsolutePath());

        getJobManager().addJob(PCR_LOAD_JOBNAME, workingCode, this, new JobExecutionPolicy[] { new JEPRunAloneEntity(), new PcrJEP() });

    }

    /**
     * Sends an END event to the PCR jobs chain.
     *
     * @param wc
     */
    private void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(PCR_CHAIN_CHANNEL, workingCode), CHAIN_END);
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
        params.put(EXTRACTTIME, extractTime);
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
        String contratos = semaphore.getAbsolutePath().replace(PCR, CONTRATOS);
        params.put(CONTRATOS_TXT, FileUtils.replaceExtension(contratos, TXT));
        params.put(CONTRATOS_CSV, FileUtils.replaceExtension(contratos, CSV));
        String personas = semaphore.getAbsolutePath().replace(PCR, PERSONAS);
        params.put(PERSONAS_TXT, FileUtils.replaceExtension(personas, TXT));
        params.put(PERSONAS_CSV, FileUtils.replaceExtension(personas, CSV));
        String relacion = semaphore.getAbsolutePath().replace(PCR, RELACION);
        params.put(RELACION_TXT, FileUtils.replaceExtension(relacion, TXT));
        params.put(RELACION_CSV, FileUtils.replaceExtension(relacion, CSV));
        String direcciones = semaphore.getAbsolutePath().replace(PCR, DIRECCIONES);
        params.put(DIRECCIONES_TXT, FileUtils.replaceExtension(direcciones, TXT));
        params.put(DIRECCIONES_CSV, FileUtils.replaceExtension(direcciones, CSV));

        return params;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
        getEventManager().fireEvent(EventManager.GENERIC_CHANNEL,
                "Nuevo fichero [PCR:" + getFile().getAbsolutePath() + "] lanzando job [" + PCR_LOAD_JOBNAME + "]");

        // Get workingCode from semaphore fileName
        String workingCode = getWorkingCodeFromFileName(getFile().getName(), getAppProperty(PCR_SEMAPHORE));

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
            String contratosRowCount = p.getProperty(PROP_CONTRATOS_ROWCOUNT);
            String personasRowCount = p.getProperty(PROP_PERSONAS_ROWCOUNT);
            String relacionesRowCount = p.getProperty(PROP_RELACIONES_ROWCOUNT);
            String direcionesRowCount = p.getProperty(PROP_DIRECCIONES_ROWCOUNT);
            String contratosSunPosVencida = p.getProperty(PROP_CONTRATOS_SUM_POS_VENCIDA);
            boolean errores = false;
            if (contratosRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("contratosRowCount.nulo", "FATAL", false);
            }
            if (personasRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("personasRowCount.nulo", "FATAL", false);
            }
            if (relacionesRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("relacionesRowCount.nulo", "FATAL", false);
            }
            if (direcionesRowCount == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("direcionesRowCount.nulo", "FATAL", false);
            }
            if (contratosSunPosVencida == null) {
                errores = true;
                EventBatchUtil.getInstance().throwEventErrorChannel("contratosSunPosVencida.nulo", "FATAL", false);
            }
            if (!errores) {
                //return BatchExitStatus.FAILED;

                /*if (contratosRowCount == null || personasRowCount == null || relacionesRowCount == null || contratosSunPosVencida == null) {
                    throw new BatchException(BATCH_PCR_SEMAPHOR_ERROR, "No hay datos en el semaforo");
                }*/

                params.put(ENTIDAD, workingCode);
                params.put(PCR_CNT_PARAM_ROWCOUNT, contratosRowCount);
                params.put(PCR_PER_PARAM_ROWCOUNT, personasRowCount);
                params.put(PCR_REL_PARAM_ROWCOUNT, relacionesRowCount);
                params.put(PCR_DIR_PARAM_ROWCOUNT, direcionesRowCount);
                params.put(PCR_CNT_PARAM_SUM_POS_VENCIDA, contratosSunPosVencida);

                //Confirmamos que el fichero pcr se ha copiado completamente
                waitEndOfFile(new File(params.get(ZIPFILE).toString()));
                // Launch Job
                result = getBatchManager().run(PCR_LOAD_JOBNAME, params);

                // Backup files
                backupFile((String) params.get(ZIPFILE), (String) params.get(PATHTOEXTRACT));
                backupFile(getFile().getAbsolutePath(), (String) params.get(PATHTOEXTRACT));

                // Delete files
                deleteFile((String) params.get(CONTRATOS_TXT));
                deleteFile((String) params.get(CONTRATOS_CSV));
                deleteFile((String) params.get(PERSONAS_TXT));
                deleteFile((String) params.get(PERSONAS_CSV));
                deleteFile((String) params.get(RELACION_TXT));
                deleteFile((String) params.get(RELACION_CSV));
                deleteFile((String) params.get(DIRECCIONES_TXT));
                deleteFile((String) params.get(DIRECCIONES_CSV));

                // Lanzar el evento "he terminado"
                if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {

                    Event event = new GenericEvent();
                    event.setProperty(SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));
                    event.setProperty(CONTRATOS_TXT, (String) params.get(CONTRATOS_TXT));
                    event.setProperty(CONTRATOS_CSV, (String) params.get(CONTRATOS_CSV));
                    event.setProperty(PERSONAS_TXT, (String) params.get(PERSONAS_TXT));
                    event.setProperty(PERSONAS_CSV, (String) params.get(PERSONAS_CSV));
                    event.setProperty(RELACION_TXT, (String) params.get(RELACION_TXT));
                    event.setProperty(RELACION_CSV, (String) params.get(RELACION_CSV));
                    event.setProperty(DIRECCIONES_TXT, (String) params.get(DIRECCIONES_TXT));
                    event.setProperty(DIRECCIONES_CSV, (String) params.get(DIRECCIONES_CSV));
                    event.setProperty(PCR_CNT_PARAM_ROWCOUNT, contratosRowCount);
                    event.setProperty(PCR_PER_PARAM_ROWCOUNT, personasRowCount);
                    event.setProperty(PCR_REL_PARAM_ROWCOUNT, relacionesRowCount);
                    event.setProperty(PCR_DIR_PARAM_ROWCOUNT, direcionesRowCount);
                    event.setProperty(PCR_CNT_PARAM_SUM_POS_VENCIDA, contratosSunPosVencida);
                    event.setProperty(EXTRACTTIME, (Date) params.get(EXTRACTTIME));

                    event.setProperty(ENTIDAD, workingCode);
                    event.setProperty(FILENAME, getFile().getName());
                    getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, event);
                } else {
                    sendEndChainEvent(workingCode);
                }

            } else {
                // Fire warning...
                sendEndChainEvent(workingCode);
                EventBatchUtil.getInstance().throwEventErrorChannel("Fichero [PCR:" + getFile().getAbsolutePath() + "] inexistente.", "FATAL");
            }

            //return result;
        }

    }

}
