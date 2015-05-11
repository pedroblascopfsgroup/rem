package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchJobLauncher;

import java.io.File;
import java.util.Date;
import java.util.Map;
import java.util.Properties;

import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchJobLauncher;

/**
 * Esta clase sobreescribe la clase original para testear y sirve para testear los métodos protected
 * @author bruno
 *
 */
public class PFSBatchJobLauncherForTesting extends PFSBatchJobLauncher{
    public void putPropertiesIntoMap(final Map<String, Object> params, final Properties p) {
        super.putPropertiesIntoMap(params, p);
    }

    @Override
    public String filePath(String value, File semaphore) {
        return super.filePath(value, semaphore);
    }

    @Override
    public void putFileIntoMap(Map<String, Object> params, String fileKey, String fileValue, File semaphore) {
        super.putFileIntoMap(params, fileKey, fileValue, semaphore);
    }

    @Override
    public JobExecutionPolicy[] getPoliciesAsArray() {
        return super.getPoliciesAsArray();
    }

    @Override
    public Map<String, Object> buildParameters(File semaphore) {
        return super.buildParameters(semaphore);
    }

    @Override
    public Date getDateFromFile(String fileName) {
        return super.getDateFromFile(fileName);
    }
}
