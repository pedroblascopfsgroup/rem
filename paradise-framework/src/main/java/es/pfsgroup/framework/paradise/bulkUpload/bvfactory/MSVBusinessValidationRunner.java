package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

import java.util.List;
import java.util.Map;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;


/**
 * Interfaz del componente que se encargará de ejecutar las validaciones de negocio.
 * @author bruno
 *
 */
public interface MSVBusinessValidationRunner {

	/**
	 * Ejecuta una validación de negocio usando un validador proporcionado.
	 * @param validator Validador que se quiere usar.
	 * @param value valor que queremos validar
	 * @return
	 */
	MSVValidationResult runValidation(MSVColumnValidator validator, String value);

	/**
	 * Ejecuta una validación compuesta de negocio usando un validador proporcionado.
	 * @param validadores Validador que se quiere usar.
	 * @param mapaDatos valores que hemos de validar
	 * @return
	 */
	MSVValidationResult runCompositeValidation(List<MSVMultiColumnValidator> validadores,
			Map<String, String> mapaDatos);

}
