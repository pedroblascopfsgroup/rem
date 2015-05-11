package es.pfsgroup.plugin.recovery.masivo.bvfactory.types;

import java.util.Map;

/**
 * Esta interfaz representa un validador de negocio para una determinada
 * columna.
 * 
 * @author bruno
 * 
 */
public interface MSVColumnValidator {

	public static final String DEBE_EXISTIR = "MSVColumnValidator.DEBE_EXISTIR";
	public static final String NO_DEBE_EXISTIR = "MSVColumnValidator.NO_DEBE_EXISTIR";
	public static final String CONFIGURABLE = "MSVColumnValidator.CONFIGURABLE";

	/**
	 * Devuelve el tipo de validaci�n que se quiere hacer.
	 * 
	 * @return
	 */
	String getTipoValidacion();

	/**
	 * Devuelve mensaje de error que se debe devolver en caso de que no se pueda
	 * validar.
	 * 
	 * @return
	 */
	String getErrorMessage();

	/**
	 * Indica si el par�metro es requerido
	 * 
	 * @return
	 */
	boolean isRequired();

	/**
	 * Devuelve la configuraci�n del resultado de la SQL.
	 * <p>
	 * Esta configuraci�n se usa en el tipo de validaci�n CONFIGURABLE y consise
	 * en un Map cuya clave (Integer) es el resultado que devuelva la validaci�n
	 * y el valor indica si es OK o KO
	 * 
	 * @return Devuelve NULL si la validaci�n no es de tipo configurable
	 */
	Map<Integer, MSVResultadoValidacionSQL> getResultConfig();
}
