package es.pfsgroup.recovery.bpmframework.api.dto;

/**
 * Retro-llamada que se ejecuta al finalizar un proceso batch
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkCallback {

	/**
	 * Especifica la operaci�n de negocio a ejecutar si el INPUT se procesa
	 * correctamente
	 * 
	 * @return
	 *            Nombre de la operaci�n de negocio, puede ser NULL si no se
	 *            tienen que hacer nada.
	 *            <p>
	 *            La operaci�n de negocio va a recibir los siguientes par�metros
	 *            <ol>
	 *            <li>Long idProceso. Id del proceso batch. Se corresponde con
	 *            el que se indica al programar el input</li>
	 *            <li>{@link RecoveryBPMfwkInputDto} input. Input que se ha
	 *            procesado</li>
	 *            </ol>
	 *            </p>
	 */
	String onSuccess();

	/**
	 * Especifica la operaci�n de negocio a ejecutar si el INPUT no se ha podido
	 * procesar.
	 * 
	 * @return
	 *            Nombre de la operaci�n de negocio, puede ser NULL si no se
	 *            tienen que hacer nada.
	 *            <p>
	 *            La operaci�n de negocio va a recibir los siguientes par�metros
	 *            <ol>
	 *            <li>Long idProceso. Id del proceso batch. Se corresponde con
	 *            el que se indica al programar el input</li>
	 *            <li>{@link RecoveryBPMfwkInputDto} input. Input que se ha
	 *            procesado</li>
	 *            <li>String errorMessage. Mensaje de error.</li>
	 *            </ol>
	 *            </p>
	 */
	String onError();

	/**
	 * Operaci�n de negocio que se ejecuta cuando se empieza de procesar todo el
	 * conjunto de INPUTS
	 * 
	 * @return
	 *            Nombre de la operaci�n de negocio, puede ser NULL si no se
	 *            tienen que hacer nada.
	 *            <p>
	 *            La operaci�n de negocio va a recibir los siguientes par�metros
	 *            <ol>
	 *            <li>Long idProceso. Id del proceso batch. Se corresponde con
	 *            el que se indica al programar el input</li>
	 *            </ol>
	 *            </p>
	 */
	String onProcessStart();

	/**
	 * Operaci�n de negocio que se ejecuta cuando se termina de procesar todo el
	 * conjunto de INPUTS
	 * 
	 * @param businessOperation
	 *            Nombre de la operaci�n de negocio, puede ser NULL si no se
	 *            tienen que hacer nada.
	 *            <p>
	 *            La operaci�n de negocio va a recibir los siguientes par�metros
	 *            <ol>
	 *            <li>Long idProceso. Id del proceso batch. Se corresponde con
	 *            el que se indica al programar el input</li>
	 *            </ol>
	 */
	String onProcessEnd();

}
