package es.capgemini.pfs.batch.load.alertas;

import es.capgemini.pfs.batch.load.BatchLoadConstants;

/**
 * Define todas las constantes en común que se usan
 * para el canal de alertas y sus procesos.
 * @author aesteban
 *
 */
public interface BatchAlertasConstants extends BatchLoadConstants {

    String ALE_CHANNEL_NAME = "ALE";
    String ALE_CHAIN_CHANNEL = "alertasChainChannel";

    String ALE_SEMAPHORE = "batch.alertas.semaphore";

    String ALE_LOAD_JOBNAME = "loadAlertasStarterJob";
    String ALE_VALITACION_JOBNAME = "validacionesAlertasJob";
    String ALE_PASAJE_JOBNAME = "pasajeAlertasProduccionJob";
    String ALE_ANALIZE_JOBNAME = "analizeAlertasProduccionJob";
    String ALE_PROCESAR_JOBNAME = "procesarAlertasJob";

    //Parámetros del job
    String ALERTAS_GRUPO_CARGA = "alertasGrupoCarga";
    String ALERTAS_TXT = "txtFileAlertas";
    String ALERTAS_CSV = "csvFileAlertas";
    String ALERTAS_PARAM_ROWCOUNT = "alertasRowCount";

    String ALERTAS_CODIGO_GRUPO_CARGA_PLACEHOLDER = "batch.alertas.codigoGrupoCarga.placeholder";
    String ALERTAS_CODIGO_GRUPO_CARGA_PATTERN = "batch.alertas.codigoGrupoCarga.pattern";
}
