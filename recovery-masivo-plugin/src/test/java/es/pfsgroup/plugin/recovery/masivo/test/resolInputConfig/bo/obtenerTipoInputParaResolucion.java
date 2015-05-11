package es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig.bo;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolInput;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesProc;
import es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig.AbstractMSVResolucionInputManagerTests;

/**
 * Esta es la suite de test para probar el método obtenerTipoInputParaResolucion
 * 
 * @author pedro
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class obtenerTipoInputParaResolucion extends
		AbstractMSVResolucionInputManagerTests {

	@Override
	protected void beforeChild() {
	}

	@Override
	protected void afterChild() {
	}

	/**
	 * Comprobamos que se recuperer correctamente el tipo de input esperado
	 * según la configuración
	 */
	@Test
	public void testPositivo() {
		
		mockConfigResolucionesProc = mock(MSVConfigResolucionesProc.class);
		when(mockConfigResolucionesProc.getMapaConfigResoluciones())
		.thenReturn(mockMapaConfigResoluciones);
		manager.setMapaResolInputProc(mockConfigResolucionesProc);

		simularInteracciones().simulaObtenerTipoInputParaResolucion();

		Map<String, String> mapaValores = new HashMap<String, String>();
		mapaValores.put("tieneProc", MSVConfigResolInput.TRUE);
		mapaValores.put("d_resultadoPositivo", MSVConfigResolInput.POSITIVO);
		mapaValores.put("d_demandaTotal", MSVConfigResolInput.PARCIAL);
		mapaValores.put("d_tipoComunicacion", MSVConfigResolInput.DENEGADA);

		String tipoInput = manager.obtenerTipoInputParaResolucion(1000L, codigoProc,
				codigoTipoResol2, mapaValores);

		String tipoInputEsperado = "DEM_INADMITIDA_CPROC";
		
		verificarInteracciones().verifyObtenerTipoInputParaResolucion(codigoProc,
				mockConfigResolucionesProc, mockListaTipoInputs2, tipoInput, tipoInputEsperado);

	}

	/**
	 * Comprobamos que se no se recuperera ningun tipo de input 
	 * ya que ninguno cumple con las especificaciones
	 */
	@Test(expected=BusinessOperationException.class)
	public void testNegativo() {

		mockConfigResolucionesProc = mock(MSVConfigResolucionesProc.class);
		when(mockConfigResolucionesProc.getMapaConfigResoluciones())
		.thenReturn(mockMapaConfigResoluciones);
		manager.setMapaResolInputProc(mockConfigResolucionesProc);
		
		simularInteracciones().simulaObtenerTipoInputParaResolucion();

		Map<String, String> mapaValores = new HashMap<String, String>();
		mapaValores.put("tieneProc", MSVConfigResolInput.FALSE);
		mapaValores.put("d_resultadoPositivo", MSVConfigResolInput.POSITIVO);
		mapaValores.put("d_demandaTotal", MSVConfigResolInput.PARCIAL);
		mapaValores.put("d_tipoComunicacion", MSVConfigResolInput.DENEGADA);

		String tipoInput = manager.obtenerTipoInputParaResolucion(1000L, codigoProc,
				codigoTipoResol2, mapaValores);

		verificarInteracciones().verifyObtenerTipoInputParaResolucionNulo(codigoProc,
				mockConfigResolucionesProc, mockListaTipoInputs2, tipoInput);

	}
	
	@Test(expected=BusinessOperationException.class)
	public void testMapaResolInputProcNulo() {

		simularInteracciones().simulaObtenerTipoInputParaResolucion();

		Map<String, String> mapaValores = new HashMap<String, String>();
		mapaValores.put("tieneProc", MSVConfigResolInput.TRUE);
		mapaValores.put("d_resultadoPositivo", MSVConfigResolInput.POSITIVO);
		mapaValores.put("d_demandaTotal", MSVConfigResolInput.PARCIAL);
		mapaValores.put("d_tipoComunicacion", MSVConfigResolInput.DENEGADA);

		String tipoInput = manager.obtenerTipoInputParaResolucion(1000L, codigoProc,
				codigoTipoResol2, mapaValores);
		

	}

}
