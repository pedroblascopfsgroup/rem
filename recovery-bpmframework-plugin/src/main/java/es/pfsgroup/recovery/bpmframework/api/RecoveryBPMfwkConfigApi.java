package es.pfsgroup.recovery.bpmframework.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

/**
 * Operaciones de negocio para acceder a la configuraci�n del BPM
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkConfigApi {
    
//    String PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT_CONFIG = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi.getInputConfig";
    String PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT_CONFIG_NODO = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi.getInputConfigNodo";

//    /**
//     * Devuelve la configuraci�n para un determinado INPUT en base al tipo de
//     * input y al tipo de procedimiento al que se quiera aplicar.
//     * 
//     * @param codigoTipoInput C�digo del tipo de Input
//     * @param codigoTipoProcedimiento C�digo del tipo de procedimiento
//     * 
//     * @return <strong>Devuelve NULL si no hay configuraci�n para ese tipo de input/tipo de procedimiento</strong>
//     * 
//     * @throws RecoveryBPMfwkError Si existe cualquier problema al devolver la configuraci�n para un input
//     */
//    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT_CONFIG)
//    @Deprecated
//    RecoveryBPMfwkCfgInputDto getInputConfig(String codigoTipoInput, String codigoTipoProcedimiento) throws RecoveryBPMfwkError;

    /**
     * Devuelve la configuraci�n para un determinado INPUT en base al tipo de
     * input, tipo de procedimiento y tipo de nodo origen aplicados.
     * 
     * @param codigoTipoInput C�digo del tipo de Input
     * @param codigoTipoProcedimiento C�digo del tipo de procedimiento
     * @param codigoNodo C�digo del nodo origen
     * 
     * @return devuelve la configuraci�n {@link RecoveryBPMfwkCfgInputDto}
     * 
     * @throws RecoveryBPMfwkError Si existe cualquier problema al devolver la configuraci�n para un input:
     * 	- si no encuentra la configuraci�n.
     * 	- si hay ambig�edad en la configuraci�n.
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT_CONFIG_NODO)
    RecoveryBPMfwkCfgInputDto getInputConfigNodo(String codigoTipoInput, String codigoTipoProcedimiento, String codigoNodo) throws RecoveryBPMfwkError;

}
