package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators.sqlValidator5;

import static org.mockito.Mockito.*;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.MSVBusinessConfirmRecepDocuImpresaSQLValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLConfirmRecepDocuImpresa;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.test.bvfactory.impl.validators.sqlValidator4.MSVBusiness_OPERACIONES_SQLValidator;

/**
 * Testeamos el validador de confirmación recepción documentación impresa
 * @author Carlos
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class TestReturnValidatorsConfirmRecepDocuImpresa extends MSVBusiness_OPERACIONES_SQLValidator {
	
	@Mock
	private MSVFactoriaQuerysSQLConfirmRecepDocuImpresa mockMsvQuerys;

	@InjectMocks
	private MSVBusinessConfirmRecepDocuImpresaSQLValidator validator;

	@Test
	public void testCodigoTipoOperacion() {
		super.testCodigoTipoOperacion(MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_DOCUMENTACION_IMPRESA, validator);
	}
	
	@Test
	public void testgetValidatorForColumn(){
		super.testGetValidatorForColumn(validator, mockMsvQuerys);
	}
	
	@After
	public void limpiar() {
		reset(mockMsvQuerys);
	}
	
}
