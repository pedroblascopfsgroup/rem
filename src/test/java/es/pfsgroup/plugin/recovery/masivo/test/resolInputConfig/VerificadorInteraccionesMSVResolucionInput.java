package es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.Set;



import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolInput;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesProc;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;

/**
 * Verificaci�n de las interacciones del manager con otros objetos
 * <p>
 * Contiene un m�todo por cada verificaci�n que se quiera hacer en los tests.
 * </p>
 * @author pedro
 *
 */
public class VerificadorInteraccionesMSVResolucionInput {

	public void verifyObtenerTiposResolucionesTareas(GenericABMDao mockGenericDao, 
			MSVResolucionApi mockResolucionApi, MSVConfigResolInput mockConfigResolInput1, Set<MSVTipoResolucionDto> setTiposResolucionesTareas) {
		
		verify(mockResolucionApi, atLeast(1)).getTipoResolucionPorCodigo(any(String.class));
		
		verify(mockGenericDao, atLeast(1)).getList(eq(RecoveryBPMfwkTipoProcInput.class), any(Filter.class));

		verify(mockConfigResolInput1, atLeast(1)).getCodigoInput();
		
		assertTrue("Set retornado no debe ser vac�o", setTiposResolucionesTareas.size() > 0);

	}

	public void verifyObtenerTipoInputParaResolucion(
			GenericABMDao mockGenericDao,
			MSVResolucionApi mockMSVResolucionApi,
			MSVConfigResolInput mockConfigResolInput1) {
		
	}

	public void verifyObtenerTipoInputParaResolucion(String codigoTipoProc, 
			MSVConfigResolucionesProc mockConfigResolucionesProc,
			List<MSVConfigResolInput> mockListaTipoInputs2, String tipoInput, String tipoInputEsperado) {

		verify(mockConfigResolucionesProc, atLeastOnce()).getMapaConfigResoluciones();
		verify(mockConfigResolucionesProc.getMapaConfigResoluciones(), atLeastOnce()).get(eq(codigoTipoProc));
		
		verify(mockConfigResolucionesProc.getMapaConfigResoluciones().get(codigoTipoProc), atLeastOnce()).getMapaTiposResoluciones();
		
		assertEquals("Tipo input esperado no coincide", tipoInputEsperado, tipoInput);
		
	}

	public void verifyObtenerTipoInputParaResolucionNulo(String codigoTipoProc,
			MSVConfigResolucionesProc mockConfigResolucionesProc,
			List<MSVConfigResolInput> mockListaTipoInputs2, String tipoInput) {

		verify(mockConfigResolucionesProc, atLeastOnce()).getMapaConfigResoluciones();
		verify(mockConfigResolucionesProc.getMapaConfigResoluciones(), atLeastOnce()).get(eq(codigoTipoProc));
		
		verify(mockConfigResolucionesProc.getMapaConfigResoluciones().get(codigoTipoProc), atLeastOnce()).getMapaTiposResoluciones();
		
		assertTrue("El tipo de input esperado era nulo", tipoInput == null);
		
	}

}
