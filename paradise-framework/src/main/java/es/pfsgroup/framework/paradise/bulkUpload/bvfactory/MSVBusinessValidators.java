package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;

/**
 * Esta interfaz representa un conjunto de validadores para una determinada
 * operación masiva. Estas validaciones se obtienen usando la factoría
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
