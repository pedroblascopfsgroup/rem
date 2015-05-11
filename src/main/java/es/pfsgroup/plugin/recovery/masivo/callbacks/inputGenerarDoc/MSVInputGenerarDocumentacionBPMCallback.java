package es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc;

import es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.MSVInputGenerarDocumentacionCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVInputGenerarDocumentacionBPMCallback implements
		RecoveryBPMfwkCallback {

	@Override
	public String onError() {
		return MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		return MSVInputGenerarDocumentacionCallbackApi.MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSUCCESS;
	}

}
