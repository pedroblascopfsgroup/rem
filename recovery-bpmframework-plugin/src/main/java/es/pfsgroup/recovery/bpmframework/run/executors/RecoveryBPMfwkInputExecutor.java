package es.pfsgroup.recovery.bpmframework.run.executors;

import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Un input executor es un objeto que sabe cómo procesar un input determinado.
 * Existen tantas implementaciones de esta interfaz como de tipos de procesado
 * de input.
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkInputExecutor {

    /**
     * Procesa el input
     * 
     * @param myInput Input a procesar.
     */
    void execute(final RecoveryBPMfwkInput myInput) throws Exception;

	/**
	 * Indica el tipo de accion(tipo de procesado) que es capaz de ejecutar
	 * @return (String) devuleve un tipo de acción. 
	 */
	//String getTipoAccion();
	
	/**
	 * Indica los tipos de acciones(tipo de procesado) que es capaz de ejecutar
	 * @return (String) devuleve un array de tipos de acción. 
	 */
	String[] getTiposAccion();

}
