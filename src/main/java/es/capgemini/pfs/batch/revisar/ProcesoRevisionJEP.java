package es.capgemini.pfs.batch.revisar;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.batch.load.BatchPasajeProduccionHandler;
import es.capgemini.pfs.batch.load.gcl.GruposClientesFileHandler;
import es.capgemini.pfs.batch.prepoliticas.ProcesarPrepoliticasJob;
import es.capgemini.pfs.batch.scoring.ProcesarAlertasJob;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.capgemini.pfs.utils.FormatUtils;

public class ProcesoRevisionJEP extends JobExecutionPolicy {

    

    public ProcesoRevisionJEP(String workingCode, Date extractTime) {
       
    }

    
    /**
     * Politia: No se puede ejecutar una revision si esta esperando para 
     * ejecucion uno job de tipo:
     *      - PCR
     *      - Scoring
     *      - Prepolitica
     *      - Carga Grupos
     * 
     */
    @SuppressWarnings("unchecked")
    @Override
    public boolean validatePreRunning() {
       
        return true;
    }

    /**
     * Metodo para verificar si se debe agregar la revision o no.
     * Politica: Si ya ha una revision para la misma fecha de extracción NO
     * debemos generar una nueva.
     */
    @Override
    public boolean validatePreLoad() {
        
        return true;
    }

}
