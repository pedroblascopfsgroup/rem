package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.iml.MSVBusinessValidationSQLRunnerImpl;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVValidationResult;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.MSVBusinessValidationSQLRunnerImpl;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnSQLValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQLERROR;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQLOK;

/**
 * Esta es la suite de tests para probar la validación de negocio mediante el
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVBusinessValidationSQLRunnerTests {

	private static final String SQL_VALIDACION = "SELECT * FROM GIRLS WHERE FREE_SEX = TRUE";

	private static final String DEFAULT_ERROR_MESSAGE = "DEFAULT ERROR MESSAGE";

	private static final String DATO_A_VALIDAR = "dato a validar";

	private static final Integer CODIGO_OK = 0;
	
	private static final Integer CODIGO_ERROR = 1;
	
	private Random r = new Random();

	@InjectMocks
	private MSVBusinessValidationSQLRunnerImpl runner;

	@Mock
	private MSVColumnSQLValidator mockValidator;

	@Mock
	private MSVRawSQLDao mockRawDao;

	private Map<Integer, MSVResultadoValidacionSQL> resultConfig ;

	@Before
	public void before() {
		resultConfig = new HashMap<Integer, MSVResultadoValidacionSQL>();
		resultConfig.put(0, new MSVResultadoValidacionSQLOK());
		resultConfig.put(1, new MSVResultadoValidacionSQLERROR(DEFAULT_ERROR_MESSAGE));
	}

	@After
	public void after() {
		reset(mockValidator);
		reset(mockRawDao);
		resultConfig = null;
	}

	/**
	 * Es obligatorio pasarle al runner un validador con soporte SQL,
	 * comprobamos que si le pasamos un validador de cualquier otro tipo se
	 * produce una excepción
	 */
	@Test(expected = IllegalArgumentException.class)
	public void testIncompatibilidadValidators() {

		runner.runValidation(new MSVColumnValidator() {

			@Override
			public String getTipoValidacion() {
				// Nos da igual el tipo de validación
				return null;
			}

			@Override
			public String getErrorMessage() {
				// Nos da igual el mensaje de error
				return null;
			}

			@Override
			public boolean isRequired() {
				// Nos da igual si es requerido
				return false;
			}

			@Override
			public Map<Integer, MSVResultadoValidacionSQL> getResultConfig() {
				// TODO Auto-generated method stub
				return null;
			}
		}, null);
	}

	/**
	 * La validación es OK y el dato a validar debe existir
	 */
	@Test
	public void testValidationOK_valorDebeExistir() {
		configuraMocks(MSVColumnValidator.DEBE_EXISTIR, Math.abs(r.nextInt() + 1));

		MSVValidationResult result = runner.runValidation(mockValidator, DATO_A_VALIDAR);

		assertTrue("No se ha validado correctamente", result.isValid());
		assertNull("Cuando el resultado es válido, no debe haber mensaje de error", result.getErrorMessage());
	}

	/**
	 * La validación es OK y el dato a validar no debe existir
	 */
	@Test
	public void testValidationOK_valorNODebeExistir() {
		configuraMocks(MSVColumnValidator.NO_DEBE_EXISTIR, 0);

		MSVValidationResult result = runner.runValidation(mockValidator, DATO_A_VALIDAR);

		assertTrue("No se ha validado correctamente", result.isValid());
		assertNull("Cuando el resultado es válido, no debe haber mensaje de error", result.getErrorMessage());
	}

	/**
	 * La validación es OK y el validador es de tipo configurable
	 */
	@Test
	public void testValidationOK_configurable() {
		configuraMocks(MSVColumnSQLValidator.CONFIGURABLE, CODIGO_OK, resultConfig);

		MSVValidationResult result = runner.runValidation(mockValidator, DATO_A_VALIDAR);

		assertTrue("No se ha validado correctamente", result.isValid());
		assertNull("Cuando el resultado es válido, no debe haber mensaje de error", result.getErrorMessage());

	}

	/**
	 * La validación es ERROR y el dato a validar debe existir
	 */
	@Test
	public void testValidationERROR_valorDebeExistir() {
		configuraMocks(MSVColumnValidator.DEBE_EXISTIR, 0);

		MSVValidationResult result = runner.runValidation(mockValidator, DATO_A_VALIDAR);

		assertFalse("No debería haber validado", result.isValid());
		assertNotNull("Cuando el resultado no es válido, debe haber mensaje de error", result.getErrorMessage());
	}

	/**
	 * La validación es ERROR y el dato a validar no debe existir
	 */
	@Test
	public void testValidationERROR_valorNODebeExistir() {
		configuraMocks(MSVColumnValidator.NO_DEBE_EXISTIR, Math.abs(r.nextInt() + 1));

		MSVValidationResult result = runner.runValidation(mockValidator, DATO_A_VALIDAR);

		assertFalse("No debería haber validado", result.isValid());
		assertNotNull("Cuando el resultado no es válido, debe haber mensaje de error", result.getErrorMessage());
	}

	/**
	 * La validación es OK y el validador es de tipo configurable
	 */
	@Test
	public void testValidationERROR_configurable() {
		configuraMocks(MSVColumnValidator.CONFIGURABLE, CODIGO_ERROR, resultConfig);

		MSVValidationResult result = runner.runValidation(mockValidator, DATO_A_VALIDAR);

		assertFalse("No debería haber validado", result.isValid());
		assertNotNull("Cuando el resultado no es válido, debe haber mensaje de error", result.getErrorMessage());
		assertEquals("El mensaje de error no coincide",  DEFAULT_ERROR_MESSAGE, result.getErrorMessage());

	}

	/**
	 * Este método configura el comportamiento para mockValidator y mockRawDao
	 * 
	 * @param tipoValidacion
	 *            Indica el tipo de validación como una de las constantes
	 *            definidas en {@link MSVColumnValidator}
	 * @param count
	 *            Contador de resultados que devuelve tiene que devolver el test
	 */
	private void configuraMocks(String tipoValidacion, int count) {
		if (MSVColumnValidator.CONFIGURABLE.equals(tipoValidacion)) {
			throw new IllegalStateException("Este método configuramocks no es válido para el tipo de validación CONFIGURABLE");
		}
		when(mockValidator.giveMeSqlChe(DATO_A_VALIDAR)).thenReturn(SQL_VALIDACION);
		when(mockValidator.getTipoValidacion()).thenReturn(tipoValidacion);
		when(mockValidator.getErrorMessage()).thenReturn(DEFAULT_ERROR_MESSAGE);
		when(mockValidator.getResultConfig()).thenReturn(null);

		// Simulamos que el DAO siempre nos devuelva algún resultado
		when(mockRawDao.getCount(SQL_VALIDACION)).thenReturn(count);
	}

	private void configuraMocks(String tipoValidacion, int resultadoSQL, Map<Integer, MSVResultadoValidacionSQL> config) {
		if (!MSVColumnValidator.CONFIGURABLE.equals(tipoValidacion)) {
			throw new IllegalStateException("Este método configuramocks no es válido para el tipo de validación CONFIGURABLE");
		}
		when(mockValidator.giveMeSqlChe(DATO_A_VALIDAR)).thenReturn(SQL_VALIDACION);
		when(mockValidator.getTipoValidacion()).thenReturn(tipoValidacion);
		when(mockValidator.getErrorMessage()).thenReturn(null);
		when(mockValidator.getResultConfig()).thenReturn(config);

		// Simulamos que el DAO siempre nos devuelva algún resultado
		when(mockRawDao.getExecuteSQL(SQL_VALIDACION)).thenReturn(resultadoSQL);

	}

}
