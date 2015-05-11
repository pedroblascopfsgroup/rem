package es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig.bo;

import static org.mockito.Mockito.*;

import java.util.Set;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesProc;
import es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig.AbstractMSVResolucionInputManagerTests;

/**
 * Esta es la suite de test para probar el método obtenerTiposResolucionesTareas
 * 
 * @author pedro
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class obtenerTiposResolucionesTareasTest extends
		AbstractMSVResolucionInputManagerTests {

	@Override
	protected void beforeChild() {
	}

	@Override
	protected void afterChild() {
	}

	@Test
	public void testInicial() {
		
		mockConfigResolucionesProc = mock(MSVConfigResolucionesProc.class);
		when(mockConfigResolucionesProc.getMapaConfigResoluciones())
		.thenReturn(mockMapaConfigResoluciones);
		manager.setMapaResolInputProc(mockConfigResolucionesProc);

		simularInteracciones().simulaObtenerTiposResolucionesTareas();

		Set<MSVTipoResolucionDto> setTiposResolucionesTareas = manager
				.obtenerTiposResolucionesTareas(1L);

		verificarInteracciones().verifyObtenerTiposResolucionesTareas(mockGenericDao,
				mockMSVResolucionApi, mockConfigResolInput1, setTiposResolucionesTareas);
		

	}
	
	@Test
	public void testMapaResolInputProcNulo() {

		simularInteracciones().simulaMapaResolInputProcNulo();

		Set<MSVTipoResolucionDto> setTiposResolucionesTareas = manager.obtenerTiposResolucionesTareas(1L);

		

	}

}
