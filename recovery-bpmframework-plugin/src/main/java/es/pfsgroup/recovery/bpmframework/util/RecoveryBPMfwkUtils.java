package es.pfsgroup.recovery.bpmframework.util;

import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

/**
 * Clase de utilidades para el framework.
 * @author manuel
 *
 */
public class RecoveryBPMfwkUtils {
	
	/**
	 * Comprueba que un objeto no sea nulo.
	 * 
	 * Si el objeto es nulo lanza una excepción {@link RecoveryBPMfwkError} 
	 *
	 * @param obj objeto a comprobar
	 * @throws RecoveryBPMfwkError Excepción que se lanza en caso de que el objeto sea nulo.
	 */	
	public static void isNotNull(final Object obj) throws RecoveryBPMfwkError{
		Assertions.assertNotNull(obj, "El objeto no puede ser null");
	}

	/**
	 * Comprueba que un objeto no sea nulo.
	 * 
	 * Si el objeto es nulo lanza una excepción {@link RecoveryBPMfwkError} 
	 *
	 * @param obj objeto a comprobar
	 * @param msg mensaje a mostrar en caso de que el objeto sea nulo.
	 * @throws RecoveryBPMfwkError Excepción que se lanza en caso de que el objeto sea nulo.
	 */
	public static void isNotNull(final Object obj, final String msg) throws RecoveryBPMfwkError{
		
		try{
		Assertions.assertNotNull(obj, msg);
		} catch (Exception ex){
			throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS , ex);
		}
		
	}

}
