package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchJobLauncher;

import static org.mockito.Mockito.*;

import java.util.Date;
import java.util.Map;

import org.mockito.ArgumentCaptor;

import es.capgemini.devon.batch.BatchManager;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchJobLauncher;

/**
 * Verificador de interacciones del job launcher
 * 
 * @author bruno
 * 
 */
public class VerificadorPFSBatchJobLauncher {
    
    private  BatchManager mockBatchManager;
    private JobController mockJobController;
    
    public VerificadorPFSBatchJobLauncher(BatchManager mockBatchManager, JobController mockJobController) {
        super();
        this.mockBatchManager = mockBatchManager;
        this.mockJobController = mockJobController;
    }

    public void seHaEjecutadoElJobBatch(final String jobName, final Map<String,Object> params) {
        ArgumentCaptor<Map> paramsArgumentCaptor = ArgumentCaptor.forClass(Map.class);
        verify(mockBatchManager,times(1)).run(eq(jobName), paramsArgumentCaptor.capture());
        
    }

    public void seHaAnyadidoElJob(String jobName, String workingCode, JobExecutionPolicy[] policies) {
        verify(mockJobController,times(1)).addJob(eq(jobName), eq(workingCode), any(PFSBatchJobLauncher.class), eq(policies));
        
    }
}
