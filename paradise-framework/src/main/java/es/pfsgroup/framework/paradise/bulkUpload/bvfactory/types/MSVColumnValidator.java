package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types;

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
	 * Devuelve el tipo de validación que se quiere hacer.
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
	 * Indica si el parámetro es requerido
	 * 
	 * @return
	 */
	boolean isRequired();

	/**
	 * Devuelve la configuración del resultado de la SQL.
	 * <p>
	 * Esta configuración se usa en el tipo de validación CONFIGURABLE y consise
	 * en un Map cuya clave (Integer) es el resultado que devuelva la validación
	 * y el valor indica si es OK o KO
	 * 
	 * @return Devuelve NULL si la validación no es de tipo configurable
	 */
	Map<Integer, MSVResultadoValidacionSQL> getResultConfig();
}
