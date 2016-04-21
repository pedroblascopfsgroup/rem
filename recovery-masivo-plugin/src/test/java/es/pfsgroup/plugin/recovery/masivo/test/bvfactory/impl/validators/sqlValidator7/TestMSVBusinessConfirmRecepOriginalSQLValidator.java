package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators.sqlValidator7;

import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.reset;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.MSVBusinessConfirmRecepOriginalSQLValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLConfirmContratoOriginal;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators.sqlValidator4.MSVBusiness_OPERACIONES_SQLValidator;

/**
 * Testeamos el validador de confirmación recepción documentación original
 * @author Carlos
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class TestMSVBusinessConfirmRecepOriginalSQLValidator extends MSVBusiness_OPERACIONES_SQLValidator {
	
	@Mock
	private MSVFactoriaQuerysSQLConfirmContratoOriginal mockMsvQuerys;

	@InjectMocks
	private MSVBusinessConfirmRecepOriginalSQLValidator validator;

	@Test
	public void testCodigoTipoOperacion() {
		super.testCodigoTipoOperacion(MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_ORIGINAL, validator);
	}
	
	@Test
	public void testgetValidatorForColumn(){
		super.testGetValidatorForColumn(validator, mockMsvQuerys);
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
