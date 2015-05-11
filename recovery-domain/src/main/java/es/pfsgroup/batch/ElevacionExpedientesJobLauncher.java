package es.pfsgroup.batch;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.BatchExitStatus;
import es.capgemini.devon.batch.BatchManager;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobRunner;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * Esta clase lanza el proceso de revisión.
 * @author jbosnjak
 */
public class ElevacionExpedientesJobLauncher implements BatchPCRConstantes, JobRunner {

    

	

    /**
     * Inicia el proceso de revisión general.
     * @param message Message
     */

    public void handle(String workingCode, Date extractTime) {
        
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {
    	
    }

    public final Date getExtractTime() {
        return null;
    }

}
