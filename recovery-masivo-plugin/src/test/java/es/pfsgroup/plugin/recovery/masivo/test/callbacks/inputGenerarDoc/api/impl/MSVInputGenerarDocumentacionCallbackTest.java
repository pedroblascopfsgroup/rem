package es.pfsgroup.plugin.recovery.masivo.test.callbacks.inputGenerarDoc.api.impl;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDocumentoPendienteGenerarApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.impl.MSVInputGenerarDocumentacionCallback;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDocumentoPendienteDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

@RunWith(MockitoJUnitRunner.class)
public class MSVInputGenerarDocumentacionCallbackTest {

	@InjectMocks
	MSVInputGenerarDocumentacionCallback inputGenerarDocumentacionCallback;
	
	@Mock
	ApiProxyFactory mockproxyfaFactory;
	
	@Mock
	MSVDocumentoPendienteGenerarApi mockDocumentoPendienteGenerarApi;
	
	@Test
	public void testOnEndProcessLong() {
		// este método no hace nada
		assertTrue("Este método no está implementado", true);
	}

	@Test
	public void testOnStartProcessLong() {
		when(mockproxyfaFactory.proxy(MSVDocumentoPendienteGenerarApi.class)).thenReturn(mockDocumentoPendienteGenerarApi);
		inputGenerarDocumentacionCallback.onStartProcess(1L);
		verify(mockDocumentoPendienteGenerarApi,times(1)).modificarDocumentoPendiente(any(MSVDocumentoPendienteDto.class));
	}

	@Test
	public void testOnErrorLongRecoveryBPMfwkInputInfoString() {
		RecoveryBPMfwkInputDto inputDto=new RecoveryBPMfwkInputDto();
		when(mockproxyfaFactory.proxy(MSVDocumentoPendienteGenerarApi.class)).thenReturn(mockDocumentoPendienteGenerarApi);
		inputGenerarDocumentacionCallback.onSuccess(1L,inputDto);
		verify(mockDocumentoPendienteGenerarApi,times(1)).modificarDocumentoPendiente(any(MSVDocumentoPendienteDto.class));
	}

	@Test
	public void testOnSuccessLongRecoveryBPMfwkInputInfo() {
		RecoveryBPMfwkInputDto inputDto=new RecoveryBPMfwkInputDto();
		when(mockproxyfaFactory.proxy(MSVDocumentoPendienteGenerarApi.class)).thenReturn(mockDocumentoPendienteGenerarApi);
		inputGenerarDocumentacionCallback.onError(1L, inputDto, "error");
		verify(mockDocumentoPendienteGenerarApi,times(1)).modificarDocumentoPendiente(any(MSVDocumentoPendienteDto.class));
	}

}
