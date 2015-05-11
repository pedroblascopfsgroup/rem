package es.pfsgroup.plugin.recovery.masivo.bvfactory;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;

/**
 * Esta interfaz representa un conjunto de validadores para una determinada
 * operaci�n masiva. Estas validaciones se obtienen usando la factor�a
 * {@link MSVBusinessValidationFactory}
 * 
 * @author bruno
 * 
 */
public interface MSVBusinessValidators {

	/**
	 * Devuelve el valiador para una determinada columna de un fichero
	 * @param colName Nombre de la columna
	 * @return
	 */
	MSVColumnValidator getValidatorForColumn(String colName);

}
