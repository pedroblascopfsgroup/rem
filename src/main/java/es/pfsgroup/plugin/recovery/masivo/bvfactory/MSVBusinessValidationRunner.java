package es.pfsgroup.plugin.recovery.masivo.bvfactory;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVMultiColumnValidator;


/**
 * Interfaz del componente que se encargar� de ejecutar las validaciones de negocio.
 * @author bruno
 *
 */
public interface MSVBusinessValidationRunner {

	/**
	 * Ejecuta una validaci�n de negocio usando un validador proporcionado.
	 * @param validator Validador que se quiere usar.
	 * @param value valor que queremos validar
	 * @return
	 */
	MSVValidationResult runValidation(MSVColumnValidator validator, String value);

	/**
	 * Ejecuta una validaci�n compuesta de negocio usando un validador proporcionado.
	 * @param validator Validador que se quiere usar.
	 * @param mapaDatos valores que hemos de validar
	 * @return
	 */
	MSVValidationResult runCompositeValidation(List<MSVMultiColumnValidator> validadores,
			Map<String, String> mapaDatos);

}
