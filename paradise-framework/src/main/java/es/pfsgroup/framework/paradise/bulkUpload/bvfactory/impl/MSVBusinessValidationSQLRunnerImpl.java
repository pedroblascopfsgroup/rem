package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnSQLValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVResultadoValidacionSQL;

@Component
public class MSVBusinessValidationSQLRunnerImpl implements MSVBusinessValidationRunner {

	public static final String VALUETOKEN = "VALUETOKEN";
	
	@Autowired
	private MSVRawSQLDao rawDao;

	@Override
	public MSVValidationResult runValidation(MSVColumnValidator validator, String value) {
		if (validator instanceof MSVColumnSQLValidator) {
			if (Checks.esNulo(value) && validator.isRequired()) {
				// Si el valor es nulo y es requerido falla la validación
				return new MSVValidationResult(false, "Valor requerido");
			} else if (!Checks.esNulo(value)) {

				if (MSVColumnValidator.DEBE_EXISTIR.equals(validator.getTipoValidacion())) {
					return runValidationDebeExistir(validator, value);
				} else if (MSVColumnValidator.NO_DEBE_EXISTIR.equals(validator.getTipoValidacion())) {
					return runValidacionNoDebeExistir(validator, value);
				} else  {
					// Si no es de tipo DEBE_EXISTIR o NO_DEBE_EXISTIR obligamos a que sea de tipo configurable
					return runValidacionConfigurable(validator, value);
				}
			} else {
				// Si el valor es nulo pero no es requerido pasa la validación
				return new MSVValidationResult(true, null);
			}
		} else {
			throw new IllegalArgumentException();
		}
	}

	/**
	 * Realiza una validación de tipo configurable, para ello ejecuta la SQL
	 * contenida en el validador talcual y compara el resultado con la
	 * configruación que contiene el mismo validador
	 * 
	 * @param validator
	 * @param value
	 * @return
	 */
	private MSVValidationResult runValidacionConfigurable(MSVColumnValidator validator, String value) {
		int count = executeSQL(validator, value);
		MSVResultadoValidacionSQL result = validator.getResultConfig().get(count);
		boolean valid = !result.isError();
		return new MSVValidationResult(valid, valid ? null : result.getErrorMessage());
	}

	

	/**
	 * Valida que el registro no exista, para ello realiza un count
	 * 
	 * @param validator
	 * @param value
	 * @return
	 */
	private MSVValidationResult runValidacionNoDebeExistir(MSVColumnValidator validator, String value) {
		int count = executeCount(validator, value);
		boolean valid = count == 0;
		return new MSVValidationResult(valid, valid ? null : validator.getErrorMessage());
	}

	/**
	 * Valida que el registro exista, para ello hace un count
	 * 
	 * @param validator
	 * @param value
	 * @return
	 */
	private MSVValidationResult runValidationDebeExistir(MSVColumnValidator validator, String value) {
		int count = executeCount(validator, value);
		boolean valid = count > 0;
		return new MSVValidationResult(valid, valid ? null : validator.getErrorMessage());

	}

	/**
	 * Realiza counts en base a las SQL contenidas en un validador y el valor
	 * pasado
	 * 
	 * @param validator
	 * @param value
	 * @return
	 */
	private int executeCount(MSVColumnValidator validator, String value) {
		MSVColumnSQLValidator sqlValidator = (MSVColumnSQLValidator) validator;
		int count = rawDao.getCount(sqlValidator.giveMeSqlChe(value));
		return count;
	}
	
	/**
	 * Ejecuta una SQL talcual (la contenida en el validador) y devuelve el resultado
	 * @param validator
	 * @param value
	 * @return
	 */
	private int executeSQL(MSVColumnValidator validator, String value) {
		MSVColumnSQLValidator sqlValidator = (MSVColumnSQLValidator) validator;
		int result = Integer.parseInt(rawDao.getExecuteSQL(sqlValidator.giveMeSqlChe(value)));
		return result;
	}

	/**
	 * Ejecuta una validación compuesta de negocio usando un validador proporcionado.
	 * @param validatores Lista de validadores que se quieren usar.
	 * @param mapaDatos valores que hemos de validar
	 * @return
	 */
	@Override
	public MSVValidationResult runCompositeValidation(List<MSVMultiColumnValidator> validadores,
			Map<String, String> mapaDatos) {

		boolean valid = true;
		StringBuffer mensajeError = new StringBuffer("");
		
		for (MSVMultiColumnValidator validador : validadores) {
			String sql = this.parsearSQL(validador.getSqlValidacion(), validador.getCombinacionColumnas(), mapaDatos);
			int count = this.ejecutarSQLValidacionMulti(sql);
			MSVResultadoValidacionSQL result = validador.getResultConfig().get(count);
			valid = (valid && !result.isError());
			mensajeError.append(result.isError() ? result.getErrorMessage() : "" );
		}
		MSVValidationResult resultado = new MSVValidationResult(valid, valid ? null : mensajeError.toString());
		return resultado;

	}

	private String parsearSQL(String sqlValidacion,
			List<String> combinacionColumnas, Map<String, String> mapaDatos) {
		
		String resultado = sqlValidacion
				.replaceAll("\\t", " ").replaceAll("\\n", " ");
		for (int i=0; i<combinacionColumnas.size(); i++) {
			String valor = mapaDatos.get(combinacionColumnas.get(i));
			String mascara = VALUETOKEN + i;
			resultado = resultado.replaceAll(mascara, valor);
		}
		return resultado;
	}

	private int ejecutarSQLValidacionMulti(String sql) {
		int result = Integer.parseInt(rawDao.getExecuteSQL(sql));
		return result;
	}

}
