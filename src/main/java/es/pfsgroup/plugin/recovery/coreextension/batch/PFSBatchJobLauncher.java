package es.pfsgroup.plugin.recovery.coreextension.batch;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Random;

import es.capgemini.devon.batch.BatchExitStatus;
import es.capgemini.devon.events.Event;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.events.GenericEvent;
import es.capgemini.devon.events.router.GenericRouter;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.common.NumericResultValidatorTasklet;
import es.capgemini.pfs.batch.load.BatchJobLauncher;
import es.capgemini.pfs.batch.load.BatchLoadConstants;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.pfsgroup.commons.utils.Checks;

/**
 * Job launcher genérico para carga de ficheros a través del batch.
 * 
 * @author bruno
 * 
 */
public class PFSBatchJobLauncher extends BatchJobLauncher {

    private String workingCode;
    private Date extractTime;

    private String semaphoreName;
    private String jobName;
    private String chainChannel;

    private List<JobExecutionPolicy> jobExecutionPolicies;
    private Map<String, String> filesToLoad;

    private String filesExtension;


    public void setWorkingCode(String workingCode) {
        this.workingCode = workingCode;
    }


    public void setExtractTime(Date extractTime) {
        this.extractTime = extractTime;
    }


    public void setSemaphoreName(String semaphoreName) {
        this.semaphoreName = semaphoreName;
    }


    public void setJobName(String jobName) {
        this.jobName = jobName;
    }


    public void setChainChannel(String chainChannel) {
        this.chainChannel = chainChannel;
    }

    public void setJobExecutionPolicies(List<JobExecutionPolicy> jobExecutionPolicies) {
        this.jobExecutionPolicies = jobExecutionPolicies;
    }


    public void setFilesToLoad(Map<String, String> filesToLoad) {
        this.filesToLoad = filesToLoad;
    }

    public void setFilesExtension(String filesExtension) {
        this.filesExtension = filesExtension;
    }

    @Override
    public void handle(File file) {
        setFile(file);
        workingCode = getWorkingCodeFromSemaphore(getFile().getName());
        extractTime = getDateFromFile(file.getAbsolutePath());

        getJobManager().addJob(jobName, workingCode, this, getPoliciesAsArray());
    }

    @Override
    public void run() {
        getEventManager().fireEvent(EventManager.GENERIC_CHANNEL, "Carga de fichero [" + getFile().getAbsolutePath() + "] lanzando job [" + jobName + "]");

        // Get workingCode from semaphore fileName
        String workingCode = getWorkingCodeFromSemaphore(getFile().getName());

        // Get Entity & upload dbId
        Entidad e = getEntidadDao().findByWorkingCode(workingCode);
        DbIdContextHolder.setDbId(e.getId());

        // Build parameters
        Map<String, Object> params = buildParameters(getFile());

        // Extract semaphore data & launch
        BatchExitStatus result = null;
        if (existsFile(getFile())) {
            Properties p = waitAndReadSemaphore(getFile());

            putPropertiesIntoMap(params, p);
            
            params.put(BatchLoadConstants.ENTIDAD, workingCode);

            // Confirmamos que el fichero pcr se ha copiado completamente
            waitEndOfFile(new File(params.get(BatchLoadConstants.ZIPFILE).toString()));
            // Launch Job
            result = getBatchManager().run(jobName, params);

            // Backup files
            backupFilesAfterLoad(params);
            

            // Delete files
            if (filesToLoad != null) {
                for (Entry<String, String> file : filesToLoad.entrySet()) {
                    deleteFile((String) params.get(file.getKey()));
                }
            }

            // Lanzar el evento "he terminado"
            if (BatchExitStatus.COMPLETED.equals(result)) {

                Event event = new GenericEvent();
                event.setProperty(BatchLoadConstants.SOURCE_CHANNEL_KEY, QueueUtils.getQueueNameForEntity(getChannel(), workingCode));
                if (filesToLoad != null) {
                    for (Entry<String, String> file : filesToLoad.entrySet()) {
                        event.setProperty(file.getKey(), (String) params.get(file.getKey()));
                    }
                }

                event.setProperty(BatchLoadConstants.EXTRACTTIME, (Date) params.get(BatchLoadConstants.EXTRACTTIME));
                event.setProperty(BatchLoadConstants.ENTIDAD, workingCode);
                event.setProperty(BatchLoadConstants.FILENAME, getFile().getName());
                getEventManager().fireEvent(GenericRouter.ROUTING_CHANNEL, event);
            } else {
                sendEndChainEvent(workingCode);
            }

        }
    }

    public void backupFilesAfterLoad(Map<String, Object> params) {
        backupFile((String) params.get(BatchLoadConstants.ZIPFILE), (String) params.get(BatchLoadConstants.PATHTOEXTRACT));
        backupFile(getFile().getAbsolutePath(), (String) params.get(BatchLoadConstants.PATHTOEXTRACT));
    }

    public Properties waitAndReadSemaphore(final File file) {
        // Confirmamos que el semaforo se ha copiado completamente
        waitEndOfFile(file);
        Properties p = FileUtils.readProperties(getFile());
        return p;
    }

    public boolean existsFile(final File file) {
        return file.isFile() && file.exists();
    }

    /**
     * Sends an END event to the PCR jobs chain.
     * 
     * @param wc
     */
    private void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(chainChannel, workingCode), BatchLoadConstants.CHAIN_END);
    }

    /**
     * Contruye los parametros.
     * 
     * @param semaphore
     *            File
     * @return Map
     */
    protected Map<String, Object> buildParameters(File semaphore) {
        // Build parameters
        Map<String, Object> params = new HashMap<String, Object>();
        // Numero random para que SpringBatch no interprete que es el mismo
        // batch y no permita
        // ejecutar dos veces el mismo fichero
        params.put("random", new Random(System.currentTimeMillis()).toString());
        params.put(BatchLoadConstants.EXTRACTTIME, extractTime);
        params.put(BatchLoadConstants.PATHTOEXTRACT, semaphore.getParent());
        params.put(BatchLoadConstants.ZIPFILE, FileUtils.replaceExtension(semaphore.getAbsolutePath(), BatchLoadConstants.ZIP));
        params.put(BatchLoadConstants.ZIPFILETOEXTRACT, ".*");
        String pathToSqlLoader = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.PATH_TO_SQLLOADER);
        if (pathToSqlLoader != null) {
            params.put(BatchLoadConstants.PATHTOSQLLOADER, pathToSqlLoader);
        }

        String connectionInfo = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.CONNECTION_INFO);
        if (connectionInfo != null) {
            params.put(BatchLoadConstants.CONNECTIONINFO, connectionInfo);
        }
        String sqlLoaderParameters = getEntidadDao().get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.SQLLDR_PARAMS);
        if (sqlLoaderParameters != null) {
            params.put(BatchLoadConstants.SQLLOADERPARAM, sqlLoaderParameters);
        }

        if (filesToLoad != null) {
            for (Entry<String, String> file : filesToLoad.entrySet()) {
                putFileIntoMap(params, file.getKey(), file.getValue(), semaphore);
            }
        }

        return params;
    }

    /**
     * 
     * @return
     */
    protected JobExecutionPolicy[] getPoliciesAsArray() {
        final JobExecutionPolicy[] emptyArray = new JobExecutionPolicy[] {};
        if (jobExecutionPolicies == null) {
            return emptyArray;
        } else {
            return jobExecutionPolicies.toArray(emptyArray);
        }
    }

    protected void putFileIntoMap(final Map<String, Object> params, final String fileKey, final String fileValue, final File semaphore) {
        if ((!Checks.esNulo(fileKey)) && (!Checks.esNulo(fileValue))) {
            params.put(fileKey, filePath(fileValue, semaphore));
        }

    }

    protected String filePath(final String value, final File semaphore) {
        final String dir = semaphore.getParent();
        final String fechaExtraccion = new SimpleDateFormat("yyyyMMdd").format(extractTime);
        final String path = dir + "/" + value + "-" + workingCode + "-" + fechaExtraccion + "." + filesExtension;
        return new File(path).getAbsolutePath();
    }

    protected void putPropertiesIntoMap(final Map<String, Object> params, final Properties p) {
        if (p != null) {
            for (Entry<Object, Object> property : p.entrySet()) {
                params.put(property.getKey().toString(), property.getValue());
            }
        }
    }
    
    public String getWorkingCodeFromSemaphore(String fileName) {
        return getWorkingCodeFromFileName(fileName, semaphoreName);
    }

}
