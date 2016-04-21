package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators.sqlValidator;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.MSVBusinessAltaAsuntosSQLValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLValidarAltaAsuntos;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQLERROR;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQLOK;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVGenericContratoColumns;

/**
 * Test del validador de alta de asuntos.
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class TestMSVBusinessAltaAsuntosSQLValidator {

	private static final String TEST_VALUE = "THIS IS A TEST VALUE";
	private static final String MSG_ERROR = "Este es el mensaje de error";
	
	@Mock
	private MSVFactoriaQuerysSQLValidarAltaAsuntos mockMsvQuerys;

	@InjectMocks
	private MSVBusinessAltaAsuntosSQLValidator validator;

	@Test
	public void testCodigoTipoOperacion() {
		assertEquals(MSVDDOperacionMasiva.CODIGO_ALTA_ASUNTOS, validator.getCodigoTipoOperacion());
	}
	
	@Test
	public void testgetValidatorForColumn(){
		//Prueba1 - El nombre de la columna es nulo
		String colName = null;
		MSVColumnValidator result = validator.getValidatorForColumn(colName);
		assertNull(result);
		
		//Prueba2 - No encuentra la sql
		colName = MSVGenericContratoColumns.NUM_CONTRATO;
		result = validator.getValidatorForColumn(colName);
		assertNull(result);
		
		//Prueba3 - Funcionamiento correcto
		Map<Integer, MSVResultadoValidacionSQL> configValidacionNumContrato = new HashMap<Integer, MSVResultadoValidacionSQL>();
		MSVResultadoValidacionSQL msvResultError = new MSVResultadoValidacionSQLERROR(MSG_ERROR);
		MSVResultadoValidacionSQL msvResultOK = new MSVResultadoValidacionSQLOK();
		
		configValidacionNumContrato.put(1, msvResultError);
		configValidacionNumContrato.put(2, msvResultOK);
		
		when(mockMsvQuerys.getSql(colName)).thenReturn(TEST_VALUE);		
		when(mockMsvQuerys.getConfig(colName)).thenReturn(configValidacionNumContrato);	

		result = validator.getValidatorForColumn(colName);
		
		assertEquals("El tamaño del mapa no coincide", 2, result.getResultConfig().size());
		assertTrue("Se esperaba un error en la primera posición del mapa de configuración", result.getResultConfig().get(1).isError());
		assertEquals("No coincide el mensaje de error", MSG_ERROR, result.getResultConfig().get(1).getErrorMessage());
		assertFalse("La segunda posición no es error", result.getResultConfig().get(2).isError());
	}
	
	@Test
	public void testNullmsvQuerys(){
		String colName = RandomStringUtils.random(15);
		validator.setMsvQuerys(null);
		MSVColumnValidator result = validator.getValidatorForColumn(colName);
		assertNull(result);
		
	}
	
	@After
	public void limpiar() {
			reset(mockMsvQuerys);
	}
}
