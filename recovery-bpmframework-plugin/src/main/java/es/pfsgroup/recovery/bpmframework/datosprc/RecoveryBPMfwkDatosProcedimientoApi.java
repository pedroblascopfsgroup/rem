package es.pfsgroup.recovery.bpmframework.datosprc;

import java.util.Map;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.datosprc.model.RecoveryBPMfwkDatosProcedimiento;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkConfiguracionError;

/**
 * Operaciones para la gestión de los datos de los procedimientos
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkDatosProcedimientoApi {

	public static final String PLUGIN_RECOVERYBPMFWK_BO_GET_DATOS_PERSISTIDOS = "es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimiento.getDatosPersistidos";
	public static final String PLUGIN_RECOVERYBPMFWK_BO_BORRAR_DATOS_PERSISTIDOS = "es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimiento.borrarDatosPersistidos";
	public static final String BORRAR_DATO = "1";
	public static final String VALOR_A_NULL = "2";

	
	
    /**
     * Guarda datos que nos llegan en un Input adjuntos al procedimiento.
     * 
     * @param idProcedimiento
     *            Id del procedimiento.
     * @param datosInput
     *            Mapa con los datos del Input
     * @param config
     *            DTO de configuración del Input
     * 
     * @throws RecoveryBPMfwkConfiguracionError
     *             Si no se encuentra la configuración que indica dónde
     *             almacenar algún dato. Si el método falla no se guarda nada.
     *             //TODO Hay que escribir el caso de pruebas para asergurarse
     *             de que esto se cumple.
     */
    void guardaDatos(final Long idProcedimiento, final Map<String, Object> datosInput, final RecoveryBPMfwkCfgInputDto config) throws RecoveryBPMfwkConfiguracionError;

    /**
	 * Recupera de la base de datos los datos del procedimiento ya almacenados.
	 * @param id del procedimiento
	 * @return mapa con los datos encontrado, la clave es el campo nombreDato.
	 */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_GET_DATOS_PERSISTIDOS)
	public Map<String,RecoveryBPMfwkDatosProcedimiento> getDatosPersistidos(Long idProcedimiento);
    
    
    /**
     * Borra de la base de datos los datos del procedimiento ya almacenados. 
     * Los datos no se borran, se actualiza su valor a null
     * 
     * @param idProcedimiento 
     * 				id del procedimiento
     * @param datosInput array con los datos a borrar. 
     * 				El valor debe coincidir con el de {@link RecoveryBPMfwkDatosProcedimiento#nombreDato} 
     * @param tipoBorrado 
     * 				Si el valor es {@link RecoveryBPMfwkDatosProcedimientoApi#BORRAR_DATO} , borra el dato. 
     * 				Si el valor es {@link RecoveryBPMfwkDatosProcedimientoApi#VALOR_A_NULL} , modifica el valor del dato a null. 
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_BORRAR_DATOS_PERSISTIDOS)
    public void borrarDatosPersistidos(final Long idProcedimiento, final String[] datosInput, String tipoBorrado);
    
}
