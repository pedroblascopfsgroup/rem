package es.pfsgroup.plugin.recovery.masivo.test.callbacks.inputGenerarDoc;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.MSVInputGenerarDocumentacionBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.MSVInputGenerarDocumentacionCallbackApi;

@RunWith(MockitoJUnitRunner.class)
public class MSVInputGenerarDocumentacionBPMCallbackTest {

	@InjectMocks
	MSVInputGenerarDocumentacionBPMCallback inputGenerarDocumentacionBPMCallback;
	
	@Test
	public void testOnError() {
		String resultado = inputGenerarDocumentacionBPMCallback.onError();
		assertEquals(MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONERROR, resultado);
	}

	@Test
	public void testOnProcessEnd() {
		String resultado= inputGenerarDocumentacionBPMCallback.onProcessEnd();
		assertEquals(MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONEND, resultado);
	}

	@Test
	public void testOnProcessStart() {
		String resultado= inputGenerarDocumentacionBPMCallback.onProcessStart();
		assertEquals(MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSTART, resultado);
	}

	@Test
	public void testOnSuccess() {
		String resultado= inputGenerarDocumentacionBPMCallback.onSuccess();
		assertEquals(MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSUCCESS, resultado);
	}

}
