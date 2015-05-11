package es.pfsgroup.plugin.recovery.masivo.test.callbacks.lanzarEJTdesdeFM;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.MSVLanzarETJdesdeFMBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.api.MSVLanzarETJdesdeFMCallbackApi;

@RunWith(MockitoJUnitRunner.class)
public class MSVLanzarETJdesdeFMBPMCallbackTest {

	@InjectMocks
	MSVLanzarETJdesdeFMBPMCallback msvLanzarETJdesdeFMBPMCallback;
	
	@Test
	public void onError() {
		String resultado = msvLanzarETJdesdeFMBPMCallback.onError();
		assertEquals(MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONERROR, resultado);
	}

	@Test
	public void onProcessEnd() {
		String resultado = msvLanzarETJdesdeFMBPMCallback.onProcessEnd();
		assertEquals(MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONEND, resultado);
	}

	@Test
	public void onProcessStart() {
		String resultado = msvLanzarETJdesdeFMBPMCallback.onProcessStart();
		assertEquals(MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSTART, resultado);
	}

	@Test
	public void onSuccess() {
		String resultado = msvLanzarETJdesdeFMBPMCallback.onSuccess();
		assertEquals(MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSUCCESS, resultado);
	}

}
