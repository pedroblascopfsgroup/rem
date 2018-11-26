package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

import java.util.List;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;

/**
 * Esta interfaz representa un conjunto de validadores para una determinada
 * operación masiva. Estas validaciones se obtienen usando la factoría
 * {@link MSVBusinessValidationFactory}
 * 
 * @author pedro
 * 
 */
public interface MSVBusinessCompositeValidators {

	/**
	 * Devuelve los validadores para un determinado conjunto de columnas de un fichero
	 * @param columnas Conjunto de nombres de la columna
	 * @return
	 */
	List<MSVMultiColumnValidator> getValidatorForColumns(List<String> columnas);

}
