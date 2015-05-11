package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidators;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;

/**
 * Clase genérica para comprobar los validadores
 * @author bruno
 *
 */
public abstract class GenericValidatorsTests {


	/**
	 * Comrprueba que se haya creado bien el validador para una determinada columna
	 * 
	 * @param columnName Nombre de la columna que queremos validar
	 * @param sql SQL de validación para la columna
	 * @param config 
	 * @param validator Validador que estamos comprobando
	 */
	protected void compruebaValidacionColumna(String columnName, String sql, Map<Integer, MSVResultadoValidacionSQL> config, MSVBusinessValidators validator) {
		MSVColumnValidator v = validator.getValidatorForColumn(columnName);
		validaResultado(v, columnName, sql, config);
	}
	
	/**
	 * Este método verifica que el validador se haya creado correctamente
	 * @param validador
	 * @param columnName Nombre de la columna que queremos validar
	 * @param config 
	 */
	protected abstract void validaResultado(MSVColumnValidator validador, String columnName, String sql, Map<Integer, MSVResultadoValidacionSQL> config);
	
}
