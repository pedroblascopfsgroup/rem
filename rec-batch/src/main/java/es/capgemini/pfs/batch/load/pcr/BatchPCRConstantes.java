package es.capgemini.pfs.batch.load.pcr;

import es.capgemini.pfs.batch.load.BatchLoadConstants;

/**
* Define todas las constantes en común que se usan
* para el canal de PCR y sus procesos.
* @author aesteban
*/
public interface BatchPCRConstantes extends BatchLoadConstants {

    String PCR_CHAIN_CHANNEL = "pcrChainChannel";
    String PCR_SEMAPHORE = "batch.pcr.semaphore";
    String PCR_CHANNEL_NAME = "PCR";

    String PCR_LOAD_JOBNAME = "loadPCRStarterJob";
    String PCR_VALIDACION_JOBNAME = "validacionesPCRJob";
    String PCR_PASAJE_JOBNAME = "pasajePCRProduccionJob";
    String PCR_PRECALCULO_JOBNAME = "precalculoPCRProduccionJob";
    String PCR_ANALIZE_JOBNAME = "analizePCRProduccionJob";
    String PCR_REVISION_JOBNAME = "procesoRevisionJob";
    String PCR_MANTENIMIENTO_JOBNAME = "procesoMantenimientoJob";

    String CONTRATOS_TXT = "txtFileContratos";
    String PERSONAS_TXT = "txtFilePersonas";
    String RELACION_TXT = "txtFileRelacion";
    String DIRECCIONES_TXT = "txtFileDirecciones";
    String CONTRATOS_CSV = "csvFileContratos";
    String PERSONAS_CSV = "csvFilePersonas";
    String RELACION_CSV = "csvFileRelacion";
    String DIRECCIONES_CSV = "csvFileDirecciones";

    String PCR_CNT_PARAM_ROWCOUNT = "contratosRowCount";
    String PCR_PER_PARAM_ROWCOUNT = "personasRowCount";
    String PCR_REL_PARAM_ROWCOUNT = "relacionesRowCount";
    String PCR_DIR_PARAM_ROWCOUNT = "direccionesRowCount";
    String PCR_CNT_PARAM_SUM_POS_VENCIDA = "contratosSunPosVencida";

}
