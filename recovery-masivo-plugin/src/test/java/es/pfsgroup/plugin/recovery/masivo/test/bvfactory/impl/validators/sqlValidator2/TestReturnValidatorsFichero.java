package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators.sqlValidator2;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.MSVBusinessConfirmRecepOriginalSQLValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLConfirmContratoOriginal;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQLERROR;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQLOK;
import es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators.GenericValidatorsTests;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVConfirmContratoOriginalColumns;

/**
 * Suite que comprueba que devolvemos los validadores correctos para el fichero
 * de Confirmación del la rececpción del original
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class TestReturnValidatorsFichero extends GenericValidatorsTests {

	private static final String TEST_VALUE = "THIS IS A TEST VALUE";

	@InjectMocks
	private MSVBusinessConfirmRecepOriginalSQLValidator validator;
	
	@Mock
	MSVFactoriaQuerysSQLConfirmContratoOriginal mockQuerys;

	String colName = MSVConfirmContratoOriginalColumns.NUM_CONTRATO;
	Map<Integer, MSVResultadoValidacionSQL> CONFIG_VALIDACION_NUM_CONTRATO = new HashMap<Integer, MSVResultadoValidacionSQL>();
	{
		CONFIG_VALIDACION_NUM_CONTRATO.put(0, new MSVResultadoValidacionSQLOK());
		CONFIG_VALIDACION_NUM_CONTRATO.put(1, new MSVResultadoValidacionSQLERROR("No existe el contrato"));
		CONFIG_VALIDACION_NUM_CONTRATO.put(2, new MSVResultadoValidacionSQLERROR("No existe el expediente asociado al contrato"));
	}
	
	@Before
	public void before() {		
		when(mockQuerys.getSql(colName)).thenReturn("Select * from cnt_contrato where cnt_contrato = "+MSVColumnMultiResultSQL.VALUE_TOKEN);
		when(mockQuerys.getConfig(colName)).thenReturn(CONFIG_VALIDACION_NUM_CONTRATO);		
	}
	/**
	 * Testeamos que devolvemos el valdiador correcto para la columna
	 * NumeroContrato
	 */
	@Test
	public void testNumeroContrato() {
		
		compruebaValidacionColumna(colName, mockQuerys.getSql(colName), CONFIG_VALIDACION_NUM_CONTRATO, validator);
	}
	
	@Test
	public void testNullmsvQuerys(){
		String colName = RandomStringUtils.random(15);
		validator.setMsvQuerys(null);
		MSVColumnValidator result = validator.getValidatorForColumn(colName);
		assertNull(result);
		
	}

	@Override
	protected void validaResultado(MSVColumnValidator validador, String columnName, String sql, Map<Integer, MSVResultadoValidacionSQL> config) {		
		assertNotNull("No se ha devuelto el validador para la columna " + columnName, validador);
		assertTrue("El validador devuelto no es del tipo esperado", validador instanceof MSVColumnMultiResultSQL);
		MSVColumnMultiResultSQL sqlv = (MSVColumnMultiResultSQL) validador;
		assertEquals("El tipo de validación no es el correcto", MSVColumnValidator.CONFIGURABLE, validador.getTipoValidacion());
		String expected = sql.substring(0, 20);
		String current = sqlv.giveMeSqlChe(TEST_VALUE).substring(0, 20);
		assertEquals("La SQL no es la correcta", expected, current);
		assertTrue("No se ha sustituido correctamente el valor de la celda", sqlv.giveMeSqlChe(TEST_VALUE).indexOf(TEST_VALUE) > 0);
		assertFalse("De momento los validadores de negocio no son requiered", validador.isRequired());
		assertEquals("La configuración de validación no es la esperada", config, validador.getResultConfig());

	}
}
