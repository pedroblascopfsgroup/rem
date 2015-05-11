package es.pfsgroup.recovery.bpmframework.api;

import java.util.Date;
import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

/**
 * Esta interfaz define las operaciones de negocio para procesar INPUTS en modo
 * Batch
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkBatchApi {

    String PLUGIN_RECOVERYBPMFWK_BO_PROGRAMA_INPUT_BATCH = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.programaProcesadoInput";
    String PLUGIN_RECOVERYBPMFWK_BO_EJECUTA_PETICIONES_BATCH = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.ejecutaPeticionesBatchPendientes";
    String PLUGIN_RECOVERYBPMFWK_BO_GET_TOKEN = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.getToken";
    String PLUGIN_RECOVERYBPMFWK_BO_COMPRUEBA_NUM_INPUTS = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.compruebaInputsPendientes";
    String PLUGIN_RECOVERYBPMFWK_BO_PROCESAR_INPUT = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.procesarInput";
    String PLUGIN_RECOVERYBPMFWK_BO_OBTENER_LISTA_PETICIONES_PENDIENTES = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.obtenerListaPeticionesPendientes";
    String PLUGIN_RECOVERYBPMFWK_BO_OBTENER_NUMERO_PETICIONES_PENDIENTES = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.obtenerNumeroPeticionesPendientes";
    String PLUGIN_RECOVERYBPMFWK_BO_GESTIONAR_PROCESADO_INPUT_ERROR = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi.gestionarProcesadoInputError";    
    
    /**
     * Programa un INPUT para que se ejecute en modo Batch
     * 
     * @param idToken
     *            . Long que identifica a un conjunto de INPUTS que se tienen
     *            que procesar a la vez.
     * @param input
     *            . Input a procesar
     * @param callback
     *            . Funciones que se deben ejecutar al terminar, si es NULL no
     *            se va a ejecutar nada.
     * 
     * @throws RecoveryBPMfwkError
     *             Si por cualquier causa no se ha podido programar el procesado
     *             del input.
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_PROGRAMA_INPUT_BATCH)
    void programaProcesadoInput(Long idToken, RecoveryBPMfwkInputDto input, RecoveryBPMfwkCallback callback) throws RecoveryBPMfwkError;

    /**
     * Procesa en diferido los inputs agrupados por el token idProceso y va
     * llamando a los callbacks definidos.
     * 
     * @throws RecoveryBPMfwkError
     *             Si hay cualquier problema para poder ejecutar las peticiones.
     *             No se lanza esta excepción si falla el procesado de algún
     *             input.
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_EJECUTA_PETICIONES_BATCH)
    void ejecutaPeticionesBatchPendientes() throws RecoveryBPMfwkError;
    
    /**
     * Procesa un input independiente y de modo transaccional
     * @param peticion
     * @param esNecesarioEjecutarOnStart
     * @param esNecesarioEjecutarOnEnd
     * @param fechaProcesado
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_PROCESAR_INPUT)
    void procesarInput(RecoveryBPMfwkPeticionBatch peticion, boolean esNecesarioEjecutarOnStart, boolean esNecesarioEjecutarOnEnd, Date fechaProcesado);
    
    /**
     * Obtiene la lista de inputs pendientes de procesar
     * @return
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_OBTENER_LISTA_PETICIONES_PENDIENTES)
    List<RecoveryBPMfwkPeticionBatch> obtenerListaPeticionesPendientes();
    
    /**
     * Obtiene el numero de inputs pendientes de procesar
     * @return
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_OBTENER_NUMERO_PETICIONES_PENDIENTES)
    Long obtenerNumeroPeticionesPendientes();
    
    /**
     * Gestiona el error de un input una vez se ha hecho el rollback de la transacción
     * @param peticion
     * @param esNecesarioEjecutarOnEnd
     * @param fechaProcesado
     * @param descripcionError
     * @throws RecoveryBPMfwkError
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_GESTIONAR_PROCESADO_INPUT_ERROR)
    void gestionarProcesadoInputError(RecoveryBPMfwkPeticionBatch peticion,	boolean esNecesarioEjecutarOnEnd, 
    		Date fechaProcesado, String descripcionError) throws RecoveryBPMfwkError;

    /**
     * Genera un nuevo token para las peticiones de procesado batch.
     * 
     * @return
     * 
     * @throws RecoveryBPMfwkError
     *             Si hay cualquier problema para poder devolver el token.
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_GET_TOKEN)
    Long getToken() throws RecoveryBPMfwkError;

    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_COMPRUEBA_NUM_INPUTS)
	String compruebaInputsPendientes();

}
